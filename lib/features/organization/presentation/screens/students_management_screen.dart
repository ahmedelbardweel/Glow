import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/org_models.dart';
import '../bloc/org_bloc.dart';

/// 3. شاشة إدارة الطلاب (Students Management)
/// قائمة بجميع طلاب المنظمة مع محرك بحث سريع وإمكانية إضافة طلاب جدد
class StudentsManagementScreen extends StatelessWidget {
  const StudentsManagementScreen({super.key});

  void _showAddStudentDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final classCtrl = TextEditingController(text: 'الصف الثاني (أ)');
    final ageCtrl = TextEditingController(text: '8');

    showDialog(
      context: context,
      builder: (ctx) {
        return AppDialog(
          title: 'إضافة طالب جديد',
          message: 'أدخل بيانات الطالب لإضافته إلى منظومة التعلم:',
          confirmText: 'إضافة الطالب',
          cancelText: 'إلغاء',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'اسم الطالب',
                hint: 'الاسم الثلاثي',
                controller: nameCtrl,
              ),
              const SizedBox(height: 10),
              AppTextField(
                label: 'الفصل الدراسي',
                hint: 'الصف الثاني (أ)',
                controller: classCtrl,
              ),
              const SizedBox(height: 10),
              AppTextField(
                label: 'العمر',
                hint: '8',
                controller: ageCtrl,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          onConfirm: () {
            final name = nameCtrl.text.trim();
            if (name.isNotEmpty) {
              final student = OrgStudentModel(
                id: 'st_${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                age: int.tryParse(ageCtrl.text.trim()) ?? 8,
                className: classCtrl.text.trim(),
                currentWorld: 'غابة البدايات',
                progressPercent: 50,
                habitsCount: 10,
              );
              context.read<OrgBloc>().add(AddStudentEvent(student));
              Navigator.of(ctx).pop();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<OrgBloc, OrgState>(
      builder: (context, state) {
        final students = state.filteredStudents;

        return AppScaffold(
          title: 'إدارة الطلاب (${students.length})',
          subtitle: 'قوائم الطلاب ونسب الإنجاز والعادات',
          actions: [
            // زر إضافة طالب
            InkWell(
              onTap: () => _showAddStudentDialog(context),
              borderRadius: AppRadius.all,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: AppRadius.all,
                ),
                child: const Text(
                  '+ إضافة طالب',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          body: Column(
            children: [
              // حقل البحث السريع
              AppTextField(
                hint: 'بحث باسم الطالب أو الفصل...',
                onChanged: (val) {
                  context.read<OrgBloc>().add(SearchStudentsEvent(val));
                },
              ),

              const SizedBox(height: 12),

              // قائمة الطلاب
              Expanded(
                child: ListView.separated(
                  itemCount: students.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final st = students[index];

                    return AppCard(
                      borderColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(alpha: 0.15),
                              borderRadius: AppRadius.all,
                            ),
                            child: Text(
                              st.name.isNotEmpty ? st.name.characters.first : 'ط',
                              style: const TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  st.name,
                                  style: AppTypography.titleSmall.copyWith(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${st.className} • ${st.currentWorld}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.mintGreen.withValues(alpha: 0.2),
                                  borderRadius: AppRadius.all,
                                ),
                                child: Text(
                                  '${st.habitsCount}/30 عادة',
                                  style: const TextStyle(
                                    color: AppColors.mintGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${st.progressPercent}% إنجاز',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
