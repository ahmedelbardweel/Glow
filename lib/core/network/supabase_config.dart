/// إعدادات ومفاتيح الاتصال بقاعدة بيانات Supabase السحابية لمشروع GLOW
class SupabaseConfig {
  SupabaseConfig._();

  // رابط مشروع Supabase الرسمي
  static const String supabaseUrl = 'https://lxwtpsbjayamynqieuby.supabase.co';

  // المفتاح العام (Anon Key)
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx4d3Rwc2JqYXlhbXlucWlldWJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgwMTc5OTIsImV4cCI6MjEwMzU5Mzk5Mn0.DpFX_pBUJvpxj0H7dvpSiN7S-JGhJz33h5RVKbc-Azg';

  /// فحص ما إذا كانت مفاتيح Supabase جاهزة
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      !supabaseUrl.contains('placeholder');
}
