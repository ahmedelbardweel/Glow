import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// نموذج شخصية الرفيق في الرحلة
class CharacterModel {
  final String id;
  final String name; // PORT, MORT, FORT, SORT, QORT
  final String title; // القائد، الشجاع، الحكيم، المبتكر، المغامر
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

/// نموذج مشهد القصة
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
}

/// نموذج خيار السؤال
class QuizOptionModel {
  final String keyId; // A, B, C, D
  final String text;
  final String explanation;

  const QuizOptionModel({
    required this.keyId,
    required this.text,
    required this.explanation,
  });
}

/// نموذج سؤال المهمة
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
}

/// نموذج المهمة التعليمية
class MissionModel {
  final String id;
  final int number;
  final String title;
  final String habitName;
  final String habitDescription;
  final int rewardStars;
  final int rewardPoints;
  final List<StorySceneModel> storyScenes;
  final QuizModel quiz;

  const MissionModel({
    required this.id,
    required this.number,
    required this.title,
    required this.habitName,
    required this.habitDescription,
    this.rewardStars = 3,
    this.rewardPoints = 150,
    required this.storyScenes,
    required this.quiz,
  });
}

/// نموذج العالم
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
}

/// نموذج بيانات الطفل
class ChildProfileModel {
  final String childId; // كود الطفل الفريد التلقائي (مثل: PORT-7842)
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
      age: map['age'] ?? 7,
      avatarShape: map['avatarShape'] ?? 'shape_1',
      selectedCharacter: map['selectedCharacter'] ?? 'PORT',
      currentWorld: map['currentWorld'] ?? 1,
      stars: map['stars'] ?? 0,
      points: map['points'] ?? 0,
      completedMissions: List<String>.from(map['completedMissions'] ?? []),
      earnedBadges: List<String>.from(map['earnedBadges'] ?? []),
      parentEmail: map['parentEmail'] ?? map['parent_id'],
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
