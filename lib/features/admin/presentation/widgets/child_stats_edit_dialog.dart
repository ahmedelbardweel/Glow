import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../child/data/models/child_models.dart';

class ChildStatsEditDialog extends StatefulWidget {
  final ChildProfileModel child;
  final Function(int stars, int points, int currentWorld) onSave;

  const ChildStatsEditDialog({
    super.key,
    required this.child,
    required this.onSave,
  });

  @override
  State<ChildStatsEditDialog> createState() => _ChildStatsEditDialogState();
}

class _ChildStatsEditDialogState extends State<ChildStatsEditDialog> {
  late TextEditingController _starsController;
  late TextEditingController _pointsController;
  late TextEditingController _worldController;

  @override
  void initState() {
    super.initState();
    _starsController = TextEditingController(text: widget.child.stars.toString());
    _pointsController = TextEditingController(text: widget.child.points.toString());
    _worldController = TextEditingController(text: widget.child.currentWorld.toString());
  }

  @override
  void dispose() {
    _starsController.dispose();
    _pointsController.dispose();
    _worldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تعديل تقدم: ${widget.child.name}',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'الكود: ${widget.child.childId}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.terracottaOrange,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            AppTextField(
              label: 'رصيد النجوم',
              controller: _starsController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            AppTextField(
              label: 'رصيد النقاط',
              controller: _pointsController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            AppTextField(
              label: 'العالم الحالي (المرحلة)',
              controller: _worldController,
              keyboardType: TextInputType.number,
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
                    text: 'حفظ التعديل',
                    variant: AppButtonVariant.primary,
                    height: 44,
                    onPressed: () {
                      final stars = int.tryParse(_starsController.text.trim()) ?? widget.child.stars;
                      final points = int.tryParse(_pointsController.text.trim()) ?? widget.child.points;
                      final world = int.tryParse(_worldController.text.trim()) ?? widget.child.currentWorld;

                      widget.onSave(stars, points, world);
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
