import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../bloc/org_bloc.dart';
import 'class_details_screen.dart';
import 'org_reports_screen.dart';
import 'students_management_screen.dart';

/// 2. لوحة تحكم المنظمة (Organization Dashboard)
/// واجهة إدارية شاملة تعرض المؤشرات الحيوية وشريط لأحدث النشاطات
class OrgDashboardScreen extends StatelessWidget {
  const OrgDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<OrgBloc, OrgState>(
      builder: (context, state) {
        final org = state.org;

        return AppScaffold(
          title: org.name,
          subtitle: 'لوحة التحكم الإدارية للمؤسسة',
          showBackButton: false,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // بطاقة الإحصائيات الأربع الرئيسية
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              '${org.totalStudents}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text('إجمالي الطلاب', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppCard(
                        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              '${org.totalClasses}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mintGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text('الفصول الدراسية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppCard(
                        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              '${org.totalTeachers}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.lavenderPurple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text('المعلمين', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // معدل الإنجاز العام الفعلي المحسوب من متوسط الطلاب
                Builder(
                  builder: (context) {
                    final students = state.allStudents;
                    final totalProgress = students.fold<int>(0, (sum, s) => sum + s.progressPercent);
                    final avgProgress = students.isNotEmpty ? (totalProgress / students.length).round() : 0;

                    return AppCard(
                      backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                      padding: const EdgeInsets.all(16),
                      child: AppProgressBar(
                        value: avgProgress / 100,
                        progressColor: AppColors.sageGreen,
                        label: 'متوسط إنجاز مهام العادات على مستوى المدرسة',
                        trailingText: '$avgProgress%',
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // أقسام الإدارة
                Text(
                  'أقسام المنظمة وإدارة الطلاب',
                  style: AppTypography.titleSmall.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                // 1. إدارة الطلاب
                AppCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const StudentsManagementScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.15),
                          borderRadius: AppRadius.all,
                        ),
                        child: const Text('طلاب', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('إدارة وقوائم الطلاب', style: AppTypography.titleSmall),
                            Text('البحث السريع، استعراض تقدم كل طالب، وإضافة طلاب جدد.', style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      const Text('فتح', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 2. تفاصيل الفصول
                AppCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ClassDetailsScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen.withValues(alpha: 0.15),
                          borderRadius: AppRadius.all,
                        ),
                        child: const Text('فصول', style: TextStyle(color: AppColors.mintGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('تفاصيل الفصول والمراحل', style: AppTypography.titleSmall),
                            Text('معدل إنجاز كل فصل ومقارنة العادات المكتسبة (18/30 مثلاً).', style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      const Text('فتح', style: TextStyle(color: AppColors.mintGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 3. التقارير والتحليلات
                AppCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const OrgReportsScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lavenderPurple.withValues(alpha: 0.15),
                          borderRadius: AppRadius.all,
                        ),
                        child: const Text('تقارير', style: TextStyle(color: AppColors.lavenderPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('تحليلات وتقارير المنظمة', style: AppTypography.titleSmall),
                            Text('أكثر العادات اكتساباً، العادات الأضعف، وتصدير PDF.', style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      const Text('فتح', style: TextStyle(color: AppColors.lavenderPurple, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
