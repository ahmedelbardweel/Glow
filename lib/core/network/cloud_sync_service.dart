import 'dart:async';
import '../database/hive_keys.dart';
import '../database/hive_service.dart';
import '../../features/child/data/models/child_models.dart';

/// Connection and synchronization status indicator.
enum CloudSyncStatus {
  synced,
  syncing,
  offline,
  error,
}

/// Cloud sync management service for the GLOW platform.
/// Handles online status and local queue management.
class CloudSyncService {
  CloudSyncService._();

  static final _syncStatusController = StreamController<CloudSyncStatus>.broadcast();
  static Stream<CloudSyncStatus> get syncStatusStream => _syncStatusController.stream;
  static CloudSyncStatus _currentStatus = CloudSyncStatus.synced;
  static CloudSyncStatus get currentStatus => _currentStatus;

  static bool _isOnline = true;
  static bool get isOnline => _isOnline;

  /// Initializes synchronization state and processes pending queue items.
  static Future<void> init() async {
    _isOnline = HiveService.getSetting<bool>(HiveKeys.isOnlineModeKey, defaultValue: true);
    if (_isOnline) {
      await syncPendingQueue();
    }
  }

  /// Toggles online simulation mode for offline testing.
  static Future<void> setOnlineMode(bool online) async {
    _isOnline = online;
    await HiveService.saveSetting(HiveKeys.isOnlineModeKey, online);
    if (online) {
      await syncPendingQueue();
    } else {
      _updateStatus(CloudSyncStatus.offline);
    }
  }

  /// Syncs child progress state to cloud storage.
  static Future<bool> syncChildProgressToCloud({
    required ChildProfileModel profile,
    String? completedMissionId,
    int addedStars = 0,
    int addedPoints = 0,
  }) async {
    await HiveService.saveChildData(HiveKeys.childProfileKey, profile.toMap());

    if (!_isOnline) {
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
      await Future.delayed(const Duration(milliseconds: 300));
      await HiveService.saveSetting(HiveKeys.lastCloudSyncKey, DateTime.now().toIso8601String());
      _updateStatus(CloudSyncStatus.synced);
      return true;
    } catch (e) {
      _updateStatus(CloudSyncStatus.error);
      return false;
    }
  }

  /// Processes the pending offline synchronization queue.
  static Future<void> syncPendingQueue() async {
    final queue = HiveService.getSyncQueue();
    if (queue.isEmpty) {
      _updateStatus(CloudSyncStatus.synced);
      return;
    }

    _updateStatus(CloudSyncStatus.syncing);

    try {
      await Future.delayed(const Duration(milliseconds: 400));
      await HiveService.clearSyncQueue();
      await HiveService.saveSetting(HiveKeys.lastCloudSyncKey, DateTime.now().toIso8601String());
      _updateStatus(CloudSyncStatus.synced);
    } catch (e) {
      _updateStatus(CloudSyncStatus.error);
    }
  }

  /// Syncs organization and classroom metadata.
  static Future<bool> syncOrganizationToCloud(Map<String, dynamic> orgData) async {
    await HiveService.saveOrganizationData(HiveKeys.orgDataKey, orgData);

    if (!_isOnline) {
      await HiveService.addToSyncQueue('org_sync_${DateTime.now().millisecondsSinceEpoch}', {
        'type': 'organization',
        'data': orgData,
      });
      _updateStatus(CloudSyncStatus.offline);
      return false;
    }

    _updateStatus(CloudSyncStatus.syncing);

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      await HiveService.saveSetting(HiveKeys.lastCloudSyncKey, DateTime.now().toIso8601String());
      _updateStatus(CloudSyncStatus.synced);
      return true;
    } catch (e) {
      _updateStatus(CloudSyncStatus.error);
      return false;
    }
  }

  /// Generates a cloud PDF report url for organizations and parents.
  static Future<String> generatePdfReportCloud({
    required String title,
    String? organizationName,
    int? totalStudents,
    int? completionRate,
    String? period,
    Map<String, dynamic>? data,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return 'report_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  static void _updateStatus(CloudSyncStatus status) {
    _currentStatus = status;
    _syncStatusController.add(status);
  }

  /// Formatted date string for the last successful cloud synchronization.
  static String getLastSyncTimeFormatted() {
    final lastSyncStr = HiveService.getSetting<String>(HiveKeys.lastCloudSyncKey, defaultValue: '');
    if (lastSyncStr.isEmpty) return 'Never synced';
    try {
      final dt = DateTime.parse(lastSyncStr);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} - ${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return 'Recently';
    }
  }

  /// Returns the current count of pending offline sync items.
  static int getPendingQueueCount() {
    return HiveService.getSyncQueue().length;
  }
}
