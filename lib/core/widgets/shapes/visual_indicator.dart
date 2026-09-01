import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';

class VisualIndicator extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final double size;
  final bool isFilled;

  const VisualIndicator({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
    this.size = 28,
    this.isFilled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFilled ? color : color.withValues(alpha: 0.15),
        borderRadius: AppRadius.all,
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? (isFilled ? Colors.white : color),
          fontWeight: FontWeight.bold,
          fontSize: size * 0.45,
        ),
      ),
    );
  }
}
