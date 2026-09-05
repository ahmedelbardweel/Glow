import 'package:flutter/material.dart';
import 'port_3d_model_viewer.dart';

/// Interactive 3D character component that renders the real 3D GLB model.
class Port3DCharacter extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Port3DModelViewer(
          key: ValueKey('char_3d_${characterName}_${pose.name}'),
          characterName: characterName,
          pose: pose,
          height: size,
          width: size,
          autoRotate: isAnimated,
          cameraControls: enableInteractiveTilt,
        ),
      ),
    );
  }
}
