import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Domain data model.
class CharacterModel {
  final String id;
  final String name; // PORT, MORT, FORT, SORT, QORT, LORT
  final String title;
  final String description;
  final Color themeColor;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.themeColor,
  });

  static const List<CharacterModel> allCharacters = [
    CharacterModel(
      id: 'port',
      name: 'PORT',
      title: 'القائد والراوي الملهم',
      description: 'البطل والشخصية الرئيسية والراوي الذي يقود تجربة الطفل ويتفاعل معه في كل خطوة.',
      themeColor: AppColors.portColor,
    ),
    CharacterModel(
      id: 'mort',
      name: 'MORT',
      title: 'العطف والاهتمام',
      description: 'ديناصور صغير لطيف ينشر المحبة والمشاعر الدافئة والاهتمام بأصدقائه.',
      themeColor: AppColors.mortColor,
    ),
    CharacterModel(
      id: 'fort',
      name: 'FORT',
      title: 'القوة والشجاعة',
      description: 'ديناصور شجاع يساعدك في مواجهة التحديات والتغلب على المخاوف بقوة وثقة.',
      themeColor: AppColors.fortColor,
    ),
    CharacterModel(
      id: 'qort',
      name: 'QORT',
      title: 'الحكمة والرأي',
      description: 'ديناصور حكيم يرشدك للتفكير الهادئ، الاستماع الجيد، وحسن اتخاذ القرار.',
      themeColor: AppColors.qortColor,
    ),
    CharacterModel(
      id: 'lort',
      name: 'LORT',
      title: 'الذكاء والتفكير',
      description: 'ديناصور عبقري يعشق الاكتشاف والترتيب وحل الألغاز بطرق ذكية ومبتكرة.',
      themeColor: AppColors.sortColor,
    ),
  ];
}

/// Domain data model.
class StorySceneModel {
  final int sceneIndex;
  final String speakerName;
  final String dialogue;
  final String sceneDescription;
  final String backgroundTheme;

  const StorySceneModel({
    required this.sceneIndex,
    required this.speakerName,
    required this.dialogue,
    required this.sceneDescription,
    required this.backgroundTheme,
  });

  Map<String, dynamic> toMap() {
    return {
      'sceneIndex': sceneIndex,
      'speakerName': speakerName,
      'dialogue': dialogue,
      'sceneDescription': sceneDescription,
      'backgroundTheme': backgroundTheme,
    };
  }

  factory StorySceneModel.fromMap(Map<dynamic, dynamic> map) {
    return StorySceneModel(
      sceneIndex: (map['sceneIndex'] as num?)?.toInt() ?? 0,
      speakerName: map['speakerName']?.toString() ?? 'PORT',
      dialogue: map['dialogue']?.toString() ?? '',
      sceneDescription: map['sceneDescription']?.toString() ?? '',
      backgroundTheme: map['backgroundTheme']?.toString() ?? 'forest_day',
    );
  }

  StorySceneModel copyWith({
    int? sceneIndex,
    String? speakerName,
    String? dialogue,
    String? sceneDescription,
    String? backgroundTheme,
  }) {
    return StorySceneModel(
      sceneIndex: sceneIndex ?? this.sceneIndex,
      speakerName: speakerName ?? this.speakerName,
      dialogue: dialogue ?? this.dialogue,
      sceneDescription: sceneDescription ?? this.sceneDescription,
      backgroundTheme: backgroundTheme ?? this.backgroundTheme,
    );
  }
}

/// Domain data model.
class QuizOptionModel {
  final String keyId; // A, B, C, D
  final String text;
  final String explanation;

  const QuizOptionModel({
    required this.keyId,
    required this.text,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      'keyId': keyId,
      'text': text,
      'explanation': explanation,
    };
  }

  factory QuizOptionModel.fromMap(Map<dynamic, dynamic> map) {
    return QuizOptionModel(
      keyId: map['keyId']?.toString() ?? 'A',
      text: map['text']?.toString() ?? '',
      explanation: map['explanation']?.toString() ?? '',
    );
  }
}

/// Domain data model.
class QuizModel {
  final String situation;
  final String question;
  final List<QuizOptionModel> options;
  final String correctKeyId;
  final String encouragementCorrect;
  final String gentleFeedbackWrong;

  const QuizModel({
    required this.situation,
    required this.question,
    required this.options,
    required this.correctKeyId,
    required this.encouragementCorrect,
    required this.gentleFeedbackWrong,
  });

  Map<String, dynamic> toMap() {
    return {
      'situation': situation,
      'question': question,
      'options': options.map((o) => o.toMap()).toList(),
      'correctKeyId': correctKeyId,
      'encouragementCorrect': encouragementCorrect,
      'gentleFeedbackWrong': gentleFeedbackWrong,
    };
  }

  factory QuizModel.fromMap(Map<dynamic, dynamic> map) {
    final rawOptions = map['options'] as List<dynamic>? ?? [];
    return QuizModel(
      situation: map['situation']?.toString() ?? '',
      question: map['question']?.toString() ?? '',
      options: rawOptions
          .map((item) => QuizOptionModel.fromMap(Map<dynamic, dynamic>.from(item as Map)))
          .toList(),
      correctKeyId: map['correctKeyId']?.toString() ?? 'A',
      encouragementCorrect: map['encouragementCorrect']?.toString() ?? 'أحسنت يا بطل!',
      gentleFeedbackWrong: map['gentleFeedbackWrong']?.toString() ?? 'محاولة جيدة، تذكر دائماً السلوك الإيجابي!',
    );
  }
}

/// Domain data model.
class MissionModel {
  final String id;
  final int number;
  final String title;
  final String habitName;
  final String habitDescription;
  final int rewardStars;
  final int rewardPoints;
  final List<StorySceneModel> storyScenes;
  final List<QuizModel> quizzes;
  final QuizModel quiz;

  MissionModel({
    required this.id,
    required this.number,
    required this.title,
    required this.habitName,
    required this.habitDescription,
    this.rewardStars = 3,
    this.rewardPoints = 150,
    required this.storyScenes,
    List<QuizModel>? quizzes,
    QuizModel? quiz,
  })  : quizzes = (quizzes != null && quizzes.isNotEmpty)
            ? quizzes
            : (quiz != null ? [quiz] : const []),
        quiz = quiz ??
            ((quizzes != null && quizzes.isNotEmpty)
                ? quizzes.first
                : const QuizModel(
                    situation: '',
                    question: '',
                    options: [],
                    correctKeyId: 'A',
                    encouragementCorrect: '',
                    gentleFeedbackWrong: '',
                  ));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'habitName': habitName,
      'habitDescription': habitDescription,
      'rewardStars': rewardStars,
      'rewardPoints': rewardPoints,
      'storyScenes': storyScenes.map((s) => s.toMap()).toList(),
      'quiz': quiz.toMap(),
      'quizzes': quizzes.map((q) => q.toMap()).toList(),
    };
  }

  factory MissionModel.fromMap(Map<dynamic, dynamic> map) {
    final rawScenes = (map['storyScenes'] ?? map['story_scenes']) as List<dynamic>? ?? [];
    final rawQuizzes = (map['quizzes'] ?? map['quiz_list']) as List<dynamic>? ?? [];

    final parsedQuizzes = rawQuizzes
        .map((item) => QuizModel.fromMap(Map<dynamic, dynamic>.from(item as Map)))
        .toList();

    QuizModel? singleQuiz;
    if (map['quiz'] != null) {
      singleQuiz = QuizModel.fromMap(Map<dynamic, dynamic>.from(map['quiz'] as Map));
    }

    return MissionModel(
      id: map['id']?.toString() ?? 'm_${DateTime.now().millisecondsSinceEpoch}',
      number: (map['number'] as num?)?.toInt() ?? 1,
      title: map['title']?.toString() ?? 'مهمة جديدة',
      habitName: map['habitName']?.toString() ?? map['habit_name']?.toString() ?? 'عادة إيجابية',
      habitDescription: map['habitDescription']?.toString() ?? map['habit_description']?.toString() ?? '',
      rewardStars: (map['rewardStars'] as num?)?.toInt() ?? (map['reward_stars'] as num?)?.toInt() ?? 3,
      rewardPoints: (map['rewardPoints'] as num?)?.toInt() ?? (map['reward_points'] as num?)?.toInt() ?? 150,
      storyScenes: rawScenes
          .map((item) => StorySceneModel.fromMap(Map<dynamic, dynamic>.from(item as Map)))
          .toList(),
      quizzes: parsedQuizzes.isNotEmpty ? parsedQuizzes : (singleQuiz != null ? [singleQuiz] : null),
      quiz: singleQuiz ?? (parsedQuizzes.isNotEmpty ? parsedQuizzes.first : null),
    );
  }

  MissionModel copyWith({
    String? id,
    int? number,
    String? title,
    String? habitName,
    String? habitDescription,
    int? rewardStars,
    int? rewardPoints,
    List<StorySceneModel>? storyScenes,
    List<QuizModel>? quizzes,
    QuizModel? quiz,
  }) {
    return MissionModel(
      id: id ?? this.id,
      number: number ?? this.number,
      title: title ?? this.title,
      habitName: habitName ?? this.habitName,
      habitDescription: habitDescription ?? this.habitDescription,
      rewardStars: rewardStars ?? this.rewardStars,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      storyScenes: storyScenes ?? this.storyScenes,
      quizzes: quizzes ?? this.quizzes,
      quiz: quiz ?? this.quiz,
    );
  }
}

/// Domain data model.
class WorldModel {
  final int worldNumber;
  final String name;
  final String description;
  final Color worldColor;
  final bool isPremium;
  final List<MissionModel> missions;

  const WorldModel({
    required this.worldNumber,
    required this.name,
    required this.description,
    required this.worldColor,
    this.isPremium = false,
    required this.missions,
  });

  Map<String, dynamic> toMap() {
    return {
      'worldNumber': worldNumber,
      'name': name,
      'description': description,
      // ignore: deprecated_member_use
      'worldColorHex': '#${worldColor.value.toRadixString(16).padLeft(8, '0')}',
      'isPremium': isPremium,
      'missions': missions.map((m) => m.toMap()).toList(),
    };
  }

  factory WorldModel.fromMap(Map<dynamic, dynamic> map) {
    final rawMissions = map['missions'] as List<dynamic>? ?? [];
    Color color = AppColors.mintGreen;
    if (map['worldColorHex'] != null) {
      try {
        final hex = map['worldColorHex'].toString().replaceAll('#', '');
        color = Color(int.parse(hex, radix: 16));
      } catch (_) {}
    } else if (map['world_color_hex'] != null) {
      try {
        final hex = map['world_color_hex'].toString().replaceAll('#', '');
        color = Color(int.parse(hex.length == 6 ? 'FF$hex' : hex, radix: 16));
      } catch (_) {}
    }

    return WorldModel(
      worldNumber: (map['worldNumber'] as num?)?.toInt() ?? (map['world_number'] as num?)?.toInt() ?? 1,
      name: map['name']?.toString() ?? 'عالم جديد',
      description: map['description']?.toString() ?? '',
      worldColor: color,
      isPremium: map['isPremium'] == true || map['is_premium'] == true,
      missions: rawMissions
          .map((item) => MissionModel.fromMap(Map<dynamic, dynamic>.from(item as Map)))
          .toList(),
    );
  }

  WorldModel copyWith({
    int? worldNumber,
    String? name,
    String? description,
    Color? worldColor,
    bool? isPremium,
    List<MissionModel>? missions,
  }) {
    return WorldModel(
      worldNumber: worldNumber ?? this.worldNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      worldColor: worldColor ?? this.worldColor,
      isPremium: isPremium ?? this.isPremium,
      missions: missions ?? this.missions,
    );
  }
}

/// Domain data model.
class ChildProfileModel {
  final String childId;
  final String name;
  final int age;
  final String avatarShape;
  final String selectedCharacter;
  final int currentWorld;
  final int stars;
  final int points;
  final List<String> completedMissions;
  final List<String> earnedBadges;
  final String? parentEmail;

  const ChildProfileModel({
    required this.childId,
    required this.name,
    required this.age,
    required this.avatarShape,
    required this.selectedCharacter,
    this.currentWorld = 1,
    this.stars = 0,
    this.points = 0,
    this.completedMissions = const [],
    this.earnedBadges = const [],
    this.parentEmail,
  });

  static String generateUniqueChildId([String prefix = 'PORT']) {
    final randomNum = math.Random().nextInt(9000) + 1000;
    return '$prefix-$randomNum';
  }

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'name': name,
      'age': age,
      'avatarShape': avatarShape,
      'selectedCharacter': selectedCharacter,
      'currentWorld': currentWorld,
      'stars': stars,
      'points': points,
      'completedMissions': completedMissions,
      'earnedBadges': earnedBadges,
      'parentEmail': parentEmail,
    };
  }

  factory ChildProfileModel.fromMap(Map<dynamic, dynamic> map) {
    return ChildProfileModel(
      childId: map['childId'] ?? map['child_code'] ?? generateUniqueChildId(),
      name: map['name'] ?? 'بطل PORT',
      age: (map['age'] as num?)?.toInt() ?? 7,
      avatarShape: map['avatarShape']?.toString() ?? 'shape_1',
      selectedCharacter: map['selectedCharacter']?.toString() ?? 'PORT',
      currentWorld: (map['currentWorld'] as num?)?.toInt() ?? (map['current_world'] as num?)?.toInt() ?? 1,
      stars: (map['stars'] as num?)?.toInt() ?? 0,
      points: (map['points'] as num?)?.toInt() ?? 0,
      completedMissions: List<String>.from(map['completedMissions'] ?? map['completed_missions'] ?? []),
      earnedBadges: List<String>.from(map['earnedBadges'] ?? map['earned_badges'] ?? []),
      parentEmail: map['parentEmail']?.toString() ?? map['parent_id']?.toString(),
    );
  }

  ChildProfileModel copyWith({
    String? childId,
    String? name,
    int? age,
    String? avatarShape,
    String? selectedCharacter,
    int? currentWorld,
    int? stars,
    int? points,
    List<String>? completedMissions,
    List<String>? earnedBadges,
    String? parentEmail,
  }) {
    return ChildProfileModel(
      childId: childId ?? this.childId,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarShape: avatarShape ?? this.avatarShape,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      currentWorld: currentWorld ?? this.currentWorld,
      stars: stars ?? this.stars,
      points: points ?? this.points,
      completedMissions: completedMissions ?? this.completedMissions,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      parentEmail: parentEmail ?? this.parentEmail,
    );
  }
}

/// Domain data model.
class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String targetRole; // all, child, parent, organization
  final bool isActive;
  final DateTime createdAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.targetRole = 'all',
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'targetRole': targetRole,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AnnouncementModel.fromMap(Map<dynamic, dynamic> map) {
    return AnnouncementModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      targetRole: map['target_role']?.toString() ?? map['targetRole']?.toString() ?? 'all',
      isActive: map['is_active'] == true || map['isActive'] == true,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : (map['createdAt'] != null
              ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
    );
  }
}

/// Key performance indicators and metrics.
class AdminStatsModel {
  final int totalChildren;
  final int totalParents;
  final int totalOrganizations;
  final int totalCompletedMissions;
  final int totalStarsGiven;
  final int totalPointsGiven;
  final int totalCustomWorlds;
  final int totalCustomMissions;
  final bool isSupabaseConnected;

  const AdminStatsModel({
    this.totalChildren = 0,
    this.totalParents = 0,
    this.totalOrganizations = 0,
    this.totalCompletedMissions = 0,
    this.totalStarsGiven = 0,
    this.totalPointsGiven = 0,
    this.totalCustomWorlds = 0,
    this.totalCustomMissions = 0,
    this.isSupabaseConnected = false,
  });
}
