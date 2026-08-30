import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../theme/app_colors.dart';

/// عارض مجسمات 3D التفاعلي الحقيقي (Real 3D GLB Model Viewer)
/// يعرض مجسم الشخصية 3D الحقيقي مع إمكانية التدوير 360 درجة، التكبير، والإضاءة الحية
class Port3DModelViewer extends StatelessWidget {
  final String characterName; // PORT, MORT, FORT, QORT, LORT
  final double height;
  final double width;
  final bool autoRotate;
  final bool cameraControls;
  final String? customModelUrl;

  const Port3DModelViewer({
    super.key,
    required this.characterName,
    this.height = 280,
    this.width = double.infinity,
    this.autoRotate = true,
    this.cameraControls = true,
    this.customModelUrl,
  });

  /// رابط المجسم ثلاثي الأبعاد GLB لكل شخصية
  /// يدعم التحميل من assets أو من رابط CDN سحابي مباشر
  String _getModelSource() {
    if (customModelUrl != null && customModelUrl!.isNotEmpty) {
      return customModelUrl!;
    }

    // مجسمات 3D محلية فائقة السرعة مخزنة في assets/models/
    switch (characterName.toUpperCase()) {
      case 'MORT':
        return 'assets/models/copilot_3d.glb';
      case 'FORT':
        return 'assets/models/copilot_3d.glb';
      case 'QORT':
        return 'assets/models/copilot_3d.glb';
      case 'LORT':
      case 'SORT':
        return 'assets/models/copilot_3d.glb';
      case 'PORT':
      default:
        return 'assets/models/copilot_3d.glb';
    }
  }

  Color _getThemeColor() {
    switch (characterName.toUpperCase()) {
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
    final modelSrc = _getModelSource();
    final themeColor = _getThemeColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = height.isFinite
            ? height
            : (constraints.hasBoundedHeight ? constraints.maxHeight : 240.0);
        final glowSize = availableHeight * 0.75;

        return SizedBox(
          height: height.isFinite ? height : null,
          width: width.isFinite ? width : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // خلفية متوهجة ناعمة تبرز المجسم ثلاثي الأبعاد
              Container(
                height: glowSize,
                width: glowSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      themeColor.withValues(alpha: isDark ? 0.25 : 0.15),
                      Colors.transparent,
                    ],
                    radius: 0.6,
                  ),
                ),
              ),

              // عارض المجسم 3D الحقيقي التفاعلي
              ModelViewer(
                src: modelSrc,
                alt: 'مجسم 3D لشخصية $characterName',
                autoRotate: autoRotate,
                autoRotateDelay: 1000,
                rotationPerSecond: '20deg',
                cameraControls: cameraControls,
                shadowIntensity: 1.0,
                shadowSoftness: 1.0,
                backgroundColor: Colors.transparent,
                interactionPrompt: InteractionPrompt.none,
                loading: Loading.eager,
              ),

              // شارة إرشادية صغيرة للأطفال بأن المجسم تفاعلي 360°
              if (cameraControls)
                Positioned(
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2522).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'اسحب لتدوير المجسم 360°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
