import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../bloc/parent_bloc.dart';

/// Subscription and membership tiers screen.
/// Persists state changes.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedPlan = 'yearly'; // monthly, yearly

  void _onSubscribe() async {
    final planName = _selectedPlan == 'yearly' ? 'الباقة السنوية للتميز' : 'الباقة الشهرية المرنة';

    context.read<ParentBloc>().add(SubscribePlanEvent(planName));

    await AppDialog.show(
      context,
      title: 'تم تفعيل الاشتراك بنجاح!',
      message: 'شكراً لانضمامكم لعائلة PORT المميزة! تم فتح جميع العوالم المتقدمة (4 و 5) والتقارير الشاملة.',
      confirmText: 'الاستمتاع بالمغامرة',
    );

    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ParentBloc, ParentState>(
      builder: (context, state) {
        return AppScaffold(
          title: 'اشتراك PORT للتميز',
          subtitle: 'فتح كافة العوالم والتقارير والأنشطة',
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // Persists state changes.
                AppCard(
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lavenderPurple.withValues(alpha: 0.1),
                  borderColor: AppColors.lavenderPurple,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.lavenderPurple,
                          borderRadius: AppRadius.all,
                        ),
                        child: const Text(
                          'ضمان PORT',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'تقدم طفلك ونجومه وشاراته محفوظة للأبد، حتى في حال انتهاء الاشتراك.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Typography scale tokens.
                AppCard(
                  borderColor: _selectedPlan == 'yearly' ? AppColors.sunnyYellow : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  borderWidth: _selectedPlan == 'yearly' ? 2.5 : 1,
                  backgroundColor: _selectedPlan == 'yearly'
                      ? AppColors.sunnyYellow.withValues(alpha: isDark ? 0.15 : 0.08)
                      : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                  padding: const EdgeInsets.all(16),
                  onTap: () => setState(() => _selectedPlan = 'yearly'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الباقة السنوية (الأكثر توفيراً)',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.sunnyYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.sunnyYellow,
                              borderRadius: AppRadius.all,
                            ),
                            child: const Text(
                              'وفر 45%',
                              style: TextStyle(color: Color(0xFF78350F), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '199 ريال / سنوياً (شاملة كافة التحديثات)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'فتح كافة العوالم الخمسة، 30 عادة كاملة، وتقارير PDF وتحليلات غير محدودة.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Typography scale tokens.
                AppCard(
                  borderColor: _selectedPlan == 'monthly' ? AppColors.primaryBlue : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  borderWidth: _selectedPlan == 'monthly' ? 2.5 : 1,
                  backgroundColor: _selectedPlan == 'monthly'
                      ? AppColors.primaryBlue.withValues(alpha: isDark ? 0.15 : 0.08)
                      : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                  padding: const EdgeInsets.all(16),
                  onTap: () => setState(() => _selectedPlan = 'monthly'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الباقة الشهرية المرنة',
                        style: AppTypography.titleSmall.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '29 ريال / شهرياً',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'تجديد شهري تلقائي مع إمكانية الإلغاء في أي وقت بنقرة واحدة.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action button.
                AppButton(
                  text: state.isSubscribed ? 'أنت مشترك بالفعل (تعديل الخطة)' : 'تأكيد الاشتراك وتفعيل الميزات',
                  variant: AppButtonVariant.primary,
                  height: 54,
                  onPressed: _onSubscribe,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
