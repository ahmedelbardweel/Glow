import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_shape_avatar.dart';
import '../bloc/parent_bloc.dart';
import 'habit_progress_report_screen.dart';
import 'home_activities_screen.dart';
import 'subscription_screen.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ParentBloc, ParentState>(
      builder: (context, state) {
        return AppScaffold(
          title: 'لوحة تحكم الأسرة',
          subtitle: 'متابعة البطل ${state.childName} (${state.childAge} سنوات)',
          showBackButton: false,
          actions: [
            // Action button.
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                );
              },
              borderRadius: AppRadius.button,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.warmGold.withValues(alpha: 0.2) : AppColors.warmGoldLight,
                  borderRadius: AppRadius.button,
                  border: Border.all(color: AppColors.warmGold, width: 1.2),
                ),
                child: Text(
                  state.isSubscribed ? 'مشترك مميز' : 'ترقية الحساب',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warmGoldDark,
                  ),
                ),
              ),
            ),
          ],
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // Information card.
                AppCard(
                  backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF6F3EE),
                  borderWidth: 1,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      PortShapeAvatar(
                        characterName: state.selectedCharacter,
                        size: 48,
                        showBadge: false,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  state.childName,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.sageGreen.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    state.childId,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.sageGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'الرفيق: ${state.selectedCharacter} • ${state.totalStars} ⭐ • ${state.totalPoints} نقطة',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.sync_rounded, color: AppColors.sageGreen),
                        tooltip: 'تحديث البيانات من السحابة',
                        onPressed: () {
                          context.read<ParentBloc>().add(LoadParentDashboardEvent());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('جاري مزامنة بيانات الطفل مع Supabase...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Information card.
                AppCard(
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                  borderWidth: 1,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.sageGreen,
                              borderRadius: AppRadius.badge,
                            ),
                            child: const Text(
                              'العالم الحالي',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.currentWorldName,
                              style: AppTypography.titleSmall.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppProgressBar(
                        value: state.progressPercent / 100,
                        progressColor: AppColors.sageGreen,
                        label: 'معدل إنجاز العادات الحالية',
                        trailingText: '${state.progressPercent}%',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Key performance indicators and metrics.
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                        borderWidth: 1,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              '${state.learnedCount}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.sageGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'عادات مكتسبة',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppCard(
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                        borderWidth: 1,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              '${state.inProgressCount}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.warmGoldDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'قيد التعلم',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppCard(
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                        borderWidth: 1,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              '${state.lockedCount}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLightMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'متبقية',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  'أدوات المتابعة والدعم الأسري',
                  style: AppTypography.titleSmall.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                AppCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HabitProgressReportScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.softMintBackground,
                          borderRadius: AppRadius.badge,
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
                        ),
                        child: const Text(
                          '30',
                          style: TextStyle(
                            color: AppColors.sageGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'شاشة العادات والتقارير التفصيلية',
                              style: AppTypography.titleSmall.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'تتبع حالة كل عادة ونقاط القوة واقتراحات الدعم الموجهة.',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'فتح',
                        style: TextStyle(
                          color: AppColors.sageGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                AppCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HomeActivitiesScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.terracottaLight,
                          borderRadius: AppRadius.badge,
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
                        ),
                        child: const Text(
                          'منزل',
                          style: TextStyle(
                            color: AppColors.terracottaOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'شاشة الأنشطة المنزلية اليومية',
                              style: AppTypography.titleSmall.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'أفكار وأنشطة تطبيقية في الواقع لترسيخ العادات مع الأسرة.',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'فتح',
                        style: TextStyle(
                          color: AppColors.terracottaOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Subscription and membership tiers screen.
                AppCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.warmGoldLight,
                          borderRadius: AppRadius.badge,
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
                        ),
                        child: const Text(
                          'باقة',
                          style: TextStyle(
                            color: AppColors.warmGoldDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'خطط ومميزات الاشتراك',
                              style: AppTypography.titleSmall.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'استكشاف مزايا العوالم المتقدمة 4 و 5 وحفظ التقدم دائماً.',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'فتح',
                        style: TextStyle(
                          color: AppColors.lavenderPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
