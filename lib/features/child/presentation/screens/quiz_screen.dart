import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/models/child_models.dart';
import '../bloc/quiz_bloc.dart';
import 'correct_answer_screen.dart';
import 'wrong_answer_screen.dart';

/// 10. شاشة السؤال (Quiz Screen)
/// عرض الموقف مع 4 خيارات مصممة هندسياً (A, B, C, D)
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
  }

  void _onSelectOption(String keyId) {
    context.read<QuizBloc>().add(SelectOptionEvent(keyId));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quiz = widget.mission.quiz;

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state.status == QuizStatus.answeredCorrect) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => CorrectAnswerScreen(mission: widget.mission),
            ),
          );
        } else if (state.status == QuizStatus.answeredWrong) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WrongAnswerScreen(
                mission: widget.mission,
                selectedOption: state.selectedOption,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return AppScaffold(
          title: 'تحدي: ${widget.mission.habitName}',
          subtitle: 'اختر الإجابة الصحيحة يا بطل',
          showBackButton: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة الموقف والسؤال
              AppCard(
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                borderColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderWidth: 1.5,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 12),
                    Text(
                      quiz.situation,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                        fontWeight: FontWeight.w600,
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

              // الخيارات الأربعة التفاعلية المتغيرة (A, B, C, D)
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
