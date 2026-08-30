import 'package:hive_flutter/hive_flutter.dart';
import 'hive_keys.dart';

/// خدمة إدارة وتخزين البيانات المحلية والمزامنة السحابية باستخدام Hive
class HiveService {
  HiveService._();

  static late Box _settingsBox;
  static late Box _childBox;
  static late Box _habitsBox;
  static late Box _organizationBox;
  static late Box _storyProgressBox;
  static late Box _syncQueueBox;

  /// تهيئة Hive وفتح الصناديق الأساسية
  static Future<void> init() async {
    await Hive.initFlutter();

    _settingsBox = await Hive.openBox(HiveKeys.settingsBox);
    _childBox = await Hive.openBox(HiveKeys.childBox);
    _habitsBox = await Hive.openBox(HiveKeys.habitsBox);
    _organizationBox = await Hive.openBox(HiveKeys.organizationBox);
    _storyProgressBox = await Hive.openBox(HiveKeys.storyProgressBox);
    _syncQueueBox = await Hive.openBox(HiveKeys.syncQueueBox);
  }

  // === إعدادات عامة (Settings) ===
  static Future<void> saveSetting<T>(String key, T value) async {
    await _settingsBox.put(key, value);
  }

  static T getSetting<T>(String key, {required T defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T;
  }

  // === بيانات الطفل (Child Data) ===
  static Future<void> saveChildData<T>(String key, T value) async {
    await _childBox.put(key, value);
  }

  static T? getChildData<T>(String key, {T? defaultValue}) {
    return _childBox.get(key, defaultValue: defaultValue) as T?;
  }

  // === حفظ تقدم القصة (Story Scene Progress) ===
  static Future<void> saveStoryScene(String missionId, int sceneIndex) async {
    await _storyProgressBox.put(missionId, sceneIndex);
  }

  static int getStoryScene(String missionId) {
    return _storyProgressBox.get(missionId, defaultValue: 0) as int;
  }

  static Future<void> clearStoryScene(String missionId) async {
    await _storyProgressBox.delete(missionId);
  }

  // === بيانات العادات (Habits) ===
  static Future<void> saveHabitStatus(String habitId, String status) async {
    await _habitsBox.put(habitId, status);
  }

  static Map<dynamic, dynamic> getAllHabits() {
    return _habitsBox.toMap();
  }

  // === بيانات المنظمة (Organization) ===
  static Future<void> saveOrgData<T>(String key, T value) async {
    await _organizationBox.put(key, value);
  }

  static T? getOrgData<T>(String key, {T? defaultValue}) {
    return _organizationBox.get(key, defaultValue: defaultValue) as T?;
  }

  // === طابور المزامنة السحابية (Cloud Sync Queue) ===
  static Future<void> addToSyncQueue(String key, Map<String, dynamic> data) async {
    await _syncQueueBox.put(key, {
      ...data,
      'queued_at': DateTime.now().toIso8601String(),
    });
  }

  static Map<dynamic, dynamic> getSyncQueue() {
    return _syncQueueBox.toMap();
  }

  static Future<void> removeFromSyncQueue(String key) async {
    await _syncQueueBox.delete(key);
  }

  static Future<void> clearSyncQueue() async {
    await _syncQueueBox.clear();
  }

  /// مسح جميع البيانات (إعادة ضبط المصنع للتجربة)
  static Future<void> clearAll() async {
    await _settingsBox.clear();
    await _childBox.clear();
    await _habitsBox.clear();
    await _organizationBox.clear();
    await _storyProgressBox.clear();
    await _syncQueueBox.clear();
  }
}
