import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/database/hive_keys.dart';
import '../../../../core/network/supabase_service.dart';
import '../../data/models/parent_models.dart';

// === Events ===
abstract class ParentEvent extends Equatable {
  const ParentEvent();
  @override
  List<Object?> get props => [];
}

class LoadParentDashboardEvent extends ParentEvent {}

class UpdateParentAuthEvent extends ParentEvent {
  final String email;
  final String childId;
  final String childName;
  final int childAge;
  const UpdateParentAuthEvent({
    required this.email,
    required this.childId,
    required this.childName,
    required this.childAge,
  });
  @override
  List<Object?> get props => [email, childId, childName, childAge];
}

class LinkChildWithIdEvent extends ParentEvent {
  final String email;
  final String childId;
  const LinkChildWithIdEvent({
    required this.email,
    required this.childId,
  });
  @override
  List<Object?> get props => [email, childId];
}

class SubscribePlanEvent extends ParentEvent {
  final String planName;
  const SubscribePlanEvent(this.planName);
  @override
  List<Object?> get props => [planName];
}

class UpdateHabitStatusEvent extends ParentEvent {
  final String habitId;
  final HabitStatus status;
  const UpdateHabitStatusEvent(this.habitId, this.status);
  @override
  List<Object?> get props => [habitId, status];
}

// === State ===
class ParentState extends Equatable {
  final String parentEmail;
  final String childId;
  final String childName;
  final int childAge;
  final String selectedCharacter;
  final String currentWorldName;
  final int progressPercent;
  final int totalStars;
  final int totalPoints;
  final int completedMissionsCount;
  final int badgesCount;
  final List<HabitModel> habits;
  final List<HomeActivityModel> homeActivities;
  final bool isSubscribed;
  final String subscriptionPlan;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const ParentState({
    this.parentEmail = 'parent@portapp.com',
    this.childId = 'PORT-1001',
    this.childName = 'البطل الصغير',
    this.childAge = 7,
    this.selectedCharacter = 'PORT',
    this.currentWorldName = 'غابة البدايات (العالم 1)',
    this.progressPercent = 0,
    this.totalStars = 0,
    this.totalPoints = 0,
    this.completedMissionsCount = 0,
    this.badgesCount = 0,
    required this.habits,
    required this.homeActivities,
    this.isSubscribed = false,
    this.subscriptionPlan = 'الباقة المجانية',
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  int get learnedCount => habits.where((h) => h.status == HabitStatus.learned).length;
  int get inProgressCount => habits.where((h) => h.status == HabitStatus.inProgress).length;
  int get lockedCount => habits.where((h) => h.status == HabitStatus.locked).length;

  ParentState copyWith({
    String? parentEmail,
    String? childId,
    String? childName,
    int? childAge,
    String? selectedCharacter,
    String? currentWorldName,
    int? progressPercent,
    int? totalStars,
    int? totalPoints,
    int? completedMissionsCount,
    int? badgesCount,
    List<HabitModel>? habits,
    List<HomeActivityModel>? homeActivities,
    bool? isSubscribed,
    String? subscriptionPlan,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ParentState(
      parentEmail: parentEmail ?? this.parentEmail,
      childId: childId ?? this.childId,
      childName: childName ?? this.childName,
      childAge: childAge ?? this.childAge,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      currentWorldName: currentWorldName ?? this.currentWorldName,
      progressPercent: progressPercent ?? this.progressPercent,
      totalStars: totalStars ?? this.totalStars,
      totalPoints: totalPoints ?? this.totalPoints,
      completedMissionsCount: completedMissionsCount ?? this.completedMissionsCount,
      badgesCount: badgesCount ?? this.badgesCount,
      habits: habits ?? this.habits,
      homeActivities: homeActivities ?? this.homeActivities,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        parentEmail,
        childId,
        childName,
        childAge,
        selectedCharacter,
        currentWorldName,
        progressPercent,
        totalStars,
        totalPoints,
        completedMissionsCount,
        badgesCount,
        habits,
        homeActivities,
        isSubscribed,
        subscriptionPlan,
        isLoading,
        errorMessage,
        successMessage,
      ];
}

// === BLoC ===
class ParentBloc extends Bloc<ParentEvent, ParentState> {
  ParentBloc()
      : super(ParentState(
          habits: _loadInitialHabits(),
          homeActivities: ParentRepositoryData.getHomeActivities(),
        )) {
    on<LoadParentDashboardEvent>((event, emit) async {
      final email = HiveService.getSetting<String>(HiveKeys.parentEmailKey, defaultValue: 'parent@portapp.com');
      final linkedId = HiveService.getSetting<String>(HiveKeys.linkedChildIdKey, defaultValue: '');
      final isSubscribed = HiveService.getSetting<bool>(HiveKeys.isSubscribedKey, defaultValue: false);
      final plan = HiveService.getSetting<String>(HiveKeys.subscriptionPlanKey, defaultValue: 'الباقة المجانية');
      final updatedHabits = _loadInitialHabits();

      // جلب بيانات الطفل المسجلة محلياً في Hive
      final childRaw = HiveService.getChildData<Map>(HiveKeys.childProfileKey);
      String realChildId = linkedId.isNotEmpty ? linkedId : (childRaw?['childId']?.toString() ?? 'PORT-1001');
      String realChildName = childRaw?['name']?.toString() ?? state.childName;
      int realChildAge = (childRaw?['age'] as num?)?.toInt() ?? state.childAge;
      String realCharacter = childRaw?['selectedCharacter']?.toString() ?? 'PORT';
      int stars = (childRaw?['stars'] as num?)?.toInt() ?? 0;
      int points = (childRaw?['points'] as num?)?.toInt() ?? 0;
      int world = (childRaw?['currentWorld'] as num?)?.toInt() ?? 1;
      List<String> completedMissions = List<String>.from(childRaw?['completedMissions'] ?? []);
      List<String> badges = List<String>.from(childRaw?['earnedBadges'] ?? []);

      // إذا كان متصلاً بسحابة Supabase، نحاول جلب أحدث تحديث للطفل
      if (SupabaseService.isReady && realChildId.isNotEmpty) {
        final remoteData = await SupabaseService.fetchRemoteChildProfile(realChildId);
        if (remoteData != null) {
          realChildName = remoteData['name']?.toString() ?? realChildName;
          realChildAge = (remoteData['age'] as num?)?.toInt() ?? realChildAge;
          realCharacter = remoteData['selected_character']?.toString() ?? realCharacter;
          stars = (remoteData['stars'] as num?)?.toInt() ?? stars;
          points = (remoteData['points'] as num?)?.toInt() ?? points;
          world = (remoteData['current_world'] as num?)?.toInt() ?? world;
          final remoteMissions = (remoteData['completed_missions'] as List<dynamic>?)
                  ?.map((m) => m['mission_id']?.toString() ?? '')
                  .where((id) => id.isNotEmpty)
                  .toList() ??
              [];
          final remoteBadges = (remoteData['earned_badges'] as List<dynamic>?)
                  ?.map((b) => b['badge_name']?.toString() ?? '')
                  .where((b) => b.isNotEmpty)
                  .toList() ??
              [];
          completedMissions = {...completedMissions, ...remoteMissions}.toList();
          badges = {...badges, ...remoteBadges}.toList();
        }
      }

      final learned = updatedHabits.where((h) => h.status == HabitStatus.learned).length;
      final realPercent = updatedHabits.isNotEmpty ? ((learned / updatedHabits.length) * 100).round() : 0;

      emit(state.copyWith(
        parentEmail: email,
        childId: realChildId,
        childName: realChildName,
        childAge: realChildAge,
        selectedCharacter: realCharacter,
        currentWorldName: 'العالم $world (مغامرات $realCharacter)',
        totalStars: stars,
        totalPoints: points,
        completedMissionsCount: completedMissions.length,
        badgesCount: badges.length,
        isSubscribed: isSubscribed,
        subscriptionPlan: plan,
        habits: updatedHabits,
        progressPercent: realPercent,
      ));
    });

    on<LinkChildWithIdEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final childCode = event.childId.trim().toUpperCase();
      await HiveService.saveSetting(HiveKeys.parentEmailKey, event.email);
      await HiveService.saveSetting(HiveKeys.linkedChildIdKey, childCode);

      final localChild = HiveService.getChildData<Map>(HiveKeys.childProfileKey);

      // محاولة الربط والتسجيل عبر Supabase
      Map<String, dynamic>? remoteChild;
      if (SupabaseService.isReady) {
        remoteChild = await SupabaseService.linkChildToParent(
          childCode: childCode,
          parentEmail: event.email,
          fallbackChildName: localChild?['name']?.toString(),
        );
      }

      // إذا لم يتوفر اتصال أو لم يتم العثور عليه سحابياً، نفحص محلياً في Hive
      final isLocalMatch = localChild != null &&
          (localChild['childId']?.toString().toUpperCase() == childCode ||
              localChild['name']?.toString().toLowerCase() == childCode.toLowerCase());

      String childName = 'بطل PORT';
      int childAge = 7;
      String character = 'PORT';
      int stars = 0;
      int points = 0;

      if (remoteChild != null) {
        childName = remoteChild['name']?.toString() ?? childName;
        childAge = (remoteChild['age'] as num?)?.toInt() ?? childAge;
        character = remoteChild['selected_character']?.toString() ?? character;
        stars = (remoteChild['stars'] as num?)?.toInt() ?? stars;
        points = (remoteChild['points'] as num?)?.toInt() ?? points;
      } else if (isLocalMatch) {
        childName = localChild['name']?.toString() ?? childName;
        childAge = (localChild['age'] as num?)?.toInt() ?? childAge;
        character = localChild['selectedCharacter']?.toString() ?? character;
        stars = (localChild['stars'] as num?)?.toInt() ?? stars;
        points = (localChild['points'] as num?)?.toInt() ?? points;
      }

      emit(state.copyWith(
        isLoading: false,
        parentEmail: event.email,
        childId: childCode,
        childName: childName,
        childAge: childAge,
        selectedCharacter: character,
        totalStars: stars,
        totalPoints: points,
        successMessage: 'تم ربط البطل ($childName) بحسابك بنجاح!',
      ));
    });

    on<UpdateParentAuthEvent>((event, emit) async {
      await HiveService.saveSetting(HiveKeys.parentEmailKey, event.email);
      await HiveService.saveSetting(HiveKeys.linkedChildIdKey, event.childId);
      if (SupabaseService.isReady) {
        await SupabaseService.upsertParent(event.email);
        await SupabaseService.linkChildToParent(
          childCode: event.childId,
          parentEmail: event.email,
          fallbackChildName: event.childName,
        );
      }
      emit(state.copyWith(
        parentEmail: event.email,
        childId: event.childId,
        childName: event.childName,
        childAge: event.childAge,
        successMessage: 'تم تحديث بيانات ولي الأمر بنجاح!',
      ));
    });

    on<SubscribePlanEvent>((event, emit) async {
      await HiveService.saveSetting(HiveKeys.isSubscribedKey, true);
      await HiveService.saveSetting(HiveKeys.subscriptionPlanKey, event.planName);
      emit(state.copyWith(
        isSubscribed: true,
        subscriptionPlan: event.planName,
      ));
    });

    on<UpdateHabitStatusEvent>((event, emit) async {
      await HiveService.saveHabitStatus(event.habitId, event.status.name);
      final updatedList = state.habits.map((h) {
        if (h.id == event.habitId) {
          return h.copyWith(status: event.status);
        }
        return h;
      }).toList();

      final learned = updatedList.where((h) => h.status == HabitStatus.learned).length;
      final percent = ((learned / updatedList.length) * 100).round();

      // مزامنة حالة العادة في السحابة
      if (SupabaseService.isReady) {
        await SupabaseService.upsertHabitStatus(
          childName: state.childName,
          childCode: state.childId,
          habitId: event.habitId,
          status: event.status.name,
        );
      }

      emit(state.copyWith(
        habits: updatedList,
        progressPercent: percent,
      ));
    });
  }

  static List<HabitModel> _loadInitialHabits() {
    final base = ParentRepositoryData.generate30Habits();
    final savedStatuses = HiveService.getAllHabits();

    if (savedStatuses.isEmpty) {
      return base;
    }

    return base.map((h) {
      if (savedStatuses.containsKey(h.id)) {
        final savedStr = savedStatuses[h.id].toString();
        final match = HabitStatus.values.where((v) => v.name == savedStr);
        if (match.isNotEmpty) {
          return h.copyWith(status: match.first);
        }
      }
      return h;
    }).toList();
  }
}
