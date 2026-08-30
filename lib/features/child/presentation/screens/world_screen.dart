import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/models/child_models.dart';
import '../bloc/child_bloc.dart';
import '../widgets/world_scenery_painter.dart';
import 'mission_selection_screen.dart';

/// شاشة استعراض بيئة العالم ومهماته الخمس التفاعلية للأطفال بدون أي إيموجي
class WorldScreen extends StatelessWidget {
  final WorldModel world;

  const WorldScreen({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ChildBloc, ChildState>(
      builder: (context, state) {
        final completedMissions = state.profile.completedMissions;

        return AppScaffold(
          title: world.name,
          subtitle: 'اختر مهمتك وانطلق في المغامرة',
          showBackButton: true,
          showThemeToggle: false,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          body: Column(
            children: [
              // لافتة بيئة العالم المصورة
              AppCard(
                padding: EdgeInsets.zero,
                backgroundColor:
                    isDark ? AppColors.darkSurface : AppColors.pureWhite,
                borderWidth: 1,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadius.cardRadiusValue)),
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: WorldSceneryPainter(
                            worldNumber: world.worldNumber,
                            isUnlocked: true,
                            isDark: isDark,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  world.name,
                                  style: AppTypography.titleMedium.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textCharcoal,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  world.description,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.softMintBackground,
                              borderRadius: AppRadius.badge,
                              border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                  width: 1),
                            ),
                            child: const Text(
                              '5 مهمات',
                              style: TextStyle(
                                color: AppColors.sageGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // قائمة المهمات الخمس التفاعلية
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: world.missions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final mission = world.missions[index];
                    final isCompleted = completedMissions.contains(mission.id);
                    final isAvailable = index == 0 ||
                        completedMissions
                            .contains(world.missions[index - 1].id) ||
                        isCompleted;

                    return AppCard(
                      borderWidth: 1,
                      backgroundColor: isAvailable
                          ? (isDark
                              ? AppColors.darkSurface
                              : AppColors.pureWhite)
                          : (isDark
                              ? AppColors.darkSurfaceVariant
                              : const Color(0xFFF5EBE0).withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      onTap: isAvailable
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MissionSelectionScreen(mission: mission),
                                ),
                              );
                            }
                          : null,
                      child: Row(
                        children: [
                          // رقم المهمة
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.sageGreen
                                  : (isAvailable
                                      ? AppColors.terracottaOrange
                                      : const Color(0xFFB0A695)),
                              shape: BoxShape.circle,
                              boxShadow: isAvailable && !isCompleted
                                  ? [
                                      BoxShadow(
                                        color: AppColors.terracottaOrange
                                            .withValues(alpha: 0.35),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              '${mission.number}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // اسم المهمة وتفاصيل العادة
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mission.title,
                                  style: AppTypography.titleSmall.copyWith(
                                    color: isAvailable
                                        ? (isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textCharcoal)
                                        : AppColors.textLightMuted,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.softMintBackground,
                                        borderRadius: AppRadius.badge,
                                      ),
                                      child: Text(
                                        'عادة: ${mission.habitName}',
                                        style: const TextStyle(
                                          color: AppColors.sageGreen,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '+${mission.rewardStars} نجوم',
                                      style: const TextStyle(
                                        color: AppColors.warmGoldDark,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // زر البدء أو علامة الإنجاز
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.softMintBackground,
                                borderRadius: AppRadius.badge,
                                border: Border.all(
                                    color: AppColors.sageGreen, width: 1),
                              ),
                              child: const Text(
                                'مكتملة',
                                style: TextStyle(
                                  color: AppColors.sageGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else if (isAvailable)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.terracottaOrange,
                                borderRadius: AppRadius.button,
                              ),
                              child: const Text(
                                'ابدأ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            const Text(
                              'مقفل',
                              style: TextStyle(
                                color: AppColors.textLightMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
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
