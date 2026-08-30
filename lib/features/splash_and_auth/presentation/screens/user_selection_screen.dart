import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_shape_avatar.dart';
import '../../../child/presentation/screens/child_profile_setup_screen.dart';
import '../../../parent/presentation/screens/parent_auth_screen.dart';
import '../../../organization/presentation/screens/org_setup_screen.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            AppCard(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
              borderWidth: 1,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // مشهد ترحيبي ملون لأبطال PORT
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF3D2314), const Color(0xFF5C381E)]
                            : [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          PortShapeAvatar(characterName: 'MORT', size: 54, showBadge: false),
                          SizedBox(width: 10),
                          PortShapeAvatar(characterName: 'PORT', size: 68, showBadge: false),
                          SizedBox(width: 10),
                          PortShapeAvatar(characterName: 'FORT', size: 54, showBadge: false),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Text(
                          'أنا طفل بطل',
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.terracottaOrange,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'انطلق في مغامرات شيقة، قصص تفاعلية، واكتشف عادات وقوى أبطال PORT',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          text: 'دخول رحلة الطفل والمغامرة',
                          variant: AppButtonVariant.primary,
                          height: 52,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ChildProfileSetupScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 2. بوابة ولي الأمر (Parent Gateway)
            AppCard(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
              borderWidth: 1,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'أنا ولي أمر',
                              style: AppTypography.titleMedium.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'متابعة تطور العادات الـ 30 والأنشطة المنزلية',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppButton(
                    text: 'لوحة تحكم ولي الأمر',
                    variant: AppButtonVariant.secondary,
                    height: 48,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ParentAuthScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 3. بوابة المنظمة التعليمية (Organization B2B Gateway)
            AppCard(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
              borderWidth: 1,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'أنا منظمة تعليمية',
                              style: AppTypography.titleMedium.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'إدارة المدارس والفصول واستخراج التقارير',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppButton(
                    text: 'بوابة المنظمة التعليمية',
                    variant: AppButtonVariant.warning,
                    height: 48,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OrgSetupScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
