import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../child/data/models/child_models.dart';

class WorldEditorDialog extends StatefulWidget {
  final WorldModel? initialWorld;
  final int nextWorldNumber;
  final Function(WorldModel world) onSave;

  const WorldEditorDialog({
    super.key,
    this.initialWorld,
    required this.nextWorldNumber,
    required this.onSave,
  });

  @override
  State<WorldEditorDialog> createState() => _WorldEditorDialogState();
}

class _WorldEditorDialogState extends State<WorldEditorDialog> {
  late TextEditingController _numberController;
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late bool _isPremium;
  late Color _selectedColor;

  final List<Color> _availableColors = [
    AppColors.mintGreen,
    AppColors.warmGold,
    AppColors.terracottaOrange,
    AppColors.qortColor,
    AppColors.lavenderPurple,
    const Color(0xFFE57373),
    const Color(0xFF81C784),
    const Color(0xFF64B5F6),
    const Color(0xFFFFB74D),
    const Color(0xFFBA68C8),
  ];

  @override
  void initState() {
    super.initState();
    final world = widget.initialWorld;
    _numberController = TextEditingController(
      text: world != null ? world.worldNumber.toString() : widget.nextWorldNumber.toString(),
    );
    _nameController = TextEditingController(text: world?.name ?? '');
    _descController = TextEditingController(text: world?.description ?? '');
    _isPremium = world?.isPremium ?? false;
    _selectedColor = world?.worldColor ?? AppColors.mintGreen;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.initialWorld != null;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditing ? 'تعديل العالم رقم ${widget.initialWorld!.worldNumber}' : 'إضافة عالم ومرحلة جديدة',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const Divider(height: 16),
            AppTextField(
              label: 'رقم العالم والترتيب',
              hint: '1, 2, 3...',
              controller: _numberController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            AppTextField(
              label: 'اسم العالم',
              hint: 'اسم العالم أو المرحلة',
              controller: _nameController,
            ),
            const SizedBox(height: 10),
            AppTextField(
              label: 'وصف العالم والعادات المستهدفة',
              hint: 'نبذة مختصرة عن هذا العالم',
              controller: _descController,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Text(
              'لون طابع العالم:',
              style: AppTypography.titleSmall.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableColors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 2.5)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'عالم مميز (يتطلب باقة التميز)',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                ),
              ),
              subtitle: Text(
                'العوالم المجانية متاحة لجميع الأطفال مباشرة',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              value: _isPremium,
              activeThumbColor: AppColors.warmGold,
              onChanged: (val) => setState(() => _isPremium = val),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'إلغاء',
                    variant: AppButtonVariant.outlined,
                    height: 44,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    text: 'حفظ العالم',
                    variant: AppButtonVariant.primary,
                    height: 44,
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) return;
                      final num = int.tryParse(_numberController.text.trim()) ?? widget.nextWorldNumber;

                      final world = WorldModel(
                        worldNumber: num,
                        name: name,
                        description: _descController.text.trim(),
                        worldColor: _selectedColor,
                        isPremium: _isPremium,
                        missions: widget.initialWorld?.missions ?? [],
                      );

                      widget.onSave(world);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
