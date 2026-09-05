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
import 'reward_progress_screen.dart';

/// Application feature screen.
class MissionResultScreen extends StatefulWidget {
  final MissionModel mission;

  const MissionResultScreen({super.key, required this.mission});

  @override
  State<MissionResultScreen> createState() => _MissionResultScreenState();
}

class _MissionResultScreenState extends State<MissionResultScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChildBloc>().add(
      CompleteMissionEvent(
        missionId: widget.mission.id,
        earnedStars: widget.mission.rewardStars,
        earnedPoints: widget.mission.rewardPoints,
        habitName: widget.mission.habitName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String selectedChar = 'PORT';
    try {
      selectedChar = context.watch<ChildBloc>().state.profile.selectedCharacter;
    } catch (_) {}

    return AppScaffold(
      title: 'نتيجة الإنجاز',
      subtitle: 'تهانينا على إتمام المهمة بنجاح!',
      showBackButton: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Interactive 3D Trophy Victory Character
              Center(
                child: Port3DModelViewer(
                  characterName: selectedChar,
                  pose: CharacterPose.victory,
                  height: 280,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              const SizedBox(height: 16),

              // Information card.
              AppCard(
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                borderWidth: 1,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'أنت بطل مذهل!',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.terracottaOrange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لقد أتممت مهمة "${widget.mission.title}" واكتسبت عادة جديدة:',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.softMintBackground,
                        borderRadius: AppRadius.badge,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
                      ),
                      child: Text(
                        'عادة: ${widget.mission.habitName}',
                        style: const TextStyle(
                          color: AppColors.sageGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.warmGoldLight,
                            borderRadius: AppRadius.badge,
                            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
                          ),
                          child: Text(
                            '+${widget.mission.rewardStars} نجوم ذهبية',
                            style: const TextStyle(
                              color: AppColors.warmGoldDark,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.softMintBackground,
                            borderRadius: AppRadius.badge,
                            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
                          ),
                          child: Text(
                            '+${widget.mission.rewardPoints} نقطة خبرة',
                            style: const TextStyle(
                              color: AppColors.sageGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Character selection screen.
              AppButton(
                text: 'استعراض الشارات والتقدم الكامل',
                variant: AppButtonVariant.primary,
                height: 54,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const RewardProgressScreen(),
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
