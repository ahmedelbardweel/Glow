import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// Interactive 3D character component.
/// Interactive 3D character component.
class PortShapeAvatar extends StatelessWidget {
  final String characterName; // PORT, MORT, FORT, QORT, LORT
  final double size;
  final bool showBadge;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool use3D;

  const PortShapeAvatar({
    super.key,
    required this.characterName,
    this.size = 70,
    this.showBadge = true,
    this.onTap,
    this.isSelected = false,
    this.use3D = true,
  });

  String _getCharacterAssetPath() {
    switch (characterName.toUpperCase()) {
      case 'MORT':
        return 'assets/images/characters/mort_3d.jpg';
      case 'FORT':
        return 'assets/images/characters/fort_3d.jpg';
      case 'QORT':
        return 'assets/images/characters/qort_3d.jpg';
      case 'LORT':
      case 'SORT':
        return 'assets/images/characters/lort_3d.jpg';
      case 'PORT':
      default:
        return 'assets/images/characters/port_3d.jpg';
    }
  }

  Color _getCharacterColor() {
    switch (characterName.toUpperCase()) {
      case 'MORT':
        return AppColors.mortColor;
      case 'FORT':
        return AppColors.fortColor;
      case 'LORT':
      case 'SORT':
        return AppColors.sortColor;
      case 'QORT':
        return AppColors.qortColor;
      case 'PORT':
      default:
        return AppColors.portColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCharacterColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assetPath = _getCharacterAssetPath();

    Widget avatarWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: isSelected ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isSelected ? 2.5 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Interactive 3D character component.
          if (use3D)
            ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.22),
              child: SizedBox(
                width: size,
                height: size,
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: const Alignment(-0.68, -0.65),
                  child: SizedBox(
                    width: size * 2.5,
                    height: size * 2.5,
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      alignment: const Alignment(-0.68, -0.65),
                      errorBuilder: (_, __, ___) => CustomPaint(
                        size: Size(size * 0.72, size * 0.72),
                        painter: _CharacterFacePainter(
                          color: color,
                          character: characterName.toUpperCase(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            CustomPaint(
              size: Size(size * 0.72, size * 0.72),
              painter: _CharacterFacePainter(
                color: color,
                character: characterName.toUpperCase(),
              ),
            ),

          // Interactive 3D character component.
          if (showBadge)
            Positioned(
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadius.badge,
                ),
                child: Text(
                  characterName.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }
    return avatarWidget;
  }
}

/// Interactive 3D character component.
class _CharacterFacePainter extends CustomPainter {
  final Color color;
  final String character;

  _CharacterFacePainter({required this.color, required this.character});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final headPaint = Paint()..color = color;
    final headRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.28),
    );
    canvas.drawRRect(headRect, headPaint);

    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = const Color(0xFF2D2522);
    final glintPaint = Paint()..color = Colors.white;

    final eyeY = h * 0.38;
    final eyeR = w * 0.14;
    final leftEyeX = w * 0.30;
    final rightEyeX = w * 0.70;

    canvas.drawCircle(Offset(leftEyeX, eyeY), eyeR, eyePaint);
    canvas.drawCircle(Offset(rightEyeX, eyeY), eyeR, eyePaint);

    canvas.drawCircle(Offset(leftEyeX + 1, eyeY), eyeR * 0.65, pupilPaint);
    canvas.drawCircle(Offset(rightEyeX + 1, eyeY), eyeR * 0.65, pupilPaint);

    canvas.drawCircle(Offset(leftEyeX + 2, eyeY - 2), eyeR * 0.25, glintPaint);
    canvas.drawCircle(Offset(rightEyeX + 2, eyeY - 2), eyeR * 0.25, glintPaint);

    final mouthPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    mouthPath.moveTo(w * 0.35, h * 0.62);
    mouthPath.quadraticBezierTo(w * 0.5, h * 0.74, w * 0.65, h * 0.62);
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant _CharacterFacePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.character != character;
}
