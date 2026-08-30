import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant {
  primary,
  secondary,
  mint,
  warning,
  outlined,
  soft,
}

/// زر موحد لكافة شاشات التطبيق
/// يعتمد بالكامل على AppRadius لتوحيد حواف الأزرار في كل مكان
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final Color? customColor;
  final Color? customTextColor;
  final Widget? leading;
  final Widget? trailing;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 54,
    this.customColor,
    this.customTextColor,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color textColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = customColor ?? AppColors.terracottaOrange;
        textColor = customTextColor ?? Colors.white;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = customColor ?? AppColors.sageGreen;
        textColor = customTextColor ?? Colors.white;
        break;
      case AppButtonVariant.mint:
        backgroundColor = customColor ?? AppColors.sageGreen;
        textColor = customTextColor ?? Colors.white;
        break;
      case AppButtonVariant.warning:
        backgroundColor = customColor ?? AppColors.warmGold;
        textColor = customTextColor ?? AppColors.textCharcoal;
        break;
      case AppButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        textColor = customTextColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.terracottaOrange);
        borderSide = BorderSide(
          color: customColor ?? (isDark ? AppColors.darkBorder : AppColors.terracottaOrange),
          width: 1.5,
        );
        break;
      case AppButtonVariant.soft:
        backgroundColor = customColor ?? (isDark ? AppColors.darkSurfaceVariant : AppColors.terracottaLight);
        textColor = customTextColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.terracottaOrange);
        break;
    }

    final buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 8),
        ],
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        else
          Text(
            text,
            style: AppTypography.labelLarge.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: Material(
        color: onPressed == null ? backgroundColor.withValues(alpha: 0.5) : backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
          side: borderSide,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppRadius.button,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(child: buttonContent),
          ),
        ),
      ),
    );
  }
}
