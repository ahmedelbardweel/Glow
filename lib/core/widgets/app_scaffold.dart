import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow/core/theme/app_radius.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/theme_cubit.dart';

/// هيكل الشاشة الموحد لكافة شاشات التطبيق (Unified App Scaffold & Top AppBar)
/// يدمج شريط الحالة (Status Bar) مع شريط العنوان الموحد بدون أي تباعد زائد أو تكرار للحواف
class AppScaffold extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget body;
  final Widget? customHeader;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool showThemeToggle;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    this.title,
    this.subtitle,
    required this.body,
    this.customHeader,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.showBackButton = true,
    this.showThemeToggle = true,
    this.onBack,
    this.actions,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.of(context).canPop();
    final topBarColor = isDark ? AppColors.darkSurface : AppColors.pureWhite;
    final topPadding = MediaQuery.paddingOf(context).top;
    final hasStandardHeader = (title != null || showBackButton || showThemeToggle || actions != null) && customHeader == null;

    final systemOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Scaffold(
        backgroundColor: backgroundColor ?? (isDark ? AppColors.darkBackground : AppColors.warmCream),
        body: Column(
          children: [
            // 1. ترويسة مخصصة بالكامل (Custom Header)
            if (customHeader != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: topPadding + 6,
                  bottom: 10,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: topBarColor,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1.0,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2D2522).withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: customHeader,
              )
            // 2. شريط العنوان القياسي الموحد (Standard Header)
            else if (hasStandardHeader)
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: topPadding + 6,
                  bottom: 8,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: topBarColor,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1.0,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2D2522).withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // زر الرجوع الموحد
                    if (showBackButton && canPop)
                      InkWell(
                        onTap: onBack ?? () => Navigator.of(context).maybePop(),
                        borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceVariant : AppColors.warmCream,
                            borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            'رجوع',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 4),

                    const SizedBox(width: 12),

                    // عنوان ووصف الشاشة
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.titleMedium.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          if (subtitle != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (actions != null) ...actions!,

                    // زر تبديل الثيم الموحد (نهاري / ليلي)
                    if (showThemeToggle) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => context.read<ThemeCubit>().toggleTheme(),
                        borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceVariant : AppColors.warmCream,
                            borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            isDark ? 'نهاري' : 'ليلي',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.sunnyYellow : AppColors.textCharcoal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else
              SizedBox(height: topPadding),

            // محتوى الشاشة الأساسي
            Expanded(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(10.0),
                  child: body,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
