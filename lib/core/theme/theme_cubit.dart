import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/hive_service.dart';
import '../database/hive_keys.dart';

/// إدارة حالة السمة (Light / Dark) باستخدام BLoC (Cubit)
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_getInitialTheme());

  static ThemeMode _getInitialTheme() {
    final isDark = HiveService.getSetting<bool>(HiveKeys.isDarkModeKey, defaultValue: false);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final isCurrentlyDark = state == ThemeMode.dark;
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    HiveService.saveSetting(HiveKeys.isDarkModeKey, !isCurrentlyDark);
    emit(newMode);
  }

  void setTheme(ThemeMode mode) {
    HiveService.saveSetting(HiveKeys.isDarkModeKey, mode == ThemeMode.dark);
    emit(mode);
  }
}
