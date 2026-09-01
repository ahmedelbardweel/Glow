import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/child_models.dart';

// === Events ===
abstract class QuizEvent extends Equatable {
  const QuizEvent();
  @override
  List<Object?> get props => [];
}

class InitQuizEvent extends QuizEvent {
  final MissionModel mission;
  final int startIndex;
  const InitQuizEvent(this.mission, {this.startIndex = 0});
  @override
  List<Object?> get props => [mission, startIndex];
}

class SelectOptionEvent extends QuizEvent {
  final String keyId;
  const SelectOptionEvent(this.keyId);
  @override
  List<Object?> get props => [keyId];
}

class NextQuestionEvent extends QuizEvent {}

class ResetQuizEvent extends QuizEvent {}

// === State ===
enum QuizStatus { initial, answeredCorrect, answeredWrong, completed }

class QuizState extends Equatable {
  final MissionModel? mission;
  final int currentQuestionIndex;
  final String? selectedKeyId;
  final QuizStatus status;
  final QuizOptionModel? selectedOption;
  final List<QuizOptionModel> randomizedOptions;
  final String activeCorrectKey;
  final int correctAnswersCount;

  const QuizState({
    this.mission,
    this.currentQuestionIndex = 0,
    this.selectedKeyId,
    this.status = QuizStatus.initial,
    this.selectedOption,
    this.randomizedOptions = const [],
    this.activeCorrectKey = 'A',
    this.correctAnswersCount = 0,
  });

  List<QuizModel> get allQuizzes {
    if (mission == null) return const [];
    if (mission!.quizzes.isNotEmpty) return mission!.quizzes;
    return [mission!.quiz];
  }

  int get totalQuestions => allQuizzes.isEmpty ? 1 : allQuizzes.length;

  QuizModel get currentQuiz {
    final list = allQuizzes;
    if (list.isEmpty) {
      return const QuizModel(
        situation: '',
        question: '',
        options: [],
        correctKeyId: 'A',
        encouragementCorrect: '',
        gentleFeedbackWrong: '',
      );
    }
    if (currentQuestionIndex >= list.length) {
      return list.last;
    }
    return list[currentQuestionIndex];
  }

  QuizModel? get quiz => currentQuiz;

  bool get isCorrect => status == QuizStatus.answeredCorrect;
  bool get isWrong => status == QuizStatus.answeredWrong;
  bool get isCompleted => status == QuizStatus.completed;
  bool get isLastQuestion => currentQuestionIndex >= totalQuestions - 1;

  QuizState copyWith({
    MissionModel? mission,
    int? currentQuestionIndex,
    String? selectedKeyId,
    QuizStatus? status,
    QuizOptionModel? selectedOption,
    List<QuizOptionModel>? randomizedOptions,
    String? activeCorrectKey,
    int? correctAnswersCount,
  }) {
    return QuizState(
      mission: mission ?? this.mission,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedKeyId: selectedKeyId ?? this.selectedKeyId,
      status: status ?? this.status,
      selectedOption: selectedOption ?? this.selectedOption,
      randomizedOptions: randomizedOptions ?? this.randomizedOptions,
      activeCorrectKey: activeCorrectKey ?? this.activeCorrectKey,
      correctAnswersCount: correctAnswersCount ?? this.correctAnswersCount,
    );
  }

  @override
  List<Object?> get props => [
        mission,
        currentQuestionIndex,
        selectedKeyId,
        status,
        selectedOption,
        randomizedOptions,
        activeCorrectKey,
        correctAnswersCount,
      ];
}

// Persists state changes.
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(const QuizState()) {
    on<InitQuizEvent>((event, emit) {
      final quizzes = event.mission.quizzes.isNotEmpty
          ? event.mission.quizzes
          : [event.mission.quiz];
      
      final index = event.startIndex.clamp(0, quizzes.length - 1);
      final activeQuiz = quizzes[index];

      final pair = _buildRandomizedOptions(activeQuiz);

      emit(QuizState(
        mission: event.mission,
        currentQuestionIndex: index,
        status: QuizStatus.initial,
        randomizedOptions: pair.options,
        activeCorrectKey: pair.correctKey,
        correctAnswersCount: 0,
      ));
    });

    on<SelectOptionEvent>((event, emit) {
      if (state.randomizedOptions.isEmpty) return;
      final option = state.randomizedOptions.firstWhere(
        (o) => o.keyId == event.keyId,
        orElse: () => state.randomizedOptions.first,
      );

      final isCorrect = event.keyId == state.activeCorrectKey;

      if (isCorrect) {
        final newCount = state.correctAnswersCount + 1;
        if (state.isLastQuestion) {
          emit(state.copyWith(
            selectedKeyId: event.keyId,
            selectedOption: option,
            status: QuizStatus.completed,
            correctAnswersCount: newCount,
          ));
        } else {
          emit(state.copyWith(
            selectedKeyId: event.keyId,
            selectedOption: option,
            status: QuizStatus.answeredCorrect,
            correctAnswersCount: newCount,
          ));
        }
      } else {
        emit(state.copyWith(
          selectedKeyId: event.keyId,
          selectedOption: option,
          status: QuizStatus.answeredWrong,
        ));
      }
    });

    on<NextQuestionEvent>((event, emit) {
      final nextIndex = state.currentQuestionIndex + 1;
      if (nextIndex >= state.totalQuestions) {
        emit(state.copyWith(status: QuizStatus.completed));
        return;
      }

      final nextQuiz = state.allQuizzes[nextIndex];
      final pair = _buildRandomizedOptions(nextQuiz);

      emit(state.copyWith(
        currentQuestionIndex: nextIndex,
        selectedKeyId: null,
        selectedOption: null,
        status: QuizStatus.initial,
        randomizedOptions: pair.options,
        activeCorrectKey: pair.correctKey,
      ));
    });

    on<ResetQuizEvent>((event, emit) {
      emit(state.copyWith(
        selectedKeyId: null,
        selectedOption: null,
        status: QuizStatus.initial,
      ));
    });
  }

  static ({List<QuizOptionModel> options, String correctKey}) _buildRandomizedOptions(QuizModel quiz) {
    final originalOptions = List<QuizOptionModel>.from(quiz.options);
    originalOptions.shuffle();
    final keys = ['A', 'B', 'C', 'D'];
    String newCorrectKey = 'A';

    final remappedOptions = <QuizOptionModel>[];
    for (int i = 0; i < originalOptions.length && i < keys.length; i++) {
      final opt = originalOptions[i];
      final newKey = keys[i];
      if (opt.keyId == quiz.correctKeyId) {
        newCorrectKey = newKey;
      }
      remappedOptions.add(QuizOptionModel(
        keyId: newKey,
        text: opt.text,
        explanation: opt.explanation,
      ));
    }

    return (options: remappedOptions, correctKey: newCorrectKey);
  }
}
