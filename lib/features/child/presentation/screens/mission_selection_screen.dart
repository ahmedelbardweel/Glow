import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_3d_model_viewer.dart';
import '../../../../core/services/asset_preload_service.dart';
import '../../data/models/child_models.dart';
import '../bloc/child_bloc.dart';
import 'story_screen.dart';

/// Application feature screen.
/// Information card.
class MissionSelectionScreen extends StatefulWidget {
  final MissionModel mission;

  const MissionSelectionScreen({super.key, required this.mission});

  @override
  State<MissionSelectionScreen> createState() => _MissionSelectionScreenState();
}

class _MissionSelectionScreenState extends State<MissionSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Background pre-fetch of 3D models and TTS audio for instant launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final charName =
          context.read<ChildBloc>().state.profile.selectedCharacter;
      // ignore: unawaited_futures
      AssetPreloadService().preloadMissionAndStoryAssets(
        mission: widget.mission,
        activeCharacter: charName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final uniqueCharacters = widget.mission.storyScenes.isNotEmpty
        ? widget.mission.storyScenes.map((s) => s.speakerName).toSet()
        : {'PORT'};

    return AppScaffold(
      title: 'المهمة ${mission.number}',
      subtitle: mission.title,
      showBackButton: true,
      showThemeToggle: false,
      body: Stack(
        children: [
          // Background warm-up / preload for 3D character models so they render instantly in StoryScreen
          for (final char in uniqueCharacters)
            Positioned(
              left: -9999,
              top: -9999,
              child: SizedBox(
                width: 1,
                height: 1,
                child: Port3DModelViewer(
                  key: ValueKey('warmup_3d_$char'),
                  characterName: char,
                  height: 1,
                  width: 1,
                  autoRotate: false,
                  cameraControls: false,
                ),
              ),
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),

                      // Information card.
                      AppCard(
                        backgroundColor: isDark
                            ? AppColors.darkSurface
                            : AppColors.pureWhite,
                        borderWidth: 1,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.softMintBackground,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder,
                                    width: 1.5),
                              ),
                              child: Text(
                                '${mission.number}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.sageGreen,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.sageGreen,
                                borderRadius: AppRadius.badge,
                              ),
                              child: const Text(
                                'العادة المستهدفة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              mission.habitName,
                              style: AppTypography.displayMedium.copyWith(
                                color: AppColors.terracottaOrange,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              mission.habitDescription,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textCharcoal,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Information card.
                      AppCard(
                        backgroundColor: isDark
                            ? AppColors.darkSurface
                            : AppColors.pureWhite,
                        borderWidth: 1,
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            const Text(
                              'جوائز إكمال المهمة',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.warmGoldDark,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.warmGoldLight,
                                    borderRadius: AppRadius.badge,
                                    border: Border.all(
                                        color: isDark
                                            ? AppColors.darkBorder
                                            : AppColors.lightBorder,
                                        width: 1),
                                  ),
                                  child: Text(
                                    '+${mission.rewardStars} نجوم ذهبية',
                                    style: const TextStyle(
                                      color: AppColors.warmGoldDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.softMintBackground,
                                    borderRadius: AppRadius.badge,
                                    border: Border.all(
                                        color: isDark
                                            ? AppColors.darkBorder
                                            : AppColors.lightBorder,
                                        width: 1),
                                  ),
                                  child: Text(
                                    '+${mission.rewardPoints} نقطة خبرة',
                                    style: const TextStyle(
                                      color: AppColors.sageGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Information card.
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.warmCreamDark.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Text(
                          'تتكون المهمة من قصة تفاعلية شيقة تليها لعبة أسئلة وتحدي ذكي لاختبار مهاراتك',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textCharcoal,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Action button.
              AppButton(
                text: 'انطلق في القصة والتحدي',
                variant: AppButtonVariant.primary,
                height: 54,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => StoryScreen(mission: mission),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}
