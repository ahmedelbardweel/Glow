enum HabitStatus {
  learned,
  inProgress,
  locked,
}

/// Domain data model.
class HabitModel {
  final int number;
  final String id;
  final String title;
  final String category; // Interactive 3D character component.
  final HabitStatus status;
  final String strengthReport;
  final String parentSupportSuggestion;

  const HabitModel({
    required this.number,
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.strengthReport,
    required this.parentSupportSuggestion,
  });

  HabitModel copyWith({
    HabitStatus? status,
  }) {
    return HabitModel(
      number: number,
      id: id,
      title: title,
      category: category,
      status: status ?? this.status,
      strengthReport: strengthReport,
      parentSupportSuggestion: parentSupportSuggestion,
    );
  }
}

/// Domain data model.
class HomeActivityModel {
  final String id;
  final String title;
  final String habitName;
  final int durationMinutes;
  final String description;
  final List<String> steps;

  const HomeActivityModel({
    required this.id,
    required this.title,
    required this.habitName,
    required this.durationMinutes,
    required this.description,
    required this.steps,
  });
}

class ParentRepositoryData {
  static List<HabitModel> generate30Habits() {
    return [
      const HabitModel(
        number: 1,
        id: 'h1',
        title: 'الثقة بالنفس والتعبير',
        category: 'شخصية',
        status: HabitStatus.learned,
        strengthReport: 'يظهر الطفل شجاعة في إبداء رأيه وطرح الأفكار بثقة في المواقف اليومية.',
        parentSupportSuggestion: 'امدح جهوده ومحاولاته الجديدة واطلب رأيه في أمور العائلة البسيطة.',
      ),
      const HabitModel(
        number: 2,
        id: 'h2',
        title: 'التعاون والمشاركة',
        category: 'اجتماعية',
        status: HabitStatus.learned,
        strengthReport: 'يتعاون بمرونة مع إخوته وأصدقائه ويشارك ألعابه وأدواته بروح الفريق.',
        parentSupportSuggestion: 'شاركه في إعداد وجبة خفيفة أو ترتيب الصالة معاً كفريق.',
      ),
      const HabitModel(
        number: 3,
        id: 'h3',
        title: 'النظافة والترتيب الشخصي',
        category: 'بدنية',
        status: HabitStatus.inProgress,
        strengthReport: 'بدأ يلتزم بغسل يديه بانتظام ويرتب حقيبته المدرسية بعد عودته.',
        parentSupportSuggestion: 'صمم معه جدولاً يومياً جذاباً لمكافأة ترتيب الغرفة والأدوات.',
      ),
      const HabitModel(
        number: 4,
        id: 'h4',
        title: 'الصدق والأمانة',
        category: 'شخصية',
        status: HabitStatus.inProgress,
        strengthReport: 'يقول الصدق عندما يتم سؤاله بهدوء دون تخويف أو ضغط.',
        parentSupportSuggestion: 'استقبل اعترافه بالخطأ بحب واشكره على صدقه لتثبيت العادة والشجاعة.',
      ),
      const HabitModel(
        number: 5,
        id: 'h5',
        title: 'النوم المبكر والنشاط',
        category: 'بدنية',
        status: HabitStatus.locked,
        strengthReport: 'يحتاج لدعم في ترك الشاشات والذهاب للنوم في موعد ثابت.',
        parentSupportSuggestion: 'خصص 15 دقيقة لقراءة قصة دافئة قبل النوم مع إطفاء الأجهزة الإلكترونية.',
      ),

      const HabitModel(
        number: 6,
        id: 'h6',
        title: 'إدارة الغضب وضبط النفس',
        category: 'عاطفية',
        status: HabitStatus.locked,
        strengthReport: 'يتعلم تقنيات التنفس العميق عند الانفعال لتهدئة مشاعره.',
        parentSupportSuggestion: 'درّبه على أخذ 3 أنفاس عميقة والعد التنازلي بهدوء قبل الكلام.',
      ),
      const HabitModel(
        number: 7,
        id: 'h7',
        title: 'التعبير عن المشاعر بوضوح',
        category: 'عاطفية',
        status: HabitStatus.locked,
        strengthReport: 'يتحدث عن مخاوفه وحزنه مع الوالدين دون كتمان.',
        parentSupportSuggestion: 'اطرح عليه أسئلة مفتوحة مثل: "ما أجمل شيء حدث اليوم؟ وما الذي أزعجك؟".',
      ),
      const HabitModel(
        number: 8,
        id: 'h8',
        title: 'التعاطف مع الآخرين',
        category: 'اجتماعية',
        status: HabitStatus.locked,
        strengthReport: 'يشعر بحزن أصدقائه ويساندهم بكلمات لطيفة.',
        parentSupportSuggestion: 'ناقش معه مشاعر شخصيات القصص واسأله كيف كان ليتصرف لو كان مكانهم.',
      ),
      const HabitModel(
        number: 9,
        id: 'h9',
        title: 'الصبر والانتظار الجميل',
        category: 'شخصية',
        status: HabitStatus.locked,
        strengthReport: 'يحترم الأدوار في الطوابير والألعاب دون مقاطعة.',
        parentSupportSuggestion: 'العَب معه ألعاباً تتطلب انتظار الدور وركز على مدح هدوئه.',
      ),
      const HabitModel(
        number: 10,
        id: 'h10',
        title: 'الشجاعة الأدبية والاعتذار',
        category: 'شخصية',
        status: HabitStatus.locked,
        strengthReport: 'يعترف بالخطأ ويبادر بكلمة "أعتذر" بصدق.',
        parentSupportSuggestion: 'كن قدوة في الاعتذار أمامه عندما تخطئ ليرى أن الاعتذار شجاعة.',
      ),

      const HabitModel(
        number: 11,
        id: 'h11',
        title: 'المثابرة وعدم الاستسلام',
        category: 'عقلية',
        status: HabitStatus.locked,
        strengthReport: 'يحاول حل المسائل والتحديات الصعبة أكثر من مرة.',
        parentSupportSuggestion: 'ذكّره بأن الفشل خطوة طبيعية نحو التعلم وركز على مكافأة المحاولة.',
      ),
      const HabitModel(
        number: 12,
        id: 'h12',
        title: 'التفكير في حل المشكلات',
        category: 'عقلية',
        status: HabitStatus.locked,
        strengthReport: 'يبتكر بدائل وحلولاً عملية عند مواجهة أي عائق.',
        parentSupportSuggestion: 'اسأله دائماً: "ما هي الحلول والخيارات المتاحة أمامنا الآن؟".',
      ),
      const HabitModel(
        number: 13,
        id: 'h13',
        title: 'الدفاع عن الحق واللطف',
        category: 'اجتماعية',
        status: HabitStatus.locked,
        strengthReport: 'يقف بجانب الضعيف ويرفض التنمر بلطف وشجاعة.',
        parentSupportSuggestion: 'علمه متى وكيف يطلب مساعدة المعلم بحكمة وشجاعة عند رؤية خطأ.',
      ),
      const HabitModel(
        number: 14,
        id: 'h14',
        title: 'مواجهة المخاوف والتجربة',
        category: 'شخصية',
        status: HabitStatus.locked,
        strengthReport: 'يتحمس لتجربة الأنشطة الإيجابية الجديدة وتخطي الرهبة.',
        parentSupportSuggestion: 'شجعه على الخطابة والإلقاء المنزلي وتجربة مهارات جديدة أسبوعياً.',
      ),
      const HabitModel(
        number: 15,
        id: 'h15',
        title: 'الاستقلالية والاعتماد على النفس',
        category: 'شخصية',
        status: HabitStatus.locked,
        strengthReport: 'يؤدي واجباته وينظم أغراضه دون الحاجة للتذكير المستمر.',
        parentSupportSuggestion: 'أوكل إليه مهاماً منزلية واضحة ومحددة تناسب عمره.',
      ),

      const HabitModel(
        number: 16,
        id: 'h16',
        title: 'التخطيط وتحديد الأهداف',
        category: 'قيادية',
        status: HabitStatus.locked,
        strengthReport: 'يرسم خطة لأولويات يومه بين المذاكرة والراحة واللعب.',
        parentSupportSuggestion: 'ساعده في كتابة قائمة مهام يومية بسيطة وشطب المنجز منها.',
      ),
      const HabitModel(
        number: 17,
        id: 'h17',
        title: 'حب القراءة والاستكشاف',
        category: 'عقلية',
        status: HabitStatus.locked,
        strengthReport: 'يستمتع بقراءة الكتب والقصص وتصفح الموسوعات المصورة.',
        parentSupportSuggestion: 'اصطحبه للمكتبة بانتظام ودعه يختار الكتب التي تشد انتباهه.',
      ),
      const HabitModel(
        number: 18,
        id: 'h18',
        title: 'احترام الوقت والمواعيد',
        category: 'اجتماعية',
        status: HabitStatus.locked,
        strengthReport: 'يلتزم بمواعيد الحصص والأنشطة والاتفاقات بدقة.',
        parentSupportSuggestion: 'استخدم ساعة رملية أو منبهاً بصرياً لتدريبه على تقدير الوقت.',
      ),
      const HabitModel(
        number: 19,
        id: 'h19',
        title: 'الامتنان وشكر النعم',
        category: 'شخصية',
        status: HabitStatus.locked,
        strengthReport: 'يشكر والديه ومعلميه ويقدر النعم المحيطة به يومياً.',
        parentSupportSuggestion: 'شارك معه يومياً في جلسة عشاء ذكر 3 نعم جميلة حدثت خلال اليوم.',
      ),
      const HabitModel(
        number: 20,
        id: 'h20',
        title: 'التفكير الإيجابي والحوار',
        category: 'عقلية',
        status: HabitStatus.locked,
        strengthReport: 'يبحث عن الجانب المشرق ويتحاور بهدوء لتقريب وجهات النظر.',
        parentSupportSuggestion: 'ناقش معه المواقف الصعبة وركز على الدروس الإيجابية المستفادة.',
      ),

      const HabitModel(
        number: 21,
        id: 'h21',
        title: 'الفضول العلمي وطرح الأسئلة',
        category: 'عقلية',
        status: HabitStatus.locked,
        strengthReport: 'يطرح تساؤلات ذكية ويبحث عن تفسيرات علمية لما حوله.',
        parentSupportSuggestion: 'شجّع أسئلته وابحث معه عن الإجابات في مصادر علمية موثوقة.',
      ),
      const HabitModel(
        number: 22,
        id: 'h22',
        title: 'حماية البيئة وإعادة التدوير',
        category: 'اجتماعية',
        status: HabitStatus.locked,
        strengthReport: 'يحافظ على نظافة الأماكن العامة ويعيد تدوير الخامات القديمة.',
        parentSupportSuggestion: 'نفذ معه نشاطاً يدوياً لتحويل صندوق قديم إلى عمل فني مفيد.',
      ),
      const HabitModel(
        number: 23,
        id: 'h23',
        title: 'استكشاف المواهب والفنون',
        category: 'شخصية',
        status: HabitStatus.locked,
        strengthReport: 'يعبّر عن ذاته بالرسم أو الكتابة أو الإلقاء بحرية وإتقان.',
        parentSupportSuggestion: 'وفّر له أدوات فنية ومساحة خاصة لممارسة هواياته وتشجيعه عليها.',
      ),
      const HabitModel(
        number: 24,
        id: 'h24',
        title: 'العمل الجماعي والتكامل',
        category: 'اجتماعية',
        status: HabitStatus.locked,
        strengthReport: 'يستثمر مواهب زملائه المتنوعة لإنجاز مشاريع مبهرة.',
        parentSupportSuggestion: 'شجعه على المشاركة في الأنشطة الكشفية والفرق الجماعية.',
      ),
      const HabitModel(
        number: 25,
        id: 'h25',
        title: 'التفكير خارج الصندوق',
        category: 'عقلية',
        status: HabitStatus.locked,
        strengthReport: 'يقدم أفكاراً وحلولاً غير تقليدية للمواقف اليومية.',
        parentSupportSuggestion: 'اطرح عليه ألغازاً وتحديات تفكير خيالي واطلب منه حلولاً متعددة.',
      ),

      const HabitModel(
        number: 26,
        id: 'h26',
        title: 'القيادة بالقدوة والأفعال',
        category: 'قيادية',
        status: HabitStatus.locked,
        strengthReport: 'يمثل نموذجاً إيجابياً ومصدر إلهام لأقرانه وإخوته الصغار.',
        parentSupportSuggestion: 'عزز ثقته بمهاراته القيادية وأسند إليه مسؤوليات توجيهية لطيفة.',
      ),
      const HabitModel(
        number: 27,
        id: 'h27',
        title: 'العطاء والمبادرة المجتمعية',
        category: 'اجتماعية',
        status: HabitStatus.locked,
        strengthReport: 'يبادر بمساعدة الآخرين والمشاركة في الحملات التطوعية والخيرية.',
        parentSupportSuggestion: 'اصطحبه للمشاركة في مبادرة تطوعية لغرس أشجار أو توزيع وجبات.',
      ),
      const HabitModel(
        number: 28,
        id: 'h28',
        title: 'الرقابة الذاتية والنزاهة',
        category: 'شخصية',
        status: HabitStatus.locked,
        strengthReport: 'يلتزم بالأمانة والصدق في الخلوة والجلوة بدافع الضمير الحي.',
        parentSupportSuggestion: 'اربط تصرفاته بمراقبة الله ومحبته للعمل المتقن الصادق.',
      ),
      const HabitModel(
        number: 29,
        id: 'h29',
        title: 'النشاط البدني والغذاء الصحي',
        category: 'بدنية',
        status: HabitStatus.locked,
        strengthReport: 'يمارس الرياضة اليومية ويختار الفواكه والخضار بوعي واقتناع.',
        parentSupportSuggestion: 'اجعل الرياضة والغذاء الصحي نمط حياة مشترك لكل أفراد العائلة.',
      ),
      const HabitModel(
        number: 30,
        id: 'h30',
        title: 'صناعة الأثر وترسيخ العادات',
        category: 'قيادية',
        status: HabitStatus.locked,
        strengthReport: 'رسخ العادات الـ 30 في سلوكه اليومي ليصبح سفيراً للقيم النبيلة.',
        parentSupportSuggestion: 'احتفل بإنجازه الكبير وامنحه وسام بطل GLOW الذهبي.',
      ),
    ];
  }

  static List<HomeActivityModel> getHomeActivities() {
    return [
      const HomeActivityModel(
        id: 'act1',
        title: 'تحدي النجوم الخمس',
        habitName: 'النظافة والترتيب',
        durationMinutes: 15,
        description: 'نشاط عائلي ممتع لترتيب الغرفة والمكتب وتحويل النظافة إلى لعبة سرعة.',
        steps: [
          'شغل مؤقت الساعة لـ 10 دقائق.',
          'يقوم البطل بجمع الألعاب ووضعها في الصندوق المخصص.',
          'ترتيب الكتب على الرف حسب الحجم.',
          'تقييم النتيجة ووضع نجمة ذهبية على لوحة الإنجاز.',
        ],
      ),
      const HomeActivityModel(
        id: 'act2',
        title: 'شجرة الامتنان اليومية',
        habitName: 'الامتنان والشكر',
        durationMinutes: 10,
        description: 'صناعة لوحة شجرة عائلية تلصق عليها أوراق الشكر اليومية قبل النوم.',
        steps: [
          'رسم شجرة على كرتون مقوى وتعليقها على الحائط.',
          'كتابة 3 أشياء نشكر الله عليها كل مساء على ورقة ملونة.',
          'لصق الورقة على أحد فروع الشجرة وقراءتها مع العائلة.',
        ],
      ),
      const HomeActivityModel(
        id: 'act3',
        title: 'مختبر الأفكار الإبداعية',
        habitName: 'إعادة التدوير والابتكار',
        durationMinutes: 25,
        description: 'تحويل العلب والكرتون القديم إلى حامل أقلام أو مجسم صاروخ مبتكر.',
        steps: [
          'تجهيز علبة كرتون فارغة وألوان ومقص آمن للأطفال.',
          'تلوين العلبة بألوان البطل المفضلة ورسم وجه PORT اللطيف عليها.',
          'استخدام العلبة لحفظ أدوات الرسم على المكتب.',
        ],
      ),
    ];
  }
}
