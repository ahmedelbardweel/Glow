import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import '../../features/child/data/models/child_models.dart';

/// خدمة الاتصال والعمليات السحابية المباشرة مع Supabase
class SupabaseService {
  SupabaseService._();

  static bool _isInitialized = false;

  /// تهيئة اتصال Supabase
  static Future<void> init() async {
    if (!SupabaseConfig.isConfigured) {
      debugPrint('⚠️ Supabase credentials not set yet. Running in offline/local Hive fallback mode.');
      return;
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      _isInitialized = true;
      debugPrint('✅ Supabase initialized successfully.');
    } catch (e) {
      debugPrint('❌ Error initializing Supabase: $e');
    }
  }

  static SupabaseClient? get client => _isInitialized ? Supabase.instance.client : null;
  static bool get isReady => _isInitialized && client != null;

  // === 1. عمليات ملف الطفل والتقدم (Children & Progress) ===

  /// تسجيل أو تحديث بيانات ولي الأمر في جدول parents
  static Future<bool> upsertParent(String email) async {
    if (!isReady) return true;
    try {
      final cleanEmail = email.trim().toLowerCase();
      if (cleanEmail.isEmpty) return false;
      await client!.from('parents').upsert({
        'email': cleanEmail,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'email');
      debugPrint('✅ Upserted parent ($cleanEmail) in Supabase.');
      return true;
    } catch (e) {
      debugPrint('Error upserting parent in Supabase: $e');
      return false;
    }
  }

  /// جلب بيانات الطفل من السحابة بالكود الفريد (Child ID) أو بالاسم
  static Future<Map<String, dynamic>?> fetchRemoteChildProfile(String childCodeOrName) async {
    if (!isReady) return null;
    try {
      // 1. محاولة البحث بالكود الفريد child_code
      var response = await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .eq('child_code', childCodeOrName.trim().toUpperCase())
          .maybeSingle();

      // 2. إذا لم يوجد بالكود، نبحث بالاسم كـ Fallback
      response ??= await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .eq('name', childCodeOrName.trim())
          .maybeSingle();

      return response;
    } catch (e) {
      debugPrint('Error fetching child profile from Supabase: $e');
      return null;
    }
  }

  /// رفع وتحديث ملف الطفل في السحابة (Sync Up)
  static Future<bool> upsertRemoteChildProfile(ChildProfileModel profile) async {
    if (!isReady) return true; // وضع عدم الاتصال / Fallback
    try {
      final code = profile.childId.toUpperCase();
      final parentEmail = profile.parentEmail?.trim().toLowerCase();

      // إذا كان هناك بريد لولي الأمر، نضمن وجوده في جدول parents أولاً
      if (parentEmail != null && parentEmail.isNotEmpty) {
        await upsertParent(parentEmail);
      }

      await client!.from('children').upsert({
        'child_code': code,
        'name': profile.name,
        'age': profile.age,
        'selected_character': profile.selectedCharacter,
        'avatar_shape': profile.avatarShape,
        'current_world': profile.currentWorld,
        'stars': profile.stars,
        'points': profile.points,
        'parent_id': (parentEmail != null && parentEmail.isNotEmpty) ? parentEmail : null,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'child_code');
      debugPrint('✅ Upserted child ($code) in Supabase.');
      return true;
    } catch (e) {
      debugPrint('Error upserting child profile in Supabase: $e');
      return false;
    }
  }

  /// ربط الطفل بحساب ولي الأمر في السحابة
  static Future<Map<String, dynamic>?> linkChildToParent({
    required String childCode,
    required String parentEmail,
    String? fallbackChildName,
  }) async {
    if (!isReady) return null;
    try {
      final cleanEmail = parentEmail.trim().toLowerCase();
      final code = childCode.trim().toUpperCase();

      // 1. تسجيل ولي الأمر في جدول parents
      await upsertParent(cleanEmail);
      
      // 2. فحص ما إذا كان الطفل موجوداً في جدول children
      var child = await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .eq('child_code', code)
          .maybeSingle();

      if (child != null) {
        // تحديث بريد ولي الأمر المرتبط
        await client!.from('children').update({
          'parent_id': cleanEmail,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('child_code', code);
      } else {
        // إنشاء سجل الطفل فوراً وربطه بولي الأمر
        final newChildData = {
          'child_code': code,
          'parent_id': cleanEmail,
          'name': (fallbackChildName != null && fallbackChildName.isNotEmpty) ? fallbackChildName : 'بطل المستقبل',
          'age': 7,
          'selected_character': 'PORT',
          'avatar_shape': 'shape_1',
          'current_world': 1,
          'stars': 0,
          'points': 0,
          'updated_at': DateTime.now().toIso8601String(),
        };
        await client!.from('children').insert(newChildData);
        child = newChildData;
      }

      debugPrint('✅ Successfully linked child ($code) to parent ($cleanEmail) in Supabase.');
      return child;
    } catch (e) {
      debugPrint('Error linking child to parent in Supabase: $e');
      return null;
    }
  }

  /// جلب كافة الأطفال المرتبطين بولي الأمر
  static Future<List<Map<String, dynamic>>> fetchParentChildren(String parentEmail) async {
    if (!isReady) return [];
    try {
      final response = await client!
          .from('children')
          .select('*, completed_missions(*), earned_badges(*)')
          .eq('parent_id', parentEmail);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching parent children: $e');
      return [];
    }
  }

  /// تسجيل مهمة مكتملة في السحابة بالكود الفريد
  static Future<bool> recordRemoteCompletedMission({
    required String childName,
    String? childCode,
    required String missionId,
    required int stars,
    required int points,
    required String habitName,
  }) async {
    if (!isReady) return true;
    try {
      final code = (childCode ?? childName).toUpperCase();
      await client!.from('completed_missions').upsert({
        'child_code': code,
        'mission_id': missionId,
        'stars_earned': stars,
        'points_earned': points,
        'habit_name': habitName,
        'completed_at': DateTime.now().toIso8601String(),
      }, onConflict: 'child_code, mission_id');

      // تسجيل الشارة تلقائياً
      await client!.from('earned_badges').upsert({
        'child_code': code,
        'badge_name': 'وسام $habitName',
        'unlocked_at': DateTime.now().toIso8601String(),
      }, onConflict: 'child_code, badge_name');

      return true;
    } catch (e) {
      debugPrint('Error recording completed mission in Supabase: $e');
      return false;
    }
  }

  // === 2. عادات ولي الأمر (Parent & Habits) ===

  /// مزامنة حالة العادة في السحابة
  static Future<bool> upsertHabitStatus({
    required String childName,
    String? childCode,
    required String habitId,
    required String status,
  }) async {
    if (!isReady) return true;
    try {
      final code = (childCode ?? childName).toUpperCase();
      await client!.from('habit_progress').upsert({
        'child_code': code,
        'habit_id': habitId,
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'child_code, habit_id');
      return true;
    } catch (e) {
      debugPrint('Error updating habit status in Supabase: $e');
      return false;
    }
  }

  // === 3. المنظمة التعليمية (Organization Data) ===

  /// مزامنة بيانات المؤسسة والطلاب
  static Future<bool> upsertOrganizationData(Map<String, dynamic> orgData) async {
    if (!isReady) return true;
    try {
      await client!.from('organizations').upsert(orgData, onConflict: 'org_name');
      return true;
    } catch (e) {
      debugPrint('Error updating organization data in Supabase: $e');
      return false;
    }
  }
}
