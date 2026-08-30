import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/cloud_sync_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../bloc/org_bloc.dart';

/// 5. تقارير المنظمة (Organization Reports)
/// تحليلات شاملة لأكثر العادات اكتساباً والعادات الأضعف مع إمكانية تحميل تقارير PDF
class OrgReportsScreen extends StatefulWidget {
  const OrgReportsScreen({super.key});

  @override
  State<OrgReportsScreen> createState() => _OrgReportsScreenState();
}

class _OrgReportsScreenState extends State<OrgReportsScreen> {
  String _selectedPeriod = 'شهري'; // أسبوعي، شهري، سنوي

  void _onDownloadPdf() async {
    final fileName = await CloudSyncService.generatePdfReportCloud(
      title: 'تقرير $_selectedPeriod الشامل لمنصة GLOW',
      organizationName: 'المؤسسة التعليمية',
      totalStudents: 150,
      completionRate: 85,
    );
    if (!mounted) return;

    AppDialog.show(
      context,
      title: 'تصدير تقرير المنظمة السحابي (PDF)',
      message: 'تم تجهيز الملف السحابي بنجاح:\n$fileName\n\nيتضمن الإحصائيات الكاملة، رسوم بيانية، وتوصيات الذكاء الاصطناعي للكادر التعليمي.',
      confirmText: 'تحميل ومشاركة الملف',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<OrgBloc, OrgState>(
      builder: (context, state) {
        return AppScaffold(
          title: 'تقارير وتحليلات المؤسسة',
          subtitle: 'مؤشرات العادات الأكثر والأقل اكتساباً',
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // فترة التقرير
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['أسبوعي', 'شهري', 'سنوي'].map((period) {
                    return AppChip(
                      label: 'تقرير $period',
                      isSelected: _selectedPeriod == period,
                      selectedColor: AppColors.lavenderPurple,
                      onTap: () => setState(() => _selectedPeriod = period),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // قسم العادات الأكثر اكتساباً (نقاط القوة بالمدرسة)
                AppCard(
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.mintGreen.withValues(alpha: 0.08),
                  borderColor: AppColors.mintGreen,
                  borderWidth: 1.5,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen,
                              borderRadius: AppRadius.all,
                            ),
                            child: const Text(
                              'نقاط القوة',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'أكثر العادات اكتساباً بالمدرسة',
                            style: AppTypography.titleSmall.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildHabitMetricRow('1. الثقة بالنفس والتعبير', '94% من الطلاب', AppColors.mintGreen, isDark),
                      const SizedBox(height: 8),
                      _buildHabitMetricRow('2. التعاون وروح الفريق', '89% من الطلاب', AppColors.mintGreen, isDark),
                      const SizedBox(height: 8),
                      _buildHabitMetricRow('3. الصدق والشجاعة الأدبية', '86% من الطلاب', AppColors.mintGreen, isDark),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // قسم العادات الأضعف (تحتاج دعم وتوجيه المعلمين)
                AppCard(
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.coralOrange.withValues(alpha: 0.08),
                  borderColor: AppColors.coralOrange,
                  borderWidth: 1.5,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.coralOrange,
                              borderRadius: AppRadius.all,
                            ),
                            child: const Text(
                              'مجالات التطوير',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'العادات التي تحتاج تركيزاً أكبر',
                            style: AppTypography.titleSmall.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildHabitMetricRow('1. النوم المبكر وتنظيم الشاشات', '42% فقط أتموها', AppColors.coralOrange, isDark),
                      const SizedBox(height: 8),
                      _buildHabitMetricRow('2. الصبر عند الانتظار', '48% فقط أتموها', AppColors.coralOrange, isDark),
                      const SizedBox(height: 8),
                      _buildHabitMetricRow('3. إدارة الغضب بهدوء', '51% فقط أتموها', AppColors.coralOrange, isDark),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // زر تحميل تقرير PDF
                AppButton(
                  text: 'تحميل تقرير $_selectedPeriod بصيغة PDF',
                  customColor: AppColors.lavenderPurple,
                  height: 54,
                  onPressed: _onDownloadPdf,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHabitMetricRow(String title, String stat, Color color, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: AppRadius.all,
          ),
          child: Text(
            stat,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
