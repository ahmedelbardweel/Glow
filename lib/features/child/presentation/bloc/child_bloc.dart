import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/offline_first_sync_manager.dart';
import '../../../../core/network/supabase_service.dart';
import '../../data/models/child_models.dart';
import '../../data/repositories/child_repository.dart';

// === Events ===
abstract class ChildEvent extends Equatable {
  const ChildEvent();
  @override
  List<Object?> get props => [];
}

class LoadChildProfileEvent extends ChildEvent {}

class UpdateChildProfileEvent extends ChildEvent {
  final String name;
  final int age;
  final String avatarShape;
  const UpdateChildProfileEvent({required this.name, required this.age, required this.avatarShape});
  @override
  List<Object?> get props => [name, age, avatarShape];
}

class SelectCharacterEvent extends ChildEvent {
  final String characterName;
  const SelectCharacterEvent(this.characterName);
  @override
  List<Object?> get props => [characterName];
}

class CompleteMissionEvent extends ChildEvent {
  final String missionId;
  final int earnedStars;
  final int earnedPoints;
  final String habitName;

  const CompleteMissionEvent({
    required this.missionId,
    required this.earnedStars,
    required this.earnedPoints,
    required this.habitName,
  });

  @override
  List<Object?> get props => [missionId, earnedStars, earnedPoints, habitName];
}

class ResetLocalChildDataEvent extends ChildEvent {}

// === States ===
class ChildState extends Equatable {
  final ChildProfileModel profile;
  final bool isLoading;

  const ChildState({
    required this.profile,
    this.isLoading = false,
  });

  ChildState copyWith({
    ChildProfileModel? profile,
    bool? isLoading,
  }) {
    return ChildState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [profile, isLoading];
}

// === BLoC ===
class ChildBloc extends Bloc<ChildEvent, ChildState> {
  ChildBloc() : super(ChildState(profile: ChildRepository.getChildProfile())) {
    on<LoadChildProfileEvent>((event, emit) async {
      // 1. قراءة فورية من Hive
      final localProfile = ChildRepository.getChildProfile();
      emit(state.copyWith(profile: localProfile));

      // 2. مزامنة سحابية وتحديث من Supabase في الخلفية
      await OfflineFirstSyncManager.syncDownFromCloud();
      final updatedProfile = ChildRepository.getChildProfile();
      emit(state.copyWith(profile: updatedProfile));
    });

    on<UpdateChildProfileEvent>((event, emit) async {
      final updated = state.profile.copyWith(
        name: event.name,
        age: event.age,
        avatarShape: event.avatarShape,
      );
      await ChildRepository.saveChildProfile(updated);
      await SupabaseService.upsertRemoteChildProfile(updated);
      emit(state.copyWith(profile: updated));
    });

    on<SelectCharacterEvent>((event, emit) async {
      final updated = state.profile.copyWith(
        selectedCharacter: event.characterName,
      );
      await ChildRepository.saveChildProfile(updated);
      await SupabaseService.upsertRemoteChildProfile(updated);
      emit(state.copyWith(profile: updated));
    });

    on<CompleteMissionEvent>((event, emit) async {
      final completed = List<String>.from(state.profile.completedMissions);
      if (!completed.contains(event.missionId)) {
        completed.add(event.missionId);
      }

      final badges = List<String>.from(state.profile.earnedBadges);
      final badgeName = 'وسام ${event.habitName}';
      if (!badges.contains(badgeName)) {
        badges.add(badgeName);
      }

      final updated = state.profile.copyWith(
        completedMissions: completed,
        earnedBadges: badges,
        stars: state.profile.stars + event.earnedStars,
        points: state.profile.points + event.earnedPoints,
      );

      // تسجيل وحفظ التقدم محلياً في Hive ومزامنته مع Supabase
      await OfflineFirstSyncManager.recordMissionCompletion(
        updatedProfile: updated,
        missionId: event.missionId,
        earnedStars: event.earnedStars,
        earnedPoints: event.earnedPoints,
        habitName: event.habitName,
      );

      emit(state.copyWith(profile: updated));
    });

    on<ResetLocalChildDataEvent>((event, emit) async {
      await OfflineFirstSyncManager.resetLocalCache();
      final freshProfile = ChildRepository.getChildProfile();
      emit(state.copyWith(profile: freshProfile));
    });
  }
}
