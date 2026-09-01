import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../child/data/models/child_models.dart';

class AnnouncementDialog extends StatefulWidget {
  final Function(AnnouncementModel announcement) onPublish;

  const AnnouncementDialog({super.key, required this.onPublish});

  @override
  State<AnnouncementDialog> createState() => _AnnouncementDialogState();
}

class _AnnouncementDialogState extends State<AnnouncementDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _targetRole = 'all';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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
            Text(
              'نشر إعلان وتوجيه عام',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const Divider(height: 16),
            AppTextField(
              label: 'عنوان الإعلان',
              hint: 'عنوان الإعلان أو التوجيه',
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            AppTextField(
              label: 'نص الرسالة والتوجيه',
              hint: 'اكتب نص الإعلان هنا',
              controller: _contentController,
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            Text(
              'الفئة المستهدفة:',
              style: AppTypography.titleSmall.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _targetRole,
              dropdownColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('الجميع (أطفال، أولياء أمور، منظمات)')),
                DropdownMenuItem(value: 'child', child: Text('الأطفال فقط')),
                DropdownMenuItem(value: 'parent', child: Text('أولياء الأمور فقط')),
                DropdownMenuItem(value: 'organization', child: Text('المنظمات والمدارس فقط')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _targetRole = val);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
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
                    text: 'نشر الآن',
                    variant: AppButtonVariant.primary,
                    height: 44,
                    onPressed: () {
                      final title = _titleController.text.trim();
                      final content = _contentController.text.trim();
                      if (title.isEmpty || content.isEmpty) return;

                      final announcement = AnnouncementModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: title,
                        content: content,
                        targetRole: _targetRole,
                        createdAt: DateTime.now(),
                      );

                      widget.onPublish(announcement);
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
