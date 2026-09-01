import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import '../../features/child/data/models/child_models.dart';

/// Supabase cloud data and synchronization service.
class SupabaseService {
  SupabaseService._();

  static bool _isInitialized = false;

  /// Initializes the Supabase client connection.
  static Future<void> init() async {
    if (!SupabaseConfig.isConfigured) {
      debugPrint('[Supabase] Credentials not configured. Operating in local offline mode.');
      return;
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      _isInitialized = true;
      debugPrint('[Supabase] Initialized successfully.');
    } catch (e) {
      debugPrint('[Supabase] Initialization error: $e');
    }
  }

  static SupabaseClient? get client => _isInitialized ? Supabase.instance.client : null;
  static bool get isReady => _isInitialized && client != null;

  // ==============================================================================
  // 1. Dynamic Worlds & Missions Management (Admin)
  // ==============================================================================

  /// Fetches all dynamic worlds and nested missions from Supabase.
  static Future<List<WorldModel>> fetchRemoteWorldsAndMissions() async {
    if (!isReady) return [];
    try {
      final worldsResponse = await client!
          .from('app_worlds')
          .select('*, app_missions(*)')
          .order('sort_order', ascending: true);

      final List<WorldModel> worlds = [];
      for (final rawWorld in worldsResponse) {
        final rawMissions = (rawWorld['app_missions'] as List<dynamic>?) ?? [];
        rawMissions.sort((a, b) => ((a['number'] as num?) ?? 0).compareTo((b['number'] as num?) ?? 0));

        final worldMap = Map<String, dynamic>.from(rawWorld);
        worldMap['missions'] = rawMissions;
        worlds.add(WorldModel.fromMap(worldMap));
      }

      debugPrint('[Supabase] Fetched ${worlds.length} worlds from cloud.');
      return worlds;
    } catch (e) {
      debugPrint('[Supabase] Error fetching worlds and missions: $e');
      return [];
    }
  }

  /// Inserts or updates a world record in Supabase.
  static Future<bool> upsertRemoteWorld(WorldModel world) async {
    if (!isReady) return true;
    try {
      // ignore: deprecated_member_use
      final colorHex = '#${world.worldColor.value.toRadixString(16).padLeft(8, '0')}';
      await client!.from('app_worlds').upsert({
        'world_number': world.worldNumber,
        'name': world.name,
        'description': world.description,
        'world_color_hex': colorHex,
        'is_premium': world.isPremium,
        'sort_order': world.worldNumber,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'world_number');

      for (final mission in world.missions) {
        await upsertRemoteMission(world.worldNumber, mission);
      }

      debugPrint('[Supabase] Upserted world #${world.worldNumber} (${world.name}).');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error upserting world: $e');
      return false;
    }
  }

  /// Deletes a world record and its cascade relations from Supabase.
  static Future<bool> deleteRemoteWorld(int worldNumber) async {
    if (!isReady) return true;
    try {
      await client!.from('app_worlds').delete().eq('world_number', worldNumber);
      debugPrint('[Supabase] Deleted world #$worldNumber.');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error deleting world: $e');
      return false;
    }
  }

  /// Inserts or updates a mission record in Supabase.
  static Future<bool> upsertRemoteMission(int worldNumber, MissionModel mission) async {
    if (!isReady) return true;
    try {
      await client!.from('app_missions').upsert({
        'id': mission.id,
        'world_number': worldNumber,
        'number': mission.number,
        'title': mission.title,
        'habit_name': mission.habitName,
        'habit_description': mission.habitDescription,
        'reward_stars': mission.rewardStars,
        'reward_points': mission.rewardPoints,
        'story_scenes': mission.storyScenes.map((s) => s.toMap()).toList(),
        'quiz': mission.quiz.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');

      debugPrint('[Supabase] Upserted mission ${mission.id} (${mission.title}).');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error upserting mission: $e');
      return false;
    }
  }

  /// Deletes a mission record from Supabase.
  static Future<bool> deleteRemoteMission(String missionId) async {
    if (!isReady) return true;
    try {
      await client!.from('app_missions').delete().eq('id', missionId);
      debugPrint('[Supabase] Deleted mission $missionId.');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error deleting mission: $e');
      return false;
    }
  }

  /// Seeds initial default worlds and missions into Supabase.
  static Future<bool> seedInitialDataToSupabase(List<WorldModel> initialWorlds) async {
    if (!isReady) return false;
    try {
      for (final world in initialWorlds) {
        await upsertRemoteWorld(world);
      }
      debugPrint('[Supabase] Successfully seeded ${initialWorlds.length} initial worlds.');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error seeding initial data: $e');
      return false;
    }
  }

  // ==============================================================================
  // 2. Admin Overview Stats & User Management
  // ==============================================================================

  /// Fetches global overview KPIs for the admin portal.
  static Future<AdminStatsModel> fetchAdminOverviewStats() async {
    if (!isReady) {
      return const AdminStatsModel(isSupabaseConnected: false);
    }
    try {
      final childrenRes = await client!.from('children').select('stars, points');
      final parentsRes = await client!.from('parents').select('id');
      final orgsRes = await client!.from('organizations').select('id');
      final missionsRes = await client!.from('completed_missions').select('id');
      final worldsRes = await client!.from('app_worlds').select('world_number');
      final customMissionsRes = await client!.from('app_missions').select('id');

      int totalStars = 0;
      int totalPoints = 0;
      for (final row in childrenRes) {
        totalStars += ((row['stars'] as num?) ?? 0).toInt();
        totalPoints += ((row['points'] as num?) ?? 0).toInt();
      }

      return AdminStatsModel(
        totalChildren: (childrenRes as List).length,
        totalParents: (parentsRes as List).length,
        totalOrganizations: (orgsRes as List).length,
        totalCompletedMissions: (missionsRes as List).length,
        totalStarsGiven: totalStars,
        totalPointsGiven: totalPoints,
        totalCustomWorlds: (worldsRes as List).length,
        totalCustomMissions: (customMissionsRes as List).length,
        isSupabaseConnected: true,
      );
    } catch (e) {
      debugPrint('[Supabase] Error fetching admin stats: $e');
      return const AdminStatsModel(isSupabaseConnected: false);
    }
  }

  /// Fetches all registered children profiles from Supabase.
  static Future<List<ChildProfileModel>> fetchAllChildrenProfiles() async {
    if (!isReady) return [];
    try {
      final response = await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .order('points', ascending: false);

      final List<ChildProfileModel> children = [];
      for (final item in response) {
        final rawMissions = (item['completed_missions'] as List<dynamic>?)
                ?.map((m) => m['mission_id']?.toString() ?? '')
                .where((id) => id.isNotEmpty)
                .toList() ??
            [];

        final rawBadges = (item['earned_badges'] as List<dynamic>?)
                ?.map((b) => b['badge_name']?.toString() ?? '')
                .where((b) => b.isNotEmpty)
                .toList() ??
            [];

        final map = Map<String, dynamic>.from(item);
        map['completedMissions'] = rawMissions;
        map['earnedBadges'] = rawBadges;
        children.add(ChildProfileModel.fromMap(map));
      }
      return children;
    } catch (e) {
      debugPrint('[Supabase] Error fetching children: $e');
      return [];
    }
  }

  /// Updates child points, stars, or current world from the admin console.
  static Future<bool> updateChildStatsByAdmin({
    required String childCode,
    int? stars,
    int? points,
    int? currentWorld,
  }) async {
    if (!isReady) return false;
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (stars != null) updateData['stars'] = stars;
      if (points != null) updateData['points'] = points;
      if (currentWorld != null) updateData['current_world'] = currentWorld;

      await client!.from('children').update(updateData).eq('child_code', childCode.toUpperCase());
      debugPrint('[Supabase] Admin updated stats for child $childCode');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error updating child stats: $e');
      return false;
    }
  }

  // ==============================================================================
  // 3. Announcements
  // ==============================================================================

  /// Fetches all active announcements.
  static Future<List<AnnouncementModel>> fetchAnnouncements() async {
    if (!isReady) return [];
    try {
      final response = await client!
          .from('app_announcements')
          .select('*')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((item) => AnnouncementModel.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      debugPrint('[Supabase] Error fetching announcements: $e');
      return [];
    }
  }

  /// Publishes a new announcement.
  static Future<bool> createAnnouncement(AnnouncementModel announcement) async {
    if (!isReady) return true;
    try {
      await client!.from('app_announcements').insert({
        'title': announcement.title,
        'content': announcement.content,
        'target_role': announcement.targetRole,
        'is_active': announcement.isActive,
        'created_at': DateTime.now().toIso8601String(),
      });
      debugPrint('[Supabase] Created announcement: ${announcement.title}');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error creating announcement: $e');
      return false;
    }
  }

  /// Deletes an announcement by its ID.
  static Future<bool> deleteAnnouncement(String id) async {
    if (!isReady) return true;
    try {
      await client!.from('app_announcements').delete().eq('id', id);
      debugPrint('[Supabase] Deleted announcement: $id');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error deleting announcement: $e');
      return false;
    }
  }

  // ==============================================================================
  // 4. Child, Parent, and Organization Sync Operations
  // ==============================================================================

  /// Inserts or updates parent record in the parents table.
  static Future<bool> upsertParent(String email) async {
    if (!isReady) return true;
    try {
      final cleanEmail = email.trim().toLowerCase();
      if (cleanEmail.isEmpty) return false;
      await client!.from('parents').upsert({
        'email': cleanEmail,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'email');
      debugPrint('[Supabase] Upserted parent: $cleanEmail');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error upserting parent: $e');
      return false;
    }
  }

  /// Fetches child profile data by child ID code or name.
  static Future<Map<String, dynamic>?> fetchRemoteChildProfile(String childCodeOrName) async {
    if (!isReady) return null;
    try {
      var response = await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .eq('child_code', childCodeOrName.trim().toUpperCase())
          .maybeSingle();

      response ??= await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .eq('name', childCodeOrName.trim())
          .maybeSingle();

      return response;
    } catch (e) {
      debugPrint('[Supabase] Error fetching child profile: $e');
      return null;
    }
  }

  /// Upserts child profile state to Supabase cloud.
  static Future<bool> upsertRemoteChildProfile(ChildProfileModel profile) async {
    if (!isReady) return true;
    try {
      final code = profile.childId.toUpperCase();
      final parentEmail = profile.parentEmail?.trim().toLowerCase();

      if (parentEmail != null && parentEmail.isNotEmpty) {
        await upsertParent(parentEmail);
      }

      await client!.from('children').upsert({
        'child_code': code,
        'name': profile.name,
        'age': profile.age,
        'selected_character': profile.selectedCharacter,
        'avatar_shape': profile.avatarShape,
        'current_world': profile.currentWorld,
        'stars': profile.stars,
        'points': profile.points,
        'parent_id': (parentEmail != null && parentEmail.isNotEmpty) ? parentEmail : null,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'child_code');
      debugPrint('[Supabase] Upserted child profile ($code).');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error upserting child profile: $e');
      return false;
    }
  }

  /// Links a child account to a parent email.
  static Future<Map<String, dynamic>?> linkChildToParent({
    required String childCode,
    required String parentEmail,
    String? fallbackChildName,
  }) async {
    if (!isReady) return null;
    try {
      final cleanEmail = parentEmail.trim().toLowerCase();
      final code = childCode.trim().toUpperCase();

      await upsertParent(cleanEmail);
      
      var child = await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .eq('child_code', code)
          .maybeSingle();

      if (child != null) {
        await client!.from('children').update({
          'parent_id': cleanEmail,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('child_code', code);
      } else {
        final newChildData = {
          'child_code': code,
          'parent_id': cleanEmail,
          'name': (fallbackChildName != null && fallbackChildName.isNotEmpty) ? fallbackChildName : 'بطل المستقبل',
          'age': 7,
          'selected_character': 'PORT',
          'avatar_shape': 'shape_1',
          'current_world': 1,
          'stars': 0,
          'points': 0,
          'updated_at': DateTime.now().toIso8601String(),
        };
        await client!.from('children').insert(newChildData);
        child = newChildData;
      }

      debugPrint('[Supabase] Linked child ($code) to parent ($cleanEmail).');
      return child;
    } catch (e) {
      debugPrint('[Supabase] Error linking child to parent: $e');
      return null;
    }
  }

  /// Fetches all children linked to a parent email.
  static Future<List<Map<String, dynamic>>> fetchParentChildren(String parentEmail) async {
    if (!isReady) return [];
    try {
      final response = await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .eq('parent_id', parentEmail);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[Supabase] Error fetching parent children: $e');
      return [];
    }
  }

  /// Records a completed mission event in the cloud database.
  static Future<bool> recordRemoteCompletedMission({
    required String childName,
    String? childCode,
    required String missionId,
    required int stars,
    required int points,
    required String habitName,
  }) async {
    if (!isReady) return true;
    try {
      final code = (childCode ?? childName).toUpperCase();
      await client!.from('completed_missions').upsert({
        'child_code': code,
        'mission_id': missionId,
        'stars_earned': stars,
        'points_earned': points,
        'habit_name': habitName,
        'completed_at': DateTime.now().toIso8601String(),
      }, onConflict: 'child_code, mission_id');

      await client!.from('earned_badges').upsert({
        'child_code': code,
        'badge_name': 'وسام $habitName',
        'unlocked_at': DateTime.now().toIso8601String(),
      }, onConflict: 'child_code, badge_name');

      return true;
    } catch (e) {
      debugPrint('[Supabase] Error recording completed mission: $e');
      return false;
    }
  }

  /// Updates habit completion progress in the cloud database.
  static Future<bool> upsertHabitStatus({
    required String childName,
    String? childCode,
    required String habitId,
    required String status,
  }) async {
    if (!isReady) return true;
    try {
      final code = (childCode ?? childName).toUpperCase();
      await client!.from('habit_progress').upsert({
        'child_code': code,
        'habit_id': habitId,
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'child_code, habit_id');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error updating habit status: $e');
      return false;
    }
  }

  /// Updates organization and classroom metadata in the cloud database.
  static Future<bool> upsertOrganizationData(Map<String, dynamic> orgData) async {
    if (!isReady) return true;
    try {
      await client!.from('organizations').upsert(orgData, onConflict: 'org_name');
      return true;
    } catch (e) {
      debugPrint('[Supabase] Error updating organization data: $e');
      return false;
    }
  }
}
