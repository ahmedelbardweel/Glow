import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/supabase_service.dart';
import '../../../../core/network/offline_first_sync_manager.dart';
import '../../../child/data/models/child_models.dart';
import '../../../child/data/repositories/child_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

/// Business logic component for the admin portal and content management.
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(const AdminState()) {
    on<LoadAdminDashboardEvent>(_onLoadDashboard);
    on<SaveWorldEvent>(_onSaveWorld);
    on<DeleteWorldEvent>(_onDeleteWorld);
    on<SaveMissionEvent>(_onSaveMission);
    on<DeleteMissionEvent>(_onDeleteMission);
    on<SeedInitialDataEvent>(_onSeedInitialData);
    on<UpdateChildStatsEvent>(_onUpdateChildStats);
    on<CreateAnnouncementEvent>(_onCreateAnnouncement);
    on<DeleteAnnouncementEvent>(_onDeleteAnnouncement);
    on<ForceSyncEvent>(_onForceSync);
  }

  Future<void> _onLoadDashboard(
    LoadAdminDashboardEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      final currentWorlds = ChildRepository.getWorlds();
      final stats = await SupabaseService.fetchAdminOverviewStats();
      final children = await SupabaseService.fetchAllChildrenProfiles();
      final announcements = await SupabaseService.fetchAnnouncements();

      emit(state.copyWith(
        status: AdminStatus.loaded,
        worlds: currentWorlds,
        stats: stats,
        children: children,
        announcements: announcements,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AdminStatus.failure,
        errorMessage: 'فشل تحميل بيانات لوحة المشرف: $e',
      ));
    }
  }

  Future<void> _onSaveWorld(
    SaveWorldEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      final updatedWorlds = List<WorldModel>.from(state.worlds);
      final index = updatedWorlds.indexWhere((w) => w.worldNumber == event.world.worldNumber);

      if (index >= 0) {
        final existingMissions = updatedWorlds[index].missions;
        final worldToSave = event.world.missions.isEmpty
            ? event.world.copyWith(missions: existingMissions)
            : event.world;
        updatedWorlds[index] = worldToSave;
        await SupabaseService.upsertRemoteWorld(worldToSave);
      } else {
        updatedWorlds.add(event.world);
        updatedWorlds.sort((a, b) => a.worldNumber.compareTo(b.worldNumber));
        await SupabaseService.upsertRemoteWorld(event.world);
      }

      await ChildRepository.saveCachedWorlds(updatedWorlds);

      emit(state.copyWith(
        worlds: updatedWorlds,
        successMessage: 'تم حفظ وتحديث العالم ${event.world.name} بنجاح في السحابة ومحلياً.',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء حفظ العالم: $e'));
    }
  }

  Future<void> _onDeleteWorld(
    DeleteWorldEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await SupabaseService.deleteRemoteWorld(event.worldNumber);
      final updatedWorlds = state.worlds.where((w) => w.worldNumber != event.worldNumber).toList();
      await ChildRepository.saveCachedWorlds(updatedWorlds);

      emit(state.copyWith(
        worlds: updatedWorlds,
        successMessage: 'تم حذف العالم رقم #${event.worldNumber} بنجاح.',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء حذف العالم: $e'));
    }
  }

  Future<void> _onSaveMission(
    SaveMissionEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      final updatedWorlds = List<WorldModel>.from(state.worlds);
      final worldIndex = updatedWorlds.indexWhere((w) => w.worldNumber == event.worldNumber);

      if (worldIndex >= 0) {
        final currentWorld = updatedWorlds[worldIndex];
        final updatedMissions = List<MissionModel>.from(currentWorld.missions);
        final missionIndex = updatedMissions.indexWhere((m) => m.id == event.mission.id);

        if (missionIndex >= 0) {
          updatedMissions[missionIndex] = event.mission;
        } else {
          updatedMissions.add(event.mission);
        }
        updatedMissions.sort((a, b) => a.number.compareTo(b.number));

        final newWorld = currentWorld.copyWith(missions: updatedMissions);
        updatedWorlds[worldIndex] = newWorld;

        await SupabaseService.upsertRemoteMission(event.worldNumber, event.mission);
        await ChildRepository.saveCachedWorlds(updatedWorlds);

        emit(state.copyWith(
          worlds: updatedWorlds,
          successMessage: 'تم حفظ وتحديث المهمة "${event.mission.title}" بنجاح.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء حفظ المهمة: $e'));
    }
  }

  Future<void> _onDeleteMission(
    DeleteMissionEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await SupabaseService.deleteRemoteMission(event.missionId);

      final updatedWorlds = state.worlds.map((w) {
        if (w.worldNumber == event.worldNumber) {
          return w.copyWith(
            missions: w.missions.where((m) => m.id != event.missionId).toList(),
          );
        }
        return w;
      }).toList();

      await ChildRepository.saveCachedWorlds(updatedWorlds);

      emit(state.copyWith(
        worlds: updatedWorlds,
        successMessage: 'تم حذف المهمة بنجاح من السحابة والذاكرة المحلية.',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء حذف المهمة: $e'));
    }
  }

  Future<void> _onSeedInitialData(
    SeedInitialDataEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isSeeding: true));
    try {
      final defaultWorlds = ChildRepository.defaultWorlds;
      final success = await SupabaseService.seedInitialDataToSupabase(defaultWorlds);

      if (success) {
        await ChildRepository.saveCachedWorlds(defaultWorlds);
        final stats = await SupabaseService.fetchAdminOverviewStats();
        emit(state.copyWith(
          isSeeding: false,
          worlds: defaultWorlds,
          stats: stats,
          successMessage: 'تم رفع كافة العوالم الـ 6 والـ 30 مهمة الافتراضية إلى Supabase بنجاح.',
        ));
      } else {
        emit(state.copyWith(
          isSeeding: false,
          errorMessage: 'تعذر رفع البيانات. يرجى التأكد من تشغيل سكريبت SQL في Supabase أولاً.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSeeding: false,
        errorMessage: 'خطأ أثناء رفع البيانات الافتراضية: $e',
      ));
    }
  }

  Future<void> _onUpdateChildStats(
    UpdateChildStatsEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      final success = await SupabaseService.updateChildStatsByAdmin(
        childCode: event.childCode,
        stars: event.stars,
        points: event.points,
        currentWorld: event.currentWorld,
      );

      if (success) {
        final children = await SupabaseService.fetchAllChildrenProfiles();
        final stats = await SupabaseService.fetchAdminOverviewStats();
        emit(state.copyWith(
          children: children,
          stats: stats,
          successMessage: 'تم تحديث بيانات الطفل ${event.childCode} بنجاح.',
        ));
      } else {
        emit(state.copyWith(errorMessage: 'فشل تحديث بيانات الطفل.'));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء تحديث بيانات الطفل: $e'));
    }
  }

  Future<void> _onCreateAnnouncement(
    CreateAnnouncementEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      final success = await SupabaseService.createAnnouncement(event.announcement);
      if (success) {
        final announcements = await SupabaseService.fetchAnnouncements();
        emit(state.copyWith(
          announcements: announcements,
          successMessage: 'تم نشر الإعلان والتوجيه العام بنجاح.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء نشر الإعلان: $e'));
    }
  }

  Future<void> _onDeleteAnnouncement(
    DeleteAnnouncementEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await SupabaseService.deleteAnnouncement(event.announcementId);
      final announcements = await SupabaseService.fetchAnnouncements();
      emit(state.copyWith(
        announcements: announcements,
        successMessage: 'تم حذف الإعلان بنجاح.',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء حذف الإعلان: $e'));
    }
  }

  Future<void> _onForceSync(
    ForceSyncEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      await OfflineFirstSyncManager.syncDownFromCloud();
      await OfflineFirstSyncManager.syncUpPendingQueue();

      final currentWorlds = ChildRepository.getWorlds();
      final stats = await SupabaseService.fetchAdminOverviewStats();
      final children = await SupabaseService.fetchAllChildrenProfiles();
      final announcements = await SupabaseService.fetchAnnouncements();

      emit(state.copyWith(
        status: AdminStatus.loaded,
        worlds: currentWorlds,
        stats: stats,
        children: children,
        announcements: announcements,
        successMessage: 'تمت المزامنة الثنائية مع Supabase والتخزين المحلي بنجاح.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AdminStatus.loaded,
        errorMessage: 'خطأ أثناء المزامنة: $e',
      ));
    }
  }
}
