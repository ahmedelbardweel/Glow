/// مفاتيح الصناديق والبيانات في Hive
class HiveKeys {
  HiveKeys._();

  // === أسماء الصناديق (Box Names) ===
  static const String settingsBox = 'settings_box';
  static const String childBox = 'child_box';
  static const String habitsBox = 'habits_box';
  static const String organizationBox = 'organization_box';
  static const String storyProgressBox = 'story_progress_box';
  static const String syncQueueBox = 'sync_queue_box'; // طابور المزامنة السحابية غير المتزامنة

  // === مفاتيح الإعدادات (Settings Keys) ===
  static const String isDarkModeKey = 'is_dark_mode';
  static const String userTypeKey = 'user_type'; // child, parent, organization
  static const String isProfileCompleteKey = 'is_profile_complete';
  static const String lastCloudSyncKey = 'last_cloud_sync';
  static const String isOnlineModeKey = 'is_online_mode';

  // === مفاتيح الطفل (Child Keys) ===
  static const String childProfileKey = 'child_profile';
  static const String selectedCharacterKey = 'selected_character';
  static const String unlockedWorldsKey = 'unlocked_worlds';
  static const String completedMissionsKey = 'completed_missions';
  static const String currentWorldIndexKey = 'current_world_index';
  static const String currentMissionIndexKey = 'current_mission_index';
  static const String childStarsKey = 'child_stars';
  static const String childPointsKey = 'child_points';
  static const String earnedBadgesKey = 'earned_badges';

  // === مفاتيح القصة (Story Save Keys) ===
  static const String lastStorySceneKey = 'last_story_scene';

  // === مفاتيح ولي الأمر (Parent Keys) ===
  static const String parentEmailKey = 'parent_email';
  static const String linkedChildIdKey = 'linked_child_id';
  static const String isSubscribedKey = 'is_subscribed';
  static const String subscriptionPlanKey = 'subscription_plan';

  // === مفاتيح المنظمة (Organization Keys) ===
  static const String orgDataKey = 'org_data';
  static const String orgStudentsKey = 'org_students';
  static const String orgClassesKey = 'org_classes';
}
