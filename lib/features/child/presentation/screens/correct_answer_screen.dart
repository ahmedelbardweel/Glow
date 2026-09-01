import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_shape_avatar.dart';
import '../../data/models/child_models.dart';
import 'mission_result_screen.dart';

/// Application feature screen.
class CorrectAnswerScreen extends StatelessWidget {
  final MissionModel mission;

  const CorrectAnswerScreen({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      title: 'إجابة صحيحة ومميزة!',
      subtitle: 'أحسنت التفكير والاختيار',
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
                  characterName: 'PORT',
                  size: 110,
                  showBadge: true,
                ),
              ),
              const SizedBox(height: 20),

              // Information card.
              AppCard(
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.softMintBackground,
                borderWidth: 1,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.sageGreen,
                        borderRadius: AppRadius.badge,
                      ),
                      child: const Text(
                        'إجابة نموذجية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'برافوو يا بطل!',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.sageGreen,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      mission.quiz.encouragementCorrect,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action button.
              AppButton(
                text: 'استلام المكافأة والنجوم',
                variant: AppButtonVariant.primary,
                height: 56,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => MissionResultScreen(mission: mission),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
