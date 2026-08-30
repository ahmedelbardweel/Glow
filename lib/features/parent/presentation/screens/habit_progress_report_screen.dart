import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/cloud_sync_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/models/parent_models.dart';
import '../bloc/parent_bloc.dart';

/// 3. شاشة العادات والتقرير (Habit Progress & Child Report)
/// تتبع 30 عادة أساسية وحالتها، مع استعراض نقاط القوة واقتراحات الدعم الموجهة لولي الأمر
class HabitProgressReportScreen extends StatefulWidget {
  const HabitProgressReportScreen({super.key});

  @override
  State<HabitProgressReportScreen> createState() => _HabitProgressReportScreenState();
}

class _HabitProgressReportScreenState extends State<HabitProgressReportScreen> {
  String _selectedFilter = 'الكل'; // الكل، مكتسبة، قيد التعلم، مقفلة

  void _showHabitDetails(HabitModel habit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: AppRadius.shape,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: AppRadius.all,
                    ),
                    child: Text(
                      'العادة #${habit.number}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      habit.title,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // بطاقة نقاط القوة
              AppCard(
                backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.mintGreen.withValues(alpha: 0.1),
                borderColor: AppColors.mintGreen,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نقاط القوة والملاحظات:',
                      style: TextStyle(
                        color: AppColors.mintGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.strengthReport,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // بطاقة الدعم الأسري
              AppCard(
                backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.coralOrange.withValues(alpha: 0.1),
                borderColor: AppColors.coralOrange,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اقتراح الدعم الأسري في الواقع:',
                      style: TextStyle(
                        color: AppColors.coralOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.parentSupportSuggestion,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ParentBloc, ParentState>(
      builder: (context, state) {
        final habits = state.habits.where((h) {
          if (_selectedFilter == 'مكتسبة') return h.status == HabitStatus.learned;
          if (_selectedFilter == 'قيد التعلم') return h.status == HabitStatus.inProgress;
          if (_selectedFilter == 'مقفلة') return h.status == HabitStatus.locked;
          return true;
        }).toList();

        return AppScaffold(
          title: 'مصفوفة العادات الـ 30',
          subtitle: 'تتبع تقدم عادات الطفل وتقارير الدعم',
          actions: [
            InkWell(
              onTap: () async {
                final pdf = await CloudSyncService.generatePdfReportCloud(
                  title: 'تقرير تطور العادات للطفل ${state.childName}',
                  organizationName: 'أسرة البطل',
                  totalStudents: 1,
                  completionRate: state.progressPercent,
                );
                if (!context.mounted) return;
                AppDialog.show(
                  context,
                  title: 'تصدير تقرير الأسرة السحابي (PDF)',
                  message: 'تم استخراج التقرير السحابي بنجاح:\n$pdf\n\nيحتوي على تحليل نقاط القوة وتوصيات الدعم المنزلي المخصصة للطفل.',
                  confirmText: 'تحميل التقرير',
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceVariant : AppColors.warmCream,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1.0,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تصدير PDF',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.sageGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: Column(
            children: [
              // شرائح التصفية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['الكل', 'مكتسبة', 'قيد التعلم', 'مقفلة'].map((filter) {
                  return AppChip(
                    label: filter,
                    isSelected: _selectedFilter == filter,
                    onTap: () => setState(() => _selectedFilter = filter),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // قائمة العادات الـ 30
              Expanded(
                child: ListView.separated(
                  itemCount: habits.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final habit = habits[index];

                    return AppCard(
                      borderColor: habit.status == HabitStatus.learned
                          ? AppColors.mintGreen
                          : (habit.status == HabitStatus.inProgress
                              ? AppColors.sunnyYellow
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      onTap: () => _showHabitDetails(habit),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: habit.status == HabitStatus.learned
                                  ? AppColors.mintGreen
                                  : (habit.status == HabitStatus.inProgress
                                      ? AppColors.sunnyYellow
                                      : Colors.grey),
                              borderRadius: AppRadius.all,
                            ),
                            child: Text(
                              '${habit.number}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  habit.title,
                                  style: AppTypography.titleSmall.copyWith(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'تصنيف: ${habit.category}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (habit.status == HabitStatus.learned)
                            AppBadge.completed(text: 'مكتسبة')
                          else if (habit.status == HabitStatus.inProgress)
                            AppBadge.inProgress(text: 'قيد التعلم')
                          else
                            AppBadge.locked(text: 'مقفل'),
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
