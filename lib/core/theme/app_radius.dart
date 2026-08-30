import 'package:flutter/material.dart';

/// التحكم المركزي في الحواف ونصف القطر لكافة عناصر وشاشات التطبيق
class AppRadius {
  AppRadius._();

  // === القيم المركزية حسب نوع العنصر ===
  static const double buttonRadiusValue = 50.0; // أزرار بيضاوية دائرية بالكامل (Pill Shape)
  static const double cardRadiusValue = 40.0;   // بطاقات وحاويات ناعمة وانسيابية
  static const double inputRadiusValue = 50.0;  // حقول إدخال النصوص
  static const double badgeRadiusValue = 50.0;  // الشارات والوسوم
  static const double globalValue = 50.0;

  // === الأزرار (Buttons) ===
  static BorderRadius get button => BorderRadius.circular(buttonRadiusValue);
  static OutlinedBorder get buttonShape => RoundedRectangleBorder(borderRadius: button);

  // === البطاقات والحاويات (Cards) ===
  static BorderRadius get card => BorderRadius.circular(cardRadiusValue);
  static OutlinedBorder get cardShape => RoundedRectangleBorder(borderRadius: card);

  // === حقول الإدخال (Inputs) ===
  static BorderRadius get input => BorderRadius.circular(inputRadiusValue);

  // === الشارات والوسوم (Badges) ===
  static BorderRadius get badge => BorderRadius.circular(badgeRadiusValue);

  // === التوافق العام الافتراضي ===
  static BorderRadius get all => BorderRadius.circular(cardRadiusValue);
  static Radius get radius => const Radius.circular(cardRadiusValue);
  static OutlinedBorder get shape => RoundedRectangleBorder(borderRadius: all);
}
