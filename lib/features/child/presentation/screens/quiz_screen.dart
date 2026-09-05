import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/services/asset_preload_service.dart';
import '../../data/models/child_models.dart';
import '../bloc/child_bloc.dart';
import '../bloc/quiz_bloc.dart';
import 'correct_answer_screen.dart';
import 'wrong_answer_screen.dart';

/// Interactive scenario challenge screen supporting 10 multi-question quizzes.
class QuizScreen extends StatefulWidget {
  final MissionModel mission;

  const QuizScreen({super.key, required this.mission});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(InitQuizEvent(widget.mission));

    // Preload both victory (for correct answer) and frontal (for wrong answer) ahead of submission
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final charName = context.read<ChildBloc>().state.profile.selectedCharacter;
      // ignore: unawaited_futures
      AssetPreloadService().preloadQuizCompletionAssets(activeCharacter: charName);
    });
  }

  void _onSelectOption(String keyId) {
    context.read<QuizBloc>().add(SelectOptionEvent(keyId));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state.status == QuizStatus.completed) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => CorrectAnswerScreen(mission: widget.mission),
            ),
          );
        } else if (state.status == QuizStatus.answeredCorrect) {
          // Show quick celebration snackbar and move to next question.
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'إجابة صحيحة يا بطل! أحسنت 👏 (${state.currentQuestionIndex + 1}/${state.totalQuestions})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: AppColors.sageGreen,
              duration: const Duration(milliseconds: 1400),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          final quizBloc = context.read<QuizBloc>();
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              quizBloc.add(NextQuestionEvent());
            }
          });
        } else if (state.status == QuizStatus.answeredWrong) {
          final quizBloc = context.read<QuizBloc>();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WrongAnswerScreen(
                mission: widget.mission,
                selectedOption: state.selectedOption,
              ),
            ),
          ).then((_) {
            if (mounted) {
              quizBloc.add(ResetQuizEvent());
            }
          });
        }
      },
      builder: (context, state) {
        final quiz = state.currentQuiz;
        final questionNum = state.currentQuestionIndex + 1;
        final totalQuestions = state.totalQuestions;
        final progress = (questionNum / totalQuestions).clamp(0.0, 1.0);

        return AppScaffold(
          title: 'تحدي: ${widget.mission.habitName}',
          subtitle: 'السؤال $questionNum من $totalQuestions',
          showBackButton: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تقدم التحدي',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.terracottaOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$questionNum / $totalQuestions',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.terracottaOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        tween: Tween<double>(begin: 0, end: progress),
                        builder: (context, val, _) => LinearProgressIndicator(
                          value: val,
                          minHeight: 8,
                          backgroundColor: isDark ? AppColors.darkBorder : const Color(0xFFEBE5DF),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.terracottaOrange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Information card.
              AppCard(
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                borderColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderWidth: 1.5,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.terracottaOrange,
                            borderRadius: AppRadius.badge,
                          ),
                          child: const Text(
                            'الموقف التفاعلي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'سؤال $questionNum',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      quiz.situation,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      quiz.question,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.terracottaOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: Builder(
                  builder: (context) {
                    final displayOptions = state.randomizedOptions.isNotEmpty
                        ? state.randomizedOptions
                        : quiz.options;

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: displayOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final option = displayOptions[index];

                        return AppCard(
                          borderWidth: 1,
                          backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                          padding: const EdgeInsets.all(16),
                          onTap: () => _onSelectOption(option.keyId),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.terracottaLight,
                                  borderRadius: AppRadius.badge,
                                  border: Border.all(
                                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  option.keyId,
                                  style: const TextStyle(
                                    color: AppColors.terracottaOrange,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  option.text,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

