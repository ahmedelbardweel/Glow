import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// أوضاع وتعبيرات الشخصية ثلاثية الأبعاد (3D Character Poses)
enum CharacterPose {
  neutral,
  happy,
  talking,
  celebrating,
  curious,
  encouraging,
}

/// عنصر عرض الشخصيات ثلاثية الأبعاد التفاعلية (Interactive 3D Character)
/// يدعم الحركة الحية (Breathing & Floating Animation) واللمس التفاعلي ثلاثي الأبعاد (3D Touch Tilt)
class Port3DCharacter extends StatefulWidget {
  final String characterName; // PORT, MORT, FORT, QORT, LORT
  final double size;
  final CharacterPose pose;
  final bool enableInteractiveTilt;
  final bool isAnimated;
  final VoidCallback? onTap;

  const Port3DCharacter({
    super.key,
    required this.characterName,
    this.size = 180,
    this.pose = CharacterPose.neutral,
    this.enableInteractiveTilt = true,
    this.isAnimated = true,
    this.onTap,
  });

  @override
  State<Port3DCharacter> createState() => _Port3DCharacterState();
}

class _Port3DCharacterState extends State<Port3DCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _tiltX = 0.0;
  double _tiltY = 0.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _getCharacterAssetPath() {
    switch (widget.characterName.toUpperCase()) {
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

  Color _getCharacterThemeColor() {
    switch (widget.characterName.toUpperCase()) {
      case 'MORT':
        return AppColors.mortColor;
      case 'FORT':
        return AppColors.fortColor;
      case 'QORT':
        return AppColors.qortColor;
      case 'LORT':
      case 'SORT':
        return AppColors.sortColor;
      case 'PORT':
      default:
        return AppColors.portColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _getCharacterAssetPath();
    final themeColor = _getCharacterThemeColor();

    return GestureDetector(
      onTap: widget.onTap,
      onPanUpdate: widget.enableInteractiveTilt
          ? (details) {
              setState(() {
                _tiltY += details.delta.dx * 0.005;
                _tiltX -= details.delta.dy * 0.005;
                _tiltX = _tiltX.clamp(-0.25, 0.25);
                _tiltY = _tiltY.clamp(-0.25, 0.25);
              });
            }
          : null,
      onPanEnd: widget.enableInteractiveTilt
          ? (_) {
              setState(() {
                _tiltX = 0.0;
                _tiltY = 0.0;
              });
            }
          : null,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final floatOffset = widget.isAnimated
              ? math.sin(_animController.value * math.pi) * 6.0
              : 0.0;
          final shadowScale = widget.isAnimated
              ? 1.0 - (_animController.value * 0.15)
              : 1.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مجسم الشخصية مع تحويل المنظور ثلاثي الأبعاد
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // عمق المنظور 3D
                  ..rotateX(_tiltX)
                  ..rotateY(_tiltY)
                  ..setTranslationRaw(0.0, -floatOffset, 0.0),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.size * 0.22),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.size * 0.22),
                    child: SizedBox(
                      width: widget.size,
                      height: widget.size,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        alignment: const Alignment(-0.6, -0.3),
                        child: SizedBox(
                          width: widget.size * 1.7,
                          height: widget.size * 1.7,
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.cover,
                            alignment: const Alignment(-0.6, -0.3),
                            errorBuilder: (_, __, ___) => Container(
                              color: themeColor.withValues(alpha: 0.2),
                              alignment: Alignment.center,
                              child: Text(
                                widget.characterName,
                                style: TextStyle(
                                  color: themeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.size * 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // ظل ثلاثي الأبعاد أسفل الشخصية يتنفس مع الحركة
              Transform.scale(
                scaleX: shadowScale,
                scaleY: shadowScale * 0.5,
                child: Container(
                  width: widget.size * 0.65,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2522).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(widget.size * 0.65, 12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
