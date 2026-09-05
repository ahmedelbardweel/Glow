import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../theme/app_colors.dart';

/// Character 3D Pose / Emotion
enum CharacterPose {
  neutral,   // Idle / Normal standing pose
  frontal,   // Talking / Narration / Dialogue / Thoughtful
  laughing,  // Laughing / Happy / Cheerful / Correct answer
  victory,   // Trophy celebration / Mission complete / Badge won
}

/// Interactive 3D character component with multi-pose support.
class Port3DModelViewer extends StatelessWidget {
  final String characterName; // PORT, MORT, FORT, QORT, LORT
  final CharacterPose pose;
  final double height;
  final double width;
  final bool autoRotate;
  final bool cameraControls;
  final String? customModelUrl;

  const Port3DModelViewer({
    super.key,
    required this.characterName,
    this.pose = CharacterPose.neutral,
    this.height = 280,
    this.width = double.infinity,
    this.autoRotate = true,
    this.cameraControls = true,
    this.customModelUrl,
  });

  /// Dynamic 3D model resolver based on Character and Pose
  String _getModelSource() {
    if (customModelUrl != null && customModelUrl!.isNotEmpty) {
      return customModelUrl!;
    }

    final charKey = characterName.trim().toLowerCase();
    final normalizedChar = (charKey == 'sort') ? 'lort' : charKey;
    final validChar = ['port', 'mort', 'fort', 'lort', 'qort'].contains(normalizedChar)
        ? normalizedChar
        : 'port';

    switch (pose) {
      case CharacterPose.frontal:
        return 'assets/models/${validChar}_frontal.glb';
      case CharacterPose.laughing:
        return 'assets/models/${validChar}_laughing.glb';
      case CharacterPose.victory:
        return 'assets/models/${validChar}_victory.glb';
      case CharacterPose.neutral:
      default:
        return 'assets/models/${validChar}_neutral.glb';
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
              // 1. Ambient theme glow
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

              // 2. Interactive 3D character component (Pure 3D GLB).
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
                relatedCss: '''
                  #default-progress-bar,
                  .progress-bar,
                  .progress-mask,
                  .default-progress-bar,
                  div[slot="progress-bar"] {
                    display: none !important;
                    visibility: hidden !important;
                    opacity: 0 !important;
                    height: 0 !important;
                    width: 0 !important;
                  }
                ''',
                innerModelViewerHtml: '<div slot="progress-bar" style="display:none !important;"></div>',
              ),

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
