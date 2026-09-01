import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class AppProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? progressColor;
  final Color? backgroundColor;
  final String? label;
  final String? trailingText;

  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 14,
    this.progressColor,
    this.backgroundColor,
    this.label,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedValue = value.clamp(0.0, 1.0);
    final effectiveProgressColor = progressColor ?? AppColors.mintGreen;
    final effectiveBg = backgroundColor ?? (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || trailingText != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              if (trailingText != null)
                Text(
                  trailingText!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: effectiveProgressColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: AppRadius.all,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * clampedValue,
                    height: height,
                    decoration: BoxDecoration(
                      color: effectiveProgressColor,
                      borderRadius: AppRadius.all,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
