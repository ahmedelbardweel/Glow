/// Domain data model.
class OrgModel {
  final String name;
  final String type;
  final int totalStudents;
  final int totalTeachers;
  final int totalClasses;
  final String country;
  final String city;
  final String managerName;
  final String managerEmail;

  const OrgModel({
    required this.name,
    required this.type,
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalClasses,
    required this.country,
    required this.city,
    required this.managerName,
    required this.managerEmail,
  });

  factory OrgModel.defaultSample() {
    return const OrgModel(
      name: 'مدارس النخبة الأهلية النموذجية',
      type: 'مدرسة ابتدائية',
      totalStudents: 340,
      totalTeachers: 24,
      totalClasses: 12,
      country: 'المملكة العربية السعودية',
      city: 'الرياض',
      managerName: 'د. عبد الله المنصور',
      managerEmail: 'director@eliteschools.edu',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'totalStudents': totalStudents,
      'totalTeachers': totalTeachers,
      'totalClasses': totalClasses,
      'country': country,
      'city': city,
      'managerName': managerName,
      'managerEmail': managerEmail,
    };
  }

  factory OrgModel.fromMap(Map map) {
    return OrgModel(
      name: map['name']?.toString() ?? 'مدارس النخبة الأهلية النموذجية',
      type: map['type']?.toString() ?? 'مدرسة ابتدائية',
      totalStudents: (map['totalStudents'] as num?)?.toInt() ?? 340,
      totalTeachers: (map['totalTeachers'] as num?)?.toInt() ?? 24,
      totalClasses: (map['totalClasses'] as num?)?.toInt() ?? 12,
      country: map['country']?.toString() ?? 'المملكة العربية السعودية',
      city: map['city']?.toString() ?? 'الرياض',
      managerName: map['managerName']?.toString() ?? 'د. عبد الله المنصور',
      managerEmail: map['managerEmail']?.toString() ?? 'director@eliteschools.edu',
    );
  }
}

/// Domain data model.
class OrgStudentModel {
  final String id;
  final String name;
  final int age;
  final String className;
  final String currentWorld;
  final int progressPercent;
  final int habitsCount;

  const OrgStudentModel({
    required this.id,
    required this.name,
    required this.age,
    required this.className,
    required this.currentWorld,
    required this.progressPercent,
    required this.habitsCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'className': className,
      'currentWorld': currentWorld,
      'progressPercent': progressPercent,
      'habitsCount': habitsCount,
    };
  }

  factory OrgStudentModel.fromMap(Map map) {
    return OrgStudentModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      age: (map['age'] as num?)?.toInt() ?? 7,
      className: map['className']?.toString() ?? 'الصف الأول',
      currentWorld: map['currentWorld']?.toString() ?? 'غابة البدايات',
      progressPercent: (map['progressPercent'] as num?)?.toInt() ?? 0,
      habitsCount: (map['habitsCount'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Domain data model.
class OrgClassModel {
  final String id;
  final String name;
  final String grade;
  final int studentsCount;
  final int avgProgressPercent;
  final int avgHabitsCount; // e.g. 18/30

  const OrgClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.studentsCount,
    required this.avgProgressPercent,
    required this.avgHabitsCount,
  });
}

class OrgRepositoryData {
  static List<OrgStudentModel> getSampleStudents() {
    return const [
      OrgStudentModel(
        id: 'st_1',
        name: 'عبد الرحمن خالد',
        age: 8,
        className: 'الصف الثاني (أ)',
        currentWorld: 'غابة البدايات',
        progressPercent: 85,
        habitsCount: 19,
      ),
      OrgStudentModel(
        id: 'st_2',
        name: 'ليان فهد',
        age: 7,
        className: 'الصف الأول (ب)',
        currentWorld: 'وادي الشجاعة',
        progressPercent: 92,
        habitsCount: 23,
      ),
      OrgStudentModel(
        id: 'st_3',
        name: 'يوسف طارق',
        age: 9,
        className: 'الصف الثالث (ج)',
        currentWorld: 'مملكة الحكمة',
        progressPercent: 78,
        habitsCount: 16,
      ),
      OrgStudentModel(
        id: 'st_4',
        name: 'نورة عبد العزيز',
        age: 8,
        className: 'الصف الثاني (أ)',
        currentWorld: 'واحة الإبداع',
        progressPercent: 95,
        habitsCount: 26,
      ),
      OrgStudentModel(
        id: 'st_5',
        name: 'سعود فيصل',
        age: 7,
        className: 'الصف الأول (أ)',
        currentWorld: 'غابة البدايات',
        progressPercent: 65,
        habitsCount: 14,
      ),
    ];
  }

  static List<OrgClassModel> getSampleClasses() {
    return const [
      OrgClassModel(
        id: 'cls_1',
        name: 'الصف الأول (أ)',
        grade: 'المرحلة الابتدائية - الصف 1',
        studentsCount: 28,
        avgProgressPercent: 82,
        avgHabitsCount: 18,
      ),
      OrgClassModel(
        id: 'cls_2',
        name: 'الصف الأول (ب)',
        grade: 'المرحلة الابتدائية - الصف 1',
        studentsCount: 26,
        avgProgressPercent: 76,
        avgHabitsCount: 15,
      ),
      OrgClassModel(
        id: 'cls_3',
        name: 'الصف الثاني (أ)',
        grade: 'المرحلة الابتدائية - الصف 2',
        studentsCount: 30,
        avgProgressPercent: 88,
        avgHabitsCount: 21,
      ),
      OrgClassModel(
        id: 'cls_4',
        name: 'الصف الثاني (ب)',
        grade: 'المرحلة الابتدائية - الصف 2',
        studentsCount: 29,
        avgProgressPercent: 71,
        avgHabitsCount: 14,
      ),
      OrgClassModel(
        id: 'cls_5',
        name: 'الصف الثالث (أ)',
        grade: 'المرحلة الابتدائية - الصف 3',
        studentsCount: 32,
        avgProgressPercent: 91,
        avgHabitsCount: 24,
      ),
      OrgClassModel(
        id: 'cls_6',
        name: 'الصف الثالث (ب)',
        grade: 'المرحلة الابتدائية - الصف 3',
        studentsCount: 31,
        avgProgressPercent: 84,
        avgHabitsCount: 19,
      ),
    ];
  }
}
