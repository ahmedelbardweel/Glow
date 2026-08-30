import 'dart:async';
import '../database/hive_keys.dart';
import '../database/hive_service.dart';
import '../../features/child/data/models/child_models.dart';

/// حالة المزامنة السحابية
enum CloudSyncStatus {
  synced,     // تمت المزامنة بنجاح
  syncing,    // جاري المزامنة مع السيرفر
  offline,    // غير متصل (حفظ محلي آمن في Hive)
  error,      // حدث خطأ في الاتصال
}

/// خدمة المزامنة السحابية وإدارة الاتصال بالإنترنت لمنصة GLOW
/// توفر مزامنة سحابية متقدمة لبيانات الطفل، لوحة تحكم ولي الأمر، والمنظمات
/// مع نظام حماية وحفظ محلي فائق يضمن استمرار تجربة الطفل والقصة حتى في حال انقطاع الشبكة
class CloudSyncService {
  CloudSyncService._();

  static final _syncStatusController = StreamController<CloudSyncStatus>.broadcast();
  static Stream<CloudSyncStatus> get syncStatusStream => _syncStatusController.stream;
  static CloudSyncStatus _currentStatus = CloudSyncStatus.synced;
  static CloudSyncStatus get currentStatus => _currentStatus;

  static bool _isOnline = true;
  static bool get isOnline => _isOnline;

  /// تهيئة خدمة المزامنة وفحص الطابور غير المتزامن
  static Future<void> init() async {
    _isOnline = HiveService.getSetting<bool>(HiveKeys.isOnlineModeKey, defaultValue: true);
    if (_isOnline) {
      await syncPendingQueue();
    }
  }

  /// تبديل محاكاة حالة الاتصال (Online / Offline) لأغراض الاختبار والعرض
  static Future<void> setOnlineMode(bool online) async {
    _isOnline = online;
    await HiveService.saveSetting(HiveKeys.isOnlineModeKey, online);
    if (online) {
      await syncPendingQueue();
    } else {
      _updateStatus(CloudSyncStatus.offline);
    }
  }

  /// مزامنة ملف الطفل وإنجازاته مع السحابة
  static Future<bool> syncChildProgressToCloud({
    required ChildProfileModel profile,
    String? completedMissionId,
    int addedStars = 0,
    int addedPoints = 0,
  }) async {
    // 1. الحفظ المحلي الفوري دائماً لضمان عدم ضياع أي تقدم
    await HiveService.saveChildData(HiveKeys.childProfileKey, profile.toMap());

    if (!_isOnline) {
      // حفظ في طابور المزامنة في حال عدم توفر اتصال
      await HiveService.addToSyncQueue('child_sync_${DateTime.now().millisecondsSinceEpoch}', {
        'type': 'child_progress',
        'profile': profile.toMap(),
        'mission_id': completedMissionId,
        'stars': addedStars,
        'points': addedPoints,
      });
      _updateStatus(CloudSyncStatus.offline);
      return false;
    }

    _updateStatus(CloudSyncStatus.syncing);

    try {
      // محاكاة الاتصال بالسيرفر السحابي لـ GLOW
      await Future.delayed(const Duration(milliseconds: 600));

      // تسجيل وقت آخر مزامنة ناجحة
      await HiveService.saveSetting(HiveKeys.lastCloudSyncKey, DateTime.now().toIso8601String());
      _updateStatus(CloudSyncStatus.synced);
      return true;
    } catch (e) {
      _updateStatus(CloudSyncStatus.error);
      return false;
    }
  }

  /// معالجة طابور المزامنة عند استعادة الاتصال بالإنترنت
  static Future<void> syncPendingQueue() async {
    final queue = HiveService.getSyncQueue();
    if (queue.isEmpty) {
      _updateStatus(CloudSyncStatus.synced);
      return;
    }

    _updateStatus(CloudSyncStatus.syncing);

    try {
      // محاكاة رفع جميع العناصر المعلقة للسحابة دفعة واحدة
      await Future.delayed(const Duration(milliseconds: 800));
      await HiveService.clearSyncQueue();
      await HiveService.saveSetting(HiveKeys.lastCloudSyncKey, DateTime.now().toIso8601String());
      _updateStatus(CloudSyncStatus.synced);
    } catch (e) {
      _updateStatus(CloudSyncStatus.error);
    }
  }

  /// التحقق السحابي من اشتراك باقة التميز (للعالمين 5 و 6)
  static Future<bool> verifySubscriptionFromCloud(String parentEmail) async {
    if (!_isOnline) {
      // استخدام البيانات المخزنة محلياً عند انقطاع الإنترنت
      return HiveService.getSetting<bool>(HiveKeys.isSubscribedKey, defaultValue: false);
    }

    try {
      // محاكاة فحص السيرفر
      await Future.delayed(const Duration(milliseconds: 400));
      final isSubscribed = HiveService.getSetting<bool>(HiveKeys.isSubscribedKey, defaultValue: false);
      return isSubscribed;
    } catch (_) {
      return false;
    }
  }

  /// جلب تقرير تحليلات الذكاء الاصطناعي السحابي لولي الأمر
  static Future<Map<String, dynamic>> fetchCloudParentAnalytics(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'status': 'success',
      'generated_at': DateTime.now().toIso8601String(),
      'strengths_summary': 'تطور ملحوظ في الثقة بالنفس، الانضباط، والتعاطف.',
      'support_needed': 'تعزيز مهارات إدارة الوقت والحد من التعلق بالشاشات.',
      'recommended_activities_count': 3,
    };
  }

  /// توليد وتنزيل تقرير المنظمة التعليمية بصيغة PDF السحابية
  static Future<String> generatePdfReportCloud({
    required String title,
    required String organizationName,
    required int totalStudents,
    required int completionRate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return 'GLOW_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  static void _updateStatus(CloudSyncStatus status) {
    _currentStatus = status;
    _syncStatusController.add(status);
  }
}
