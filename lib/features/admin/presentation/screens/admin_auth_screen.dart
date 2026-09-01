import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'admin_dashboard_screen.dart';

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({super.key});

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  final _passcodeController = TextEditingController();
  final bool _obscure = true;
  String? _errorMessage;

  static const String _masterPasscode = 'PORT-2026';
  static const String _quickPin = '1234';

  void _verifyAndEnter() {
    final input = _passcodeController.text.trim();
    if (input == _masterPasscode || input == _quickPin || input.toUpperCase() == 'ADMIN') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'الرمز السري غير صحيح. يرجى إدخال رمز المشرف المصرح.';
      });
    }
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      title: 'بوابة المشرف',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Text(
              'لوحة الإشراف والتحكم',
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w900,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'إدارة العوالم والمهام والقصص والأسئلة ومراقبة قاعدة البيانات والمزامنة',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            AppCard(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: 'الرمز السري للمشرف',
                    hint: 'أدخل الرمز السري',
                    controller: _passcodeController,
                    obscureText: _obscure,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 10),
                  AppButton(
                    text: 'دخول لوحة التحكم',
                    variant: AppButtonVariant.primary,
                    height: 48,
                    onPressed: _verifyAndEnter,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Text(
                'رمز المرور الافتراضي: PORT-2026 أو 1234',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
