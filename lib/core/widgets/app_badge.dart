import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

enum AppBadgeType {
  completed,
  inProgress,
  locked,
  custom,
}

/// شارة موحدة للحالات والوسوم تعتمد على AppRadius وبدون أيقونات أو إيموجي
class AppBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final AppBadgeType type;
  final bool isOutlined;
  final EdgeInsetsGeometry padding;

  const AppBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.type = AppBadgeType.custom,
    this.isOutlined = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  factory AppBadge.completed({String text = 'مكتمل'}) {
    return AppBadge(
      text: text,
      color: AppColors.mintGreen,
      type: AppBadgeType.completed,
    );
  }

  factory AppBadge.inProgress({String text = 'قيد التعلم'}) {
    return AppBadge(
      text: text,
      color: AppColors.sunnyYellow,
      textColor: const Color(0xFF78350F),
      type: AppBadgeType.inProgress,
    );
  }

  factory AppBadge.locked({String text = 'مقفل'}) {
    return AppBadge(
      text: text,
      color: const Color(0xFF94A3B8),
      type: AppBadgeType.locked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primaryBlue;
    final effectiveTextColor = textColor ?? Colors.white;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isOutlined ? effectiveColor.withValues(alpha: 0.12) : effectiveColor,
        borderRadius: AppRadius.all,
        border: isOutlined
            ? Border.all(color: effectiveColor, width: 1.2)
            : Border.all(color: Colors.transparent, width: 0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isOutlined ? effectiveColor : effectiveTextColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      ),
    );
  }
}
