import 'package:flutter/material.dart';

/// لوحة الألوان الدافئة والناعمة لتطبيق PORT
/// تعتمد على ألوان هادئة ومريحة للعين (Warm Cream, Terracotta, Soft Sage Green, Warm Gold)
class AppColors {
  AppColors._();

  // === الألوان الأساسية الدافئة (Brand & Core) ===
  static const Color warmCream = Color(0xFFFAF7F2);         // خلفية التطبيق العامة البيج الهادئ
  static const Color warmCreamDark = Color(0xFFF0EBE1);     // درجة بيج أغمق قليلاً للحدود
  static const Color pureWhite = Color(0xFFFFFFFF);         // خلفية البطاقات النقية
  
  static const Color terracottaOrange = Color(0xFFE76F51);  // البرتقالي النحاسي الدافئ للأزرار الرئيسية
  static const Color terracottaOrangeDark = Color(0xFFD45D40);
  static const Color terracottaLight = Color(0xFFFDEEE9);   // تظليل خفيف للبرتقالي

  // === ألوان الطبيعة وقسم القصة (Forest & Story) ===
  static const Color sageGreen = Color(0xFF52796F);         // أخضر طبيعي هادئ للغابة والشعارات
  static const Color softMintBackground = Color(0xFFE8F2EC);// خلفية منطقة القصة (Pastel Mint / Soft Sage)
  static const Color sageGreenLight = Color(0xFFD1E5DA);

  // === ألوان الإنجاز والمكافآت (Gold & Badges) ===
  static const Color warmGold = Color(0xFFE9C46A);          // أصفر ذهبي دافئ للنجوم والمكافآت
  static const Color warmGoldDark = Color(0xFFB58414);
  static const Color warmGoldLight = Color(0xFFFDF6E2);

  // === ألوان النصوص المريحة للعين (Dark Charcoal & Muted Brown) ===
  static const Color textCharcoal = Color(0xFF2D2522);      // بني داكن / رمادي غامق جداً بدلاً من الأسود
  static const Color textMuted = Color(0xFF756A63);         // نصوص فرعية هادئة
  static const Color textLightMuted = Color(0xFFA89F98);    // نصوص إرشادية خفيفة

  // === ألوان التغذية الراجعة والتعليم اللطيف ===
  static const Color gentleSupport = Color(0xFFDDA15E);     // لون ترابي ناعم لـ "محاولة جميلة"
  static const Color gentleSupportLight = Color(0xFFF7ECE1);
  static const Color successGreen = Color(0xFF40916C);      // أخضر ناعم للإجابة الصحيحة
  static const Color successGreenLight = Color(0xFFE6F4ED);

  // === ألوان الشخصيات الـ 5 (Characters Palette) ===
  static const Color portColor = Color(0xFFE76F51); // PORT - البرتقالي النحاسي القائد
  static const Color mortColor = Color(0xFFE05780); // MORT - الوردي الشجاع
  static const Color fortColor = Color(0xFF52796F); // FORT - الأخضر الحكيم
  static const Color sortColor = Color(0xFFE9C46A); // SORT - الذهبي المبتكر
  static const Color qortColor = Color(0xFF4A90E2); // QORT - الأزرق السماوي المغامر

  // === ألوان الوضع النهاري (Light Mode) ===
  static const Color lightBackground = Color(0xFFFAF7F2);   // البيج الهادئ الفاتح
  static const Color lightSurface = Color(0xFFFFFFFF);      // الأبيض النقي للبطاقات
  static const Color lightSurfaceVariant = Color(0xFFF4EFE6);
  static const Color lightBorder = Color(0xFFE5E0DA);       // رمادي فاتح ناعم يشبه الظل لجميع الحدود
  static const Color lightTextPrimary = Color(0xFF2D2522);
  static const Color lightTextSecondary = Color(0xFF756A63);
  static const Color lightTextTertiary = Color(0xFFA89F98);

  // === ألوان الوضع الليلي (Dark Mode) ===
  static const Color darkBackground = Color(0xFF1E1B18);    // بني داكن دافئ ومريح
  static const Color darkSurface = Color(0xFF2B2623);
  static const Color darkSurfaceVariant = Color(0xFF3B3530);
  static const Color darkBorder = Color(0xFF423B36);        // حدود ليلية ناعمة
  static const Color darkTextPrimary = Color(0xFFF7F4EE);
  static const Color darkTextSecondary = Color(0xFFD5CDC5);
  static const Color darkTextTertiary = Color(0xFFA89F98);

  // توافق مع الأسماء السابقة
  static const Color primaryBlue = Color(0xFFE76F51);       // الزر الأساسي الآن برتقالي نحاسي
  static const Color primaryBlueLight = Color(0xFFFDEEE9);
  static const Color coralOrange = Color(0xFFE76F51);
  static const Color sunnyYellow = Color(0xFFE9C46A);
  static const Color mintGreen = Color(0xFF52796F);
  static const Color lavenderPurple = Color(0xFF8B5CF6);
  static const Color error = Color(0xFFD9534F);
  static const Color warning = Color(0xFFE9C46A);
  static const Color success = Color(0xFF40916C);
}
