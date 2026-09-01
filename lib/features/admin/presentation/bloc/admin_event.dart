import 'package:equatable/equatable.dart';
import '../../../child/data/models/child_models.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

/// Key performance indicators and metrics.
class LoadAdminDashboardEvent extends AdminEvent {
  const LoadAdminDashboardEvent();
}

class SaveWorldEvent extends AdminEvent {
  final WorldModel world;
  const SaveWorldEvent(this.world);

  @override
  List<Object?> get props => [world];
}

class DeleteWorldEvent extends AdminEvent {
  final int worldNumber;
  const DeleteWorldEvent(this.worldNumber);

  @override
  List<Object?> get props => [worldNumber];
}

/// Persists state changes.
class SaveMissionEvent extends AdminEvent {
  final int worldNumber;
  final MissionModel mission;
  const SaveMissionEvent({required this.worldNumber, required this.mission});

  @override
  List<Object?> get props => [worldNumber, mission];
}

class DeleteMissionEvent extends AdminEvent {
  final int worldNumber;
  final String missionId;
  const DeleteMissionEvent({required this.worldNumber, required this.missionId});

  @override
  List<Object?> get props => [worldNumber, missionId];
}

/// Action button.
class SeedInitialDataEvent extends AdminEvent {
  const SeedInitialDataEvent();
}

class UpdateChildStatsEvent extends AdminEvent {
  final String childCode;
  final int? stars;
  final int? points;
  final int? currentWorld;
  const UpdateChildStatsEvent({
    required this.childCode,
    this.stars,
    this.points,
    this.currentWorld,
  });

  @override
  List<Object?> get props => [childCode, stars, points, currentWorld];
}

class CreateAnnouncementEvent extends AdminEvent {
  final AnnouncementModel announcement;
  const CreateAnnouncementEvent(this.announcement);

  @override
  List<Object?> get props => [announcement];
}

class DeleteAnnouncementEvent extends AdminEvent {
  final String announcementId;
  const DeleteAnnouncementEvent(this.announcementId);

  @override
  List<Object?> get props => [announcementId];
}

/// Synchronizes state with cloud backend.
class ForceSyncEvent extends AdminEvent {
  const ForceSyncEvent();
}
