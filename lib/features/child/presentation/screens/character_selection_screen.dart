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
import '../bloc/child_bloc.dart';
import 'world_map_screen.dart';

/// 4. شاشة اختيار الشخصية الرفيقة ثلاثية الأبعاد (3D Character Selection)
/// تتضمن مسرح عرض 3D حقيقي وتفاعلي 360 درجة مع مجسمات الـ GLB المحسنة
class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  String _selectedCharacter = 'PORT';
  bool _useReal3DMesh = true;

  void _onConfirm() {
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
      title: 'اختر رفيق رحلتك 3D',
      subtitle: 'المس الشاشة لتدوير المجسم 360° واستكشاف الشخصية',
      body: Column(
        children: [
          // 1. مسرح العرض ثلاثي الأبعاد التفاعلي (3D Hero Stage)
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(24),
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
                    borderRadius: BorderRadius.circular(24),
                    child: Port3DModelViewer(
                      key: ValueKey('glb_$_selectedCharacter'),
                      characterName: _selectedCharacter,
                      height: 200,
                      autoRotate: true,
                      cameraControls: true,
                    ),
                  )
                else
                  Port3DCharacter(
                    key: ValueKey('avatar_$_selectedCharacter'),
                    characterName: _selectedCharacter,
                    size: 145,
                    isAnimated: true,
                    enableInteractiveTilt: true,
                  ),

                // زر التبديل بين مجسم الـ GLB والشخصية الحية
                Positioned(
                  top: 10,
                  left: 10,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _useReal3DMesh = !_useReal3DMesh),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF3EFEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _useReal3DMesh ? Icons.view_in_ar : Icons.animation,
                            size: 14,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _useReal3DMesh ? 'مجسم 3D' : 'رسوم 3D',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. قائمة بطاقات الشخصيات الخمس
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
                      ? (isDark ? AppColors.darkSurfaceVariant : char.themeColor.withValues(alpha: 0.08))
                      : (isDark ? AppColors.darkSurface : AppColors.pureWhite),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  onTap: () => setState(() => _selectedCharacter = char.name),
                  child: Row(
                    children: [


                      // تفاصيل الشخصية والعنوان والوصف
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: char.themeColor.withValues(alpha: 0.14),
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
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // مؤشر التحديد
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? char.themeColor : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? char.themeColor
                                : (isDark ? AppColors.darkBorder : const Color(0xFFC7BEBE)),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // زر تأكيد الرفيق
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
