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
  const InitQuizEvent(this.mission);
  @override
  List<Object?> get props => [mission];
}

class SelectOptionEvent extends QuizEvent {
  final String keyId;
  const SelectOptionEvent(this.keyId);
  @override
  List<Object?> get props => [keyId];
}

class ResetQuizEvent extends QuizEvent {}

// === State ===
enum QuizStatus { initial, answeredCorrect, answeredWrong }

class QuizState extends Equatable {
  final MissionModel? mission;
  final String? selectedKeyId;
  final QuizStatus status;
  final QuizOptionModel? selectedOption;
  final List<QuizOptionModel> randomizedOptions;
  final String activeCorrectKey;

  const QuizState({
    this.mission,
    this.selectedKeyId,
    this.status = QuizStatus.initial,
    this.selectedOption,
    this.randomizedOptions = const [],
    this.activeCorrectKey = 'A',
  });

  QuizModel? get quiz => mission?.quiz;

  bool get isCorrect => status == QuizStatus.answeredCorrect;
  bool get isWrong => status == QuizStatus.answeredWrong;

  QuizState copyWith({
    MissionModel? mission,
    String? selectedKeyId,
    QuizStatus? status,
    QuizOptionModel? selectedOption,
    List<QuizOptionModel>? randomizedOptions,
    String? activeCorrectKey,
  }) {
    return QuizState(
      mission: mission ?? this.mission,
      selectedKeyId: selectedKeyId ?? this.selectedKeyId,
      status: status ?? this.status,
      selectedOption: selectedOption ?? this.selectedOption,
      randomizedOptions: randomizedOptions ?? this.randomizedOptions,
      activeCorrectKey: activeCorrectKey ?? this.activeCorrectKey,
    );
  }

  @override
  List<Object?> get props => [
        mission,
        selectedKeyId,
        status,
        selectedOption,
        randomizedOptions,
        activeCorrectKey,
      ];
}

// === BLoC مع خوارزمية التوزيع الذكي للخيارات لمنع الحفظ النمطي ===
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(const QuizState()) {
    on<InitQuizEvent>((event, emit) {
      final originalOptions = List<QuizOptionModel>.from(event.mission.quiz.options);
      
      // خوارزمية توزيع الخيارات العشوائي الذكي مع إعادة تعيين المفاتيح
      originalOptions.shuffle();
      final keys = ['A', 'B', 'C', 'D'];
      String newCorrectKey = 'A';
      
      final remappedOptions = <QuizOptionModel>[];
      for (int i = 0; i < originalOptions.length && i < keys.length; i++) {
        final opt = originalOptions[i];
        final newKey = keys[i];
        if (opt.keyId == event.mission.quiz.correctKeyId) {
          newCorrectKey = newKey;
        }
        remappedOptions.add(QuizOptionModel(
          keyId: newKey,
          text: opt.text,
          explanation: opt.explanation,
        ));
      }

      emit(QuizState(
        mission: event.mission,
        status: QuizStatus.initial,
        randomizedOptions: remappedOptions,
        activeCorrectKey: newCorrectKey,
      ));
    });

    on<SelectOptionEvent>((event, emit) {
      if (state.randomizedOptions.isEmpty) return;
      final option = state.randomizedOptions.firstWhere(
        (o) => o.keyId == event.keyId,
        orElse: () => state.randomizedOptions.first,
      );

      final isCorrect = event.keyId == state.activeCorrectKey;

      emit(state.copyWith(
        selectedKeyId: event.keyId,
        selectedOption: option,
        status: isCorrect ? QuizStatus.answeredCorrect : QuizStatus.answeredWrong,
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
}
