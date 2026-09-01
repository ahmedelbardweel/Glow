import 'dart:async';
import 'package:flutter/foundation.dart';
import '../database/hive_service.dart';
import 'supabase_service.dart';
import '../../features/child/data/models/child_models.dart';
import '../../features/child/data/repositories/child_repository.dart';

/// Central coordinator for offline-first data synchronization.
/// Balances local Hive performance with Supabase remote persistence.
class OfflineFirstSyncManager {
  OfflineFirstSyncManager._();

  static bool _isSyncing = false;
  static bool get isSyncing => _isSyncing;

  /// Initializes services and triggers initial background synchronization.
  static Future<void> initializeAndSync() async {
    await SupabaseService.init();

    if (SupabaseService.isReady) {
      try {
        final currentProfile = ChildRepository.getChildProfile();
        await SupabaseService.upsertRemoteChildProfile(currentProfile);
      } catch (e) {
        debugPrint('[Sync] Initial profile sync warning: $e');
      }
    }

    unawaited(syncDownFromCloud());
    unawaited(syncUpPendingQueue());
  }

  /// Synchronizes remote records down to local Hive storage.
  static Future<void> syncDownFromCloud() async {
    if (!SupabaseService.isReady) return;

    try {
      // 1. Sync dynamic worlds and missions
      await syncDynamicWorldsAndContent();

      // 2. Sync announcements
      final announcements = await SupabaseService.fetchAnnouncements();
      if (announcements.isNotEmpty) {
        await HiveService.saveCachedAnnouncements(announcements.map((a) => a.toMap()).toList());
      }

      // 3. Sync child profile and progress
      final currentProfile = ChildRepository.getChildProfile();
      final remoteData = await SupabaseService.fetchRemoteChildProfile(currentProfile.childId);

      if (remoteData != null) {
        final remoteMissions = (remoteData['completed_missions'] as List<dynamic>?)
                ?.map((m) => m['mission_id']?.toString() ?? '')
                .where((id) => id.isNotEmpty)
                .toList() ??
            [];

        final remoteBadges = (remoteData['earned_badges'] as List<dynamic>?)
                ?.map((b) => b['badge_name']?.toString() ?? '')
                .where((b) => b.isNotEmpty)
                .toList() ??
            [];

        final mergedProfile = currentProfile.copyWith(
          childId: remoteData['child_code']?.toString() ?? currentProfile.childId,
          stars: (remoteData['stars'] as num?)?.toInt() ?? currentProfile.stars,
          points: (remoteData['points'] as num?)?.toInt() ?? currentProfile.points,
          currentWorld: (remoteData['current_world'] as num?)?.toInt() ?? currentProfile.currentWorld,
          selectedCharacter: remoteData['selected_character']?.toString() ?? currentProfile.selectedCharacter,
          parentEmail: remoteData['parent_id']?.toString() ?? currentProfile.parentEmail,
          completedMissions: {
            ...currentProfile.completedMissions,
            ...remoteMissions,
          }.toList(),
          earnedBadges: {
            ...currentProfile.earnedBadges,
            ...remoteBadges,
          }.toList(),
        );

        await ChildRepository.saveChildProfile(mergedProfile);
        debugPrint('[Sync] Updated local child profile from cloud state.');
      } else {
        debugPrint('[Sync] Uploading local profile (${currentProfile.childId}) to cloud...');
        await SupabaseService.upsertRemoteChildProfile(currentProfile);
        for (final missionId in currentProfile.completedMissions) {
          await SupabaseService.recordRemoteCompletedMission(
            childName: currentProfile.name,
            childCode: currentProfile.childId,
            missionId: missionId,
            stars: 3,
            points: 150,
            habitName: 'العادة',
          );
        }
        debugPrint('[Sync] Uploaded existing profile to cloud.');
      }
    } catch (e) {
      debugPrint('[Sync] Sync down error: $e');
    }
  }

  /// Synchronizes remote worlds and missions into local Hive cache.
  static Future<void> syncDynamicWorldsAndContent() async {
    if (!SupabaseService.isReady) return;
    try {
      final remoteWorlds = await SupabaseService.fetchRemoteWorldsAndMissions();
      if (remoteWorlds.isNotEmpty) {
        await ChildRepository.saveCachedWorlds(remoteWorlds);
        debugPrint('[Sync] Synced ${remoteWorlds.length} worlds to local cache.');
      } else {
        debugPrint('[Sync] No remote worlds found. Seeding initial worlds...');
        await SupabaseService.seedInitialDataToSupabase(ChildRepository.defaultWorlds);
        await ChildRepository.saveCachedWorlds(ChildRepository.defaultWorlds);
      }
    } catch (e) {
      debugPrint('[Sync] Error syncing dynamic worlds: $e');
    }
  }

  /// Records mission completion locally and attempts remote upload.
  static Future<void> recordMissionCompletion({
    required ChildProfileModel updatedProfile,
    required String missionId,
    required int earnedStars,
    required int earnedPoints,
    required String habitName,
  }) async {
    // 1. Instant local persistence in Hive
    await ChildRepository.saveChildProfile(updatedProfile);
    await HiveService.saveHabitStatus('h_$missionId', 'learned');

    // 2. Direct cloud upload if connected
    if (SupabaseService.isReady) {
      final success = await SupabaseService.recordRemoteCompletedMission(
        childName: updatedProfile.name,
        childCode: updatedProfile.childId,
        missionId: missionId,
        stars: earnedStars,
        points: earnedPoints,
        habitName: habitName,
      );

      await SupabaseService.upsertRemoteChildProfile(updatedProfile);

      if (success) {
        debugPrint('[Sync] Mission $missionId synced to cloud.');
        return;
      }
    }

    // 3. Queue for background sync if offline
    final queueKey = 'mission_${missionId}_${DateTime.now().millisecondsSinceEpoch}';
    await HiveService.addToSyncQueue(queueKey, {
      'type': 'complete_mission',
      'child_name': updatedProfile.name,
      'child_code': updatedProfile.childId,
      'mission_id': missionId,
      'stars': earnedStars,
      'points': earnedPoints,
      'habit_name': habitName,
      'profile': updatedProfile.toMap(),
    });

    debugPrint('[Sync] Enqueued mission $missionId for background upload.');
  }

  /// Flushes pending offline transactions to the remote cloud.
  static Future<void> syncUpPendingQueue() async {
    if (_isSyncing || !SupabaseService.isReady) return;

    _isSyncing = true;
    try {
      final queue = HiveService.getSyncQueue();
      if (queue.isEmpty) {
        _isSyncing = false;
        return;
      }

      debugPrint('[Sync] Processing ${queue.length} pending offline transactions...');

      for (final entry in queue.entries) {
        final key = entry.key.toString();
        final data = Map<String, dynamic>.from(entry.value as Map);
        final type = data['type']?.toString();

        bool success = false;
        if (type == 'complete_mission') {
          success = await SupabaseService.recordRemoteCompletedMission(
            childName: data['child_name']?.toString() ?? '',
            missionId: data['mission_id']?.toString() ?? '',
            stars: (data['stars'] as num?)?.toInt() ?? 0,
            points: (data['points'] as num?)?.toInt() ?? 0,
            habitName: data['habit_name']?.toString() ?? '',
          );

          if (data['profile'] != null) {
            final profile = ChildProfileModel.fromMap(Map<String, dynamic>.from(data['profile'] as Map));
            await SupabaseService.upsertRemoteChildProfile(profile);
          }
        }

        if (success) {
          await HiveService.removeFromSyncQueue(key);
          debugPrint('[Sync] Uploaded queued item $key.');
        }
      }
    } catch (e) {
      debugPrint('[Sync] Error processing offline queue: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Clears local cache storage for development and testing.
  static Future<void> resetLocalCache() async {
    await HiveService.clearAll();
    debugPrint('[Sync] Local storage cleared.');
  }
}
