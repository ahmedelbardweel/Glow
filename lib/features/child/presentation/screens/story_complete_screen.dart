import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_3d_model_viewer.dart';
import '../../data/models/child_models.dart';
import '../bloc/child_bloc.dart';
import 'quiz_screen.dart';

/// Interactive story narration screen.
class StoryCompleteScreen extends StatelessWidget {
  final MissionModel mission;

  const StoryCompleteScreen({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String selectedChar = 'PORT';
    try {
      selectedChar = context.watch<ChildBloc>().state.profile.selectedCharacter;
    } catch (_) {}

    return AppScaffold(
      title: 'أحسنت يا بطل!',
      subtitle: 'حان وقت التحدي وتطبيق ما تعلمناه',
      showBackButton: false,
      showThemeToggle: false,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Interactive 3D Trophy Victory Character
              Center(
                child: Port3DModelViewer(
                  characterName: selectedChar,
                  pose: CharacterPose.victory,
                  height: 270,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              const SizedBox(height: 16),

              // Information card.
              AppCard(
                backgroundColor:
                    isDark ? AppColors.darkSurface : AppColors.pureWhite,
                borderWidth: 1,
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.sageGreen,
                        borderRadius: AppRadius.badge,
                      ),
                      child: Text(
                        'رسالة من رفيقك البطل $selectedChar',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لقد كانت قصة رائعة ومفيدة عن عادة:\n"${mission.habitName}"!\n\nهل تساعدني في اختيار التصرف السليم في هذا الموقف الذكي؟',
                      textAlign: TextAlign.center,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textCharcoal,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Action button.
              AppButton(
                text: 'نعم! أنا جاهز للتحدي الذكي',
                variant: AppButtonVariant.primary,
                height: 56,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(mission: mission),
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
