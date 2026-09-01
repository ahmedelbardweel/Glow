import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_shape_avatar.dart';
import '../../data/repositories/child_repository.dart';
import '../bloc/child_bloc.dart';
import 'world_map_screen.dart';

/// Character selection screen.
/// Interactive 3D character component.
class RewardProgressScreen extends StatelessWidget {
  const RewardProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ChildBloc, ChildState>(
      builder: (context, state) {
        final profile = state.profile;
        final badges = profile.earnedBadges;

        return AppScaffold(
          title: 'شارات وإنجازات البطل',
          subtitle: 'سجل أوسمة ومكافآت ${profile.name}',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Information card.
              AppCard(
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                borderWidth: 1,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    PortShapeAvatar(
                      characterName: profile.selectedCharacter,
                      size: 70,
                      showBadge: true,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المستوى: ${ChildRepository.calculateRankTitle(profile.points)}',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.sageGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AppProgressBar(
                            value: ChildRepository.calculateLevelProgress(profile.points),
                            progressColor: AppColors.terracottaOrange,
                            height: 10,
                            label: 'الترقية للمستوى التالي',
                            trailingText: '${profile.points} نقطة',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'الأوسمة والشارات المكتسبة (${badges.length})',
                style: AppTypography.titleSmall.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: badges.isEmpty
                  ? Center(
                      child: Text(
                        'أكمل أول مهمة لك لتحصل على وسامك الأول!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: badges.length,
                      itemBuilder: (context, index) {
                        final badge = badges[index];
                        return AppCard(
                          backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.pureWhite,
                          borderWidth: 1,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.warmGoldLight,
                                  borderRadius: AppRadius.badge,
                                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
                                ),
                                child: const Text(
                                  'وسام إنجاز ذهبي',
                                  style: TextStyle(
                                    color: AppColors.warmGoldDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                badge,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.titleSmall.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),

              const SizedBox(height: 12),

              // Action button.
              AppButton(
                text: 'العودة إلى خريطة العوالم',
                variant: AppButtonVariant.primary,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WorldMapScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
