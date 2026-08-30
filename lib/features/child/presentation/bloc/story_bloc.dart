import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/hive_service.dart';
import '../../data/models/child_models.dart';

// === Events ===
abstract class StoryEvent extends Equatable {
  const StoryEvent();
  @override
  List<Object?> get props => [];
}

class InitStoryEvent extends StoryEvent {
  final MissionModel mission;
  const InitStoryEvent(this.mission);
  @override
  List<Object?> get props => [mission];
}

class NextSceneEvent extends StoryEvent {}
class PreviousSceneEvent extends StoryEvent {}
class ToggleStoryPlayPauseEvent extends StoryEvent {}
class ReplayStoryEvent extends StoryEvent {}
class SaveAndExitStoryEvent extends StoryEvent {}
class SkipStoryEvent extends StoryEvent {}

// === State ===
class StoryState extends Equatable {
  final MissionModel? mission;
  final int currentSceneIndex;
  final bool isPlaying;
  final bool isCompleted;
  final int savedSceneIndex;

  const StoryState({
    this.mission,
    this.currentSceneIndex = 0,
    this.isPlaying = true,
    this.isCompleted = false,
    this.savedSceneIndex = 0,
  });

  StorySceneModel? get currentScene {
    if (mission == null || mission!.storyScenes.isEmpty) return null;
    if (currentSceneIndex >= mission!.storyScenes.length) {
      return mission!.storyScenes.last;
    }
    return mission!.storyScenes[currentSceneIndex];
  }

  int get totalScenes => mission?.storyScenes.length ?? 0;

  StoryState copyWith({
    MissionModel? mission,
    int? currentSceneIndex,
    bool? isPlaying,
    bool? isCompleted,
    int? savedSceneIndex,
  }) {
    return StoryState(
      mission: mission ?? this.mission,
      currentSceneIndex: currentSceneIndex ?? this.currentSceneIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isCompleted: isCompleted ?? this.isCompleted,
      savedSceneIndex: savedSceneIndex ?? this.savedSceneIndex,
    );
  }

  @override
  List<Object?> get props => [
        mission,
        currentSceneIndex,
        isPlaying,
        isCompleted,
        savedSceneIndex,
      ];
}

// === BLoC ===
class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc() : super(const StoryState()) {
    on<InitStoryEvent>((event, emit) {
      final savedScene = HiveService.getStoryScene(event.mission.id);
      emit(StoryState(
        mission: event.mission,
        currentSceneIndex: savedScene < event.mission.storyScenes.length ? savedScene : 0,
        savedSceneIndex: savedScene,
        isPlaying: true,
        isCompleted: false,
      ));
    });

    on<NextSceneEvent>((event, emit) async {
      if (state.mission == null) return;
      final nextIndex = state.currentSceneIndex + 1;
      if (nextIndex >= state.mission!.storyScenes.length) {
        // انتهت القصة
        await HiveService.clearStoryScene(state.mission!.id);
        emit(state.copyWith(isCompleted: true));
      } else {
        await HiveService.saveStoryScene(state.mission!.id, nextIndex);
        emit(state.copyWith(currentSceneIndex: nextIndex));
      }
    });

    on<PreviousSceneEvent>((event, emit) async {
      if (state.mission == null || state.currentSceneIndex <= 0) return;
      final prevIndex = state.currentSceneIndex - 1;
      await HiveService.saveStoryScene(state.mission!.id, prevIndex);
      emit(state.copyWith(currentSceneIndex: prevIndex));
    });

    on<ToggleStoryPlayPauseEvent>((event, emit) {
      emit(state.copyWith(isPlaying: !state.isPlaying));
    });

    on<ReplayStoryEvent>((event, emit) async {
      if (state.mission != null) {
        await HiveService.saveStoryScene(state.mission!.id, 0);
      }
      emit(state.copyWith(currentSceneIndex: 0, isCompleted: false, isPlaying: true));
    });

    on<SkipStoryEvent>((event, emit) async {
      if (state.mission != null) {
        await HiveService.clearStoryScene(state.mission!.id);
      }
      emit(state.copyWith(isCompleted: true));
    });

    on<SaveAndExitStoryEvent>((event, emit) async {
      if (state.mission != null) {
        await HiveService.saveStoryScene(state.mission!.id, state.currentSceneIndex);
      }
    });
  }
}
