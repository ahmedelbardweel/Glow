import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../bloc/org_bloc.dart';

/// Application feature screen.
class ClassDetailsScreen extends StatelessWidget {
  const ClassDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<OrgBloc, OrgState>(
      builder: (context, state) {
        final classes = state.classes;

        return AppScaffold(
          title: 'الفصول الدراسية والمراحل',
          subtitle: 'معدلات الإنجاز ومقارنة العادات المكتسبة',
          body: ListView.separated(
            itemCount: classes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cls = classes[index];

              return AppCard(
                borderColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
                          child: Text(
                            '${cls.studentsCount} طالب',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            cls.name,
                            style: AppTypography.titleMedium.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.15),
                            borderRadius: AppRadius.all,
                          ),
                          child: Text(
                            'متوسط: ${cls.avgHabitsCount}/30 عادة',
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cls.grade,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppProgressBar(
                      value: cls.avgProgressPercent / 100,
                      progressColor: AppColors.mintGreen,
                      label: 'معدل تقدم الفصل',
                      trailingText: '${cls.avgProgressPercent}%',
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
