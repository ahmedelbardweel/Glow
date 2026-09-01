import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/database/hive_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/parent_bloc.dart';
import 'parent_dashboard_screen.dart';

/// Child adventure portal.
class ParentAuthScreen extends StatefulWidget {
  const ParentAuthScreen({super.key});

  @override
  State<ParentAuthScreen> createState() => _ParentAuthScreenState();
}

class _ParentAuthScreenState extends State<ParentAuthScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _childIdController;
  String? _detectedLocalChildId;
  String? _detectedLocalChildName;

  @override
  void initState() {
    super.initState();
    final savedEmail = HiveService.getSetting<String>(HiveKeys.parentEmailKey, defaultValue: 'parent@portapp.com');
    final linkedId = HiveService.getSetting<String>(HiveKeys.linkedChildIdKey, defaultValue: '');

    final localChild = HiveService.getChildData<Map>(HiveKeys.childProfileKey);
    if (localChild != null) {
      _detectedLocalChildId = localChild['childId']?.toString();
      _detectedLocalChildName = localChild['name']?.toString();
    }

    final initialCode = linkedId.isNotEmpty
        ? linkedId
        : (_detectedLocalChildId ?? 'PORT-1001');

    _emailController = TextEditingController(text: savedEmail);
    _childIdController = TextEditingController(text: initialCode);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _childIdController.dispose();
    super.dispose();
  }

  void _onEnterDashboard() {
    final email = _emailController.text.trim();
    final childId = _childIdController.text.trim().toUpperCase();

    if (email.isEmpty || childId.isEmpty) return;

    context.read<ParentBloc>().add(
      LinkChildWithIdEvent(
        email: email,
        childId: childId,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ParentDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      title: 'بوابة ولي الأمر',
      subtitle: 'ربط حسابك بطفلك ومتابعة نموه وعاداته',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            AppCard(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.softMintBackground,
              borderColor: AppColors.sageGreen.withValues(alpha: 0.4),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.sageGreen.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.qr_code_2_rounded, color: AppColors.sageGreen, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ربط فوري بدون تعقيد للطفل',
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.sageGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'أدخل كود الطفل الفريد (Child ID) الظاهر تحت اسم طفلك في الشاشة لربط حسابه ومتابعة كافة عاداته وإنجازاته.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Input field.
            AppTextField(
              label: 'البريد الإلكتروني لولي الأمر',
              hint: 'parent@email.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            // Input field.
            AppTextField(
              label: 'كود الطفل الفريد (Child ID)',
              hint: 'مثال: PORT-8492',
              controller: _childIdController,
            ),

            if (_detectedLocalChildId != null) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    _childIdController.text = _detectedLocalChildId!;
                  });
                },
                borderRadius: AppRadius.badge,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warmGold.withValues(alpha: 0.12),
                    borderRadius: AppRadius.badge,
                    border: Border.all(
                      color: AppColors.warmGoldDark.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: AppColors.warmGoldDark),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تم اكتشاف ملف ($_detectedLocalChildName) على هذا الجهاز: $_detectedLocalChildId',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warmGoldDark,
                          ),
                        ),
                      ),
                      const Text(
                        'استخدام',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.warmGoldDark,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28),

            // Action button.
            AppButton(
              text: 'ربط ودخول لوحة تحكم الأسرة',
              variant: AppButtonVariant.primary,
              height: 54,
              onPressed: _onEnterDashboard,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
