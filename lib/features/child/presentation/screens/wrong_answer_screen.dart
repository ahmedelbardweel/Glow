import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_shape_avatar.dart';
import '../../data/models/child_models.dart';
import '../bloc/quiz_bloc.dart';

/// Application feature screen.
class WrongAnswerScreen extends StatelessWidget {
  final MissionModel mission;
  final QuizOptionModel? selectedOption;

  const WrongAnswerScreen({
    super.key,
    required this.mission,
    this.selectedOption,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quiz = mission.quiz;

    return AppScaffold(
      title: 'فرصة رائعة للتعلم!',
      subtitle: 'كل محاولة تجعلنا أكثر حكمة وذكاء',
      showBackButton: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Interactive 3D character component.
              const Center(
                child: PortShapeAvatar(
                  characterName: 'FORT',
                  size: 100,
                  showBadge: true,
                ),
              ),
              const SizedBox(height: 20),

              // Information card.
              AppCard(
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.gentleSupportLight,
                borderWidth: 1,
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gentleSupport,
                        borderRadius: AppRadius.badge,
                      ),
                      child: const Text(
                        'خطوة نحو التعلم',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'محاولة جميلة يا بطل!',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.gentleSupport,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      quiz.gentleFeedbackWrong,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                        height: 1.5,
                      ),
                    ),
                    if (selectedOption?.explanation != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceVariant : AppColors.pureWhite,
                          borderRadius: AppRadius.card,
                        ),
                        child: Text(
                          selectedOption!.explanation,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Action button.
              AppButton(
                text: 'أريد المحاولة مرة أخرى الآن',
                variant: AppButtonVariant.primary,
                height: 54,
                onPressed: () {
                  context.read<QuizBloc>().add(ResetQuizEvent());
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
