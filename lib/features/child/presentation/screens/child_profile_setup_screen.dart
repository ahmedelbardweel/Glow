import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/child_bloc.dart';
import 'character_selection_screen.dart';

class ChildProfileSetupScreen extends StatefulWidget {
  const ChildProfileSetupScreen({super.key});

  @override
  State<ChildProfileSetupScreen> createState() => _ChildProfileSetupScreenState();
}

class _ChildProfileSetupScreenState extends State<ChildProfileSetupScreen> {
  final _nameController = TextEditingController(text: 'بطل المستقبل');
  int _selectedAge = 7;

  final List<int> _ages = [5, 6, 7, 8, 9, 10, 11, 12];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    context.read<ChildBloc>().add(
      UpdateChildProfileEvent(
        name: name,
        age: _selectedAge,
        avatarShape: 'shape_default',
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CharacterSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      title: 'إنشاء حساب البطل',
      subtitle: 'أخبرنا عنك قليلاً لنبدأ المغامرة',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // Input field.
            AppTextField(
              label: 'اسم البطل الصغير',
              hint: 'اكتب اسمك هنا (مثلاً: ريان، لانا)',
              controller: _nameController,
            ),

            const SizedBox(height: 24),

            Text(
              'كم عمرك يا بطل؟',
              style: AppTypography.titleSmall.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _ages.map((age) {
                final isSelected = _selectedAge == age;
                return InkWell(
                  onTap: () => setState(() => _selectedAge = age),
                  borderRadius: AppRadius.card,
                  child: Container(
                    width: 54,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.terracottaOrange
                          : (isDark ? AppColors.darkSurfaceVariant : AppColors.pureWhite),
                      borderRadius: AppRadius.card,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.terracottaOrange
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.terracottaOrange.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      '$age',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // Action button.
            AppButton(
              text: 'التالي: اختيار الشخصية',
              variant: AppButtonVariant.primary,
              height: 54,
              onPressed: _onNext,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
