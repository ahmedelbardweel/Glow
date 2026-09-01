import 'package:flutter/material.dart';

class WorldSceneryPainter extends CustomPainter {
  final int worldNumber;
  final bool isUnlocked;
  final bool isDark;

  WorldSceneryPainter({
    required this.worldNumber,
    required this.isUnlocked,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    switch (worldNumber) {
      case 1:
        _drawForestScenery(canvas, size, rect);
        break;
      case 2:
        _drawOceanScenery(canvas, size, rect);
        break;
      case 3:
        _drawMountainScenery(canvas, size, rect);
        break;
      case 4:
        _drawKingdomScenery(canvas, size, rect);
        break;
      case 5:
        _drawOasisScenery(canvas, size, rect);
        break;
      case 6:
        _drawSummitScenery(canvas, size, rect);
        break;
      default:
        _drawForestScenery(canvas, size, rect);
    }
  }

  void _drawForestScenery(Canvas canvas, Size size, Rect rect) {
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF1E281E), const Color(0xFF2A382A)]
            : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    final sunPaint = Paint()
      ..color = (isUnlocked ? const Color(0xFFFFD54F) : const Color(0xFFBDBDBD)).withValues(alpha: 0.85);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.32), 24, sunPaint);

    _drawCloud(canvas, Offset(size.width * 0.15, size.height * 0.22), 48, 16);
    _drawCloud(canvas, Offset(size.width * 0.50, size.height * 0.18), 38, 14);

    final hill1 = Paint()
      ..color = (isUnlocked ? const Color(0xFF81C784) : const Color(0xFF9E9E9E)).withValues(alpha: isDark ? 0.4 : 0.8);
    final p1 = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.4, size.width * 0.7, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.8, size.width, size.height * 0.65)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p1, hill1);

    final hill2 = Paint()
      ..color = (isUnlocked ? const Color(0xFF4CAF50) : const Color(0xFF757575)).withValues(alpha: isDark ? 0.6 : 0.95);
    final p2 = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.55, size.width, size.height * 0.8)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p2, hill2);

    _drawPineTree(canvas, Offset(size.width * 0.18, size.height * 0.62), 22, 38, isUnlocked ? const Color(0xFF2E7D32) : const Color(0xFF616161));
    _drawPineTree(canvas, Offset(size.width * 0.88, size.height * 0.70), 18, 30, isUnlocked ? const Color(0xFF1B5E20) : const Color(0xFF424242));
  }

  void _drawOceanScenery(Canvas canvas, Size size, Rect rect) {
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF1A2634), const Color(0xFF243342)]
            : [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC)],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    final sunPaint = Paint()
      ..color = (isUnlocked ? const Color(0xFFFFB74D) : const Color(0xFFBDBDBD)).withValues(alpha: 0.85);
    canvas.drawCircle(Offset(size.width * 0.20, size.height * 0.32), 24, sunPaint);

    _drawCloud(canvas, Offset(size.width * 0.65, size.height * 0.2), 48, 16);

    final wave1 = Paint()
      ..color = (isUnlocked ? const Color(0xFF4FC3F7) : const Color(0xFF9E9E9E)).withValues(alpha: isDark ? 0.4 : 0.7);
    final p1 = Path()
      ..moveTo(0, size.height * 0.62)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.52, size.width * 0.5, size.height * 0.62)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.72, size.width, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p1, wave1);

    final wave2 = Paint()
      ..color = (isUnlocked ? const Color(0xFF0288D1) : const Color(0xFF757575)).withValues(alpha: isDark ? 0.6 : 0.95);
    final p2 = Path()
      ..moveTo(0, size.height * 0.74)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.85, size.width * 0.65, size.height * 0.70)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.62, size.width, size.height * 0.76)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p2, wave2);
  }

  void _drawMountainScenery(Canvas canvas, Size size, Rect rect) {
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF2C221A), const Color(0xFF3D2C22)]
            : [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    final sunPaint = Paint()
      ..color = (isUnlocked ? const Color(0xFFFF8A65) : const Color(0xFFBDBDBD)).withValues(alpha: 0.85);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.28), 22, sunPaint);

    final m1 = Paint()
      ..color = (isUnlocked ? const Color(0xFFFFAB91) : const Color(0xFF9E9E9E)).withValues(alpha: isDark ? 0.4 : 0.8);
    final p1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.3, size.height * 0.35)
      ..lineTo(size.width * 0.65, size.height)
      ..close();
    canvas.drawPath(p1, m1);

    final m2 = Paint()
      ..color = (isUnlocked ? const Color(0xFFE64A19) : const Color(0xFF616161)).withValues(alpha: isDark ? 0.6 : 0.95);
    final p2 = Path()
      ..moveTo(size.width * 0.35, size.height)
      ..lineTo(size.width * 0.75, size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(p2, m2);
  }

  void _drawKingdomScenery(Canvas canvas, Size size, Rect rect) {
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF2A2818), const Color(0xFF383520)]
            : [const Color(0xFFFFFDE7), const Color(0xFFFFF9C4)],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    final sunPaint = Paint()
      ..color = (isUnlocked ? const Color(0xFFFFD54F) : const Color(0xFFBDBDBD)).withValues(alpha: 0.85);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.25), 26, sunPaint);

    final tPaint = Paint()
      ..color = (isUnlocked ? const Color(0xFFFBC02D) : const Color(0xFF757575)).withValues(alpha: isDark ? 0.6 : 0.95);

    final bPath = Path()
      ..moveTo(size.width * 0.4, size.height)
      ..lineTo(size.width * 0.4, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.35)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width * 0.6, size.height)
      ..close();
    canvas.drawPath(bPath, tPaint);
  }

  /// Application color palette design tokens.
  void _drawOasisScenery(Canvas canvas, Size size, Rect rect) {
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF261C2B), const Color(0xFF34233D)]
            : [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    final sunPaint = Paint()
      ..color = (isUnlocked ? const Color(0xFFBA68C8) : const Color(0xFFBDBDBD)).withValues(alpha: 0.7);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 25, sunPaint);

    final hill = Paint()
      ..color = (isUnlocked ? const Color(0xFF8E24AA) : const Color(0xFF757575)).withValues(alpha: isDark ? 0.6 : 0.9);
    final p = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.45, size.width, size.height * 0.75)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p, hill);
  }

  void _drawSummitScenery(Canvas canvas, Size size, Rect rect) {
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF2A2315), const Color(0xFF3D321A)]
            : [const Color(0xFFFFF8E1), const Color(0xFFFFECB3)],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    final sunPaint = Paint()
      ..color = (isUnlocked ? const Color(0xFFFFC107) : const Color(0xFFBDBDBD)).withValues(alpha: 0.85);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.22), 28, sunPaint);

    final summitPaint = Paint()
      ..color = (isUnlocked ? const Color(0xFFFFA000) : const Color(0xFF757575)).withValues(alpha: isDark ? 0.6 : 0.95);
    final p = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(p, summitPaint);
  }

  void _drawCloud(Canvas canvas, Offset center, double width, double height) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: isUnlocked ? 0.85 : 0.4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: width, height: height),
        Radius.circular(height / 2),
      ),
      paint,
    );
  }

  void _drawPineTree(Canvas canvas, Offset bottomCenter, double width, double height, Color color) {
    final treePaint = Paint()..color = color;
    final path = Path()
      ..moveTo(bottomCenter.dx, bottomCenter.dy - height)
      ..lineTo(bottomCenter.dx - width / 2, bottomCenter.dy)
      ..lineTo(bottomCenter.dx + width / 2, bottomCenter.dy)
      ..close();
    canvas.drawPath(path, treePaint);
  }

  @override
  bool shouldRepaint(covariant WorldSceneryPainter oldDelegate) =>
      oldDelegate.worldNumber != worldNumber ||
      oldDelegate.isUnlocked != isUnlocked ||
      oldDelegate.isDark != isDark;
}
