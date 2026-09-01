import 'package:equatable/equatable.dart';
import '../../../child/data/models/child_models.dart';

enum AdminStatus { initial, loading, loaded, success, failure }

class AdminState extends Equatable {
  final AdminStatus status;
  final AdminStatsModel stats;
  final List<WorldModel> worlds;
  final List<ChildProfileModel> children;
  final List<AnnouncementModel> announcements;
  final String? successMessage;
  final String? errorMessage;
  final bool isSeeding;

  const AdminState({
    this.status = AdminStatus.initial,
    this.stats = const AdminStatsModel(),
    this.worlds = const [],
    this.children = const [],
    this.announcements = const [],
    this.successMessage,
    this.errorMessage,
    this.isSeeding = false,
  });

  AdminState copyWith({
    AdminStatus? status,
    AdminStatsModel? stats,
    List<WorldModel>? worlds,
    List<ChildProfileModel>? children,
    List<AnnouncementModel>? announcements,
    String? successMessage,
    String? errorMessage,
    bool? isSeeding,
  }) {
    return AdminState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      worlds: worlds ?? this.worlds,
      children: children ?? this.children,
      announcements: announcements ?? this.announcements,
      successMessage: successMessage,
      errorMessage: errorMessage,
      isSeeding: isSeeding ?? this.isSeeding,
    );
  }

  @override
  List<Object?> get props => [
        status,
        stats,
        worlds,
        children,
        announcements,
        successMessage,
        errorMessage,
        isSeeding,
      ];
}
