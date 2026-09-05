class HiveKeys {
  HiveKeys._();

  static const String settingsBox = 'settings_box';
  static const String childBox = 'child_box';
  static const String habitsBox = 'habits_box';
  static const String organizationBox = 'organization_box';
  static const String storyProgressBox = 'story_progress_box';
  static const String syncQueueBox = 'sync_queue_box'; // Synchronizes state with cloud backend.
  static const String dynamicContentBox = 'dynamic_content_box';

  static const String isDarkModeKey = 'is_dark_mode';
  static const String userTypeKey = 'user_type'; // child, parent, organization, admin
  static const String isProfileCompleteKey = 'is_profile_complete';
  static const String lastCloudSyncKey = 'last_cloud_sync';
  static const String isOnlineModeKey = 'is_online_mode';
  static const String adminPasscodeKey = 'admin_passcode';
  static const String hasLaunchedBeforeKey = 'has_launched_before';

  static const String childProfileKey = 'child_profile';
  static const String selectedCharacterKey = 'selected_character';
  static const String unlockedWorldsKey = 'unlocked_worlds';
  static const String completedMissionsKey = 'completed_missions';
  static const String currentWorldIndexKey = 'current_world_index';
  static const String currentMissionIndexKey = 'current_mission_index';
  static const String childStarsKey = 'child_stars';
  static const String childPointsKey = 'child_points';
  static const String earnedBadgesKey = 'earned_badges';

  // Persists state changes.
  static const String lastStorySceneKey = 'last_story_scene';

  static const String parentEmailKey = 'parent_email';
  static const String linkedChildIdKey = 'linked_child_id';
  static const String isSubscribedKey = 'is_subscribed';
  static const String subscriptionPlanKey = 'subscription_plan';

  static const String orgDataKey = 'org_data';
  static const String orgStudentsKey = 'org_students';
  static const String orgClassesKey = 'org_classes';

  static const String cachedWorldsKey = 'cached_worlds';
  static const String cachedAnnouncementsKey = 'cached_announcements';
}
