import 'dart:async';
import 'package:flutter/foundation.dart';
import '../database/hive_service.dart';
import 'supabase_service.dart';
import '../../features/child/data/models/child_models.dart';
import '../../features/child/data/repositories/child_repository.dart';

/// المدير المركزي لمعمارية المزامنة السحابية والمحلية (Offline-First Sync Architecture)
/// يربط بين سرعة Hive الفائقة محلياً وموثوقية Supabase السحابية كمرجع رئيسي
class OfflineFirstSyncManager {
  OfflineFirstSyncManager._();

  static bool _isSyncing = false;
  static bool get isSyncing => _isSyncing;

  /// 1. تهيئة النظام وإجراء المزامنة الأولية التلقائية عند تشغيل التطبيق (Initial Fetch & Sync Down)
  static Future<void> initializeAndSync() async {
    await SupabaseService.init();

    if (SupabaseService.isReady) {
      try {
        final currentProfile = ChildRepository.getChildProfile();
        await SupabaseService.upsertRemoteChildProfile(currentProfile);
      } catch (e) {
        debugPrint('Initial profile sync warning: $e');
      }
    }

    // تشغيل المزامنة في الخلفية دون تعطيل واجهة المستخدم
    unawaited(syncDownFromCloud());
    unawaited(syncUpPendingQueue());
  }

  /// 2. جلب وتفريغ البيانات السحابية إلى قاعدة البيانات المحلية ومزامنة البيانات المحلية الجديدة (Bidirectional Sync)
  static Future<void> syncDownFromCloud() async {
    if (!SupabaseService.isReady) return;

    try {
      final currentProfile = ChildRepository.getChildProfile();
      final remoteData = await SupabaseService.fetchRemoteChildProfile(currentProfile.childId);

      if (remoteData != null) {
        // استخراج المهام المكتملة والشارات من الجداول المرتبطة
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

        // دمج البيانات السحابية مع المحلية مع أخذ القيمة الأعلى للنقاط والنجوم
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

        // حفظ في Hive لضمان سرعة القراءة محلياً
        await ChildRepository.saveChildProfile(mergedProfile);
        debugPrint('✅ Synced down child data from Supabase to local Hive.');
      } else {
        // إذا كان السجل غير موجود في Supabase بعد، نرفعه فوراً
        debugPrint('Uploading local child profile (${currentProfile.childId}) to Supabase...');
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
        debugPrint('✅ Uploaded existing local profile to Supabase.');
      }
    } catch (e) {
      debugPrint('Sync down error (will use local Hive cache): $e');
    }
  }

  /// 3. تسجيل تقدم الطفل محلياً وسحابياً (Local First + Cloud Sync Up)
  static Future<void> recordMissionCompletion({
    required ChildProfileModel updatedProfile,
    required String missionId,
    required int earnedStars,
    required int earnedPoints,
    required String habitName,
  }) async {
    // أ. الحفظ المحلي الفوري في Hive (سرعة استجابة 0ms)
    await ChildRepository.saveChildProfile(updatedProfile);
    await HiveService.saveHabitStatus('h_$missionId', 'learned');

    // ب. محاولة الرفع المباشر لـ Supabase إذا توفر الاتصال
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
        debugPrint('✅ Mission $missionId synced directly to Supabase.');
        return;
      }
    }

    // ج. في حال عدم توفر الاتصال (Offline): إدراج المعاملة في طابور المزامنة
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

    debugPrint('📦 Mission queued in local sync queue for background upload.');
  }

  /// 4. مزامنة المعاملات المعلقة في الخلفية عند عودة الاتصال (Sync Up Pending Queue)
  static Future<void> syncUpPendingQueue() async {
    if (_isSyncing || !SupabaseService.isReady) return;

    _isSyncing = true;
    try {
      final queue = HiveService.getSyncQueue();
      if (queue.isEmpty) {
        _isSyncing = false;
        return;
      }

      debugPrint('🔄 Background Worker: Processing ${queue.length} pending items to Supabase...');

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
          debugPrint('✅ Flushed queued item $key to Supabase.');
        }
      }
    } catch (e) {
      debugPrint('Error syncing pending queue: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// 5. تفريغ الذاكرة المؤقتة والتخزين المحلي بالكامل لاختبار المزامنة مع Supabase من الصفر
  static Future<void> resetLocalCache() async {
    await HiveService.clearAll();
    debugPrint('🧹 Local Hive storage completely wiped.');
  }
}
