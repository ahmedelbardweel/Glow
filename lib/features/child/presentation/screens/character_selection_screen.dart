import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_3d_character.dart';
import '../../../../core/widgets/shapes/port_3d_model_viewer.dart';
import '../../data/models/child_models.dart';
import '../../data/repositories/child_repository.dart';
import '../bloc/child_bloc.dart';
import 'world_map_screen.dart';

/// Character selection screen.
/// Interactive 3D character component.
class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  String _selectedCharacter = 'PORT';
  final bool _useReal3DMesh = true;

  void _onConfirm() {
    ChildRepository.markProfileSetupComplete();
    context.read<ChildBloc>().add(SelectCharacterEvent(_selectedCharacter));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WorldMapScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final characters = CharacterModel.allCharacters;

    return AppScaffold(
      title: 'اختر رفيق رحلتك',
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D2522).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_useReal3DMesh)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Port3DModelViewer(
                      key: ValueKey('glb_$_selectedCharacter'),
                      characterName: _selectedCharacter,
                      height: 300,
                      autoRotate: true,
                      cameraControls: true,
                    ),
                  )
                else
                  Port3DCharacter(
                    key: ValueKey('avatar_$_selectedCharacter'),
                    characterName: _selectedCharacter,
                    size: 150,
                    isAnimated: true,
                    enableInteractiveTilt: true,
                  ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: characters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final char = characters[index];
                final isSelected = _selectedCharacter == char.name;

                return AppCard(
                  borderWidth: isSelected ? 2 : 1,
                  borderColor: isSelected
                      ? char.themeColor
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  backgroundColor: isSelected
                      ? (isDark
                          ? AppColors.darkSurfaceVariant
                          : char.themeColor.withValues(alpha: 0.08))
                      : (isDark ? AppColors.darkSurface : AppColors.pureWhite),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  onTap: () => setState(() => _selectedCharacter = char.name),
                  child: Row(
                    children: [
                      // Interactive 3D character component.
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  char.name,
                                  style: AppTypography.titleMedium.copyWith(
                                    color: char.themeColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        char.themeColor.withValues(alpha: 0.14),
                                    borderRadius: AppRadius.badge,
                                  ),
                                  child: Text(
                                    char.title,
                                    style: TextStyle(
                                      color: char.themeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              char.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textMuted,
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected ? char.themeColor : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? char.themeColor
                                : (isDark
                                    ? AppColors.darkBorder
                                    : const Color(0xFFC7BEBE)),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Action button.
          AppButton(
            text: 'انطلق مع $_selectedCharacter',
            variant: AppButtonVariant.primary,
            height: 52,
            onPressed: _onConfirm,
          ),
        ],
      ),
    );
  }
}
