import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import 'user_selection_screen.dart';

/// 1. شاشة البداية والترحيب (Welcome Screen)
/// تعرض الشعار الرسمي للتطبيق وتحته زر برتقالي واضح "ابدأ" للدخول المباشر
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/port_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            AppButton(
              text: 'ابدأ',
              variant: AppButtonVariant.primary,
              height: 56,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const UserSelectionScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
