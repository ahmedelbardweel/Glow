import '../models/child_models.dart';

/// Provides 10 rich, pedagogically sound Arabic quizzes for each mission of World 1.
class World1QuizzesData {
  static List<QuizModel> getQuizzesForMission(String missionId, QuizModel fallback) {
    final list = _allMissionQuizzes[missionId];
    if (list != null && list.isNotEmpty) {
      return list;
    }
    return [fallback];
  }

  static final Map<String, List<QuizModel>> _allMissionQuizzes = {
    // ==========================================
    // Mission 1: الثقة بالنفس (10 Questions)
    // ==========================================
    'w1_m1': [
      const QuizModel(
        situation: 'طلب المعلم في الصف مشاركة فكرة جديدة، وأنت لديك فكرة جميلة لكنك متردد:',
        question: 'ما هو التصرف الأكثر ثقة وإيجابية؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أرفع يدي بأدب وأشارك فكرتي بثقة وابتسامة.', explanation: 'رائع جداً! رفع اليد والمشاركة يعبر عن الثقة والحرص على التعلم.'),
          QuizOptionModel(keyId: 'B', text: 'ألتزم الصمت التام ولا أتحدث أبداً.', explanation: 'الصمت يحرمك ويحرم أصدقاءك من الاستفادة من أفكارك الرائعة.'),
          QuizOptionModel(keyId: 'C', text: 'أطلب من زميلي أن يتكلم بدلاً عني.', explanation: 'صوتك وفكرتك مميزان جداً ويستحقان أن تعبر عنهما بنفسك.'),
          QuizOptionModel(keyId: 'D', text: 'أغلق دفاتري وأتجاهل الدرس.', explanation: 'تجاهل الدرس يضيع عليك فرصة التعلم والتألق في الصف.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'برافوو يا بطل! أحسنت الاختيار، الثقة بالنفس تصنع القادة دائماً.',
        gentleFeedbackWrong: 'محاولة جميلة! تذكر دائماً أن مشاركة أفكارك بجرأة وأدب هي سر النجاح والتفوق.',
      ),
      const QuizModel(
        situation: 'التقيت بطفل جديد انضم لصفك اليوم وهو يقف بمفرده:',
        question: 'كيف تظهر ثقتك بنفسك ولطفك؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أتقدم نحوه بابتسامة، أعرّفه بنفسي وأرحب به.', explanation: 'المبادرة بالسلام والتعريف بالنفس قمة الشجاعة والذوق الرفيع.'),
          QuizOptionModel(keyId: 'B', text: 'أنتظر حتى يأتي هو للحديث معي.', explanation: 'المبادرة تجعل الآخرين يشعرون بالأمان والألفة معك.'),
          QuizOptionModel(keyId: 'C', text: 'أنظر إليه بتعجب وأبتعد عنه.', explanation: 'الابتعاد يشعره بالوحدة في يومه الأول.'),
          QuizOptionModel(keyId: 'D', text: 'أشير إليه وأهمس لزملائي.', explanation: 'الهمس يسبب الحرج للآخرين وليس من شيم الأبطال.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'يا لك من بطل شجاع ولطيف! الثقة تصنع أروع الصداقات.',
        gentleFeedbackWrong: 'محاولة طيبة! الترحيب بالآخرين يعبر عن ثقتك العالية بنفسك.',
      ),
      const QuizModel(
        situation: 'طُلب منك إلقاء كلمة قصيرة في الإذاعة المدرسية الصباحية:',
        question: 'ما هو الموقف الأكثر شجاعة وتألقاً؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أستعد جيداً، أتنفس بهدوء، وألقي الكلمة بصوت واضح.', explanation: 'التدريب والاستعداد يمنحانك ثقة هائلة وحضوراً رائعاً.'),
          QuizOptionModel(keyId: 'B', text: 'أعتذر وأقول لا أستطيع الوقوف أمام الجمهور.', explanation: 'الهروب يمنعك من اكتشاف موهبتك وإبهار الجميع.'),
          QuizOptionModel(keyId: 'C', text: 'أتظاهر بالغياب أو التعب.', explanation: 'مواجهة التحديات تبني شخصيتك القيادية القوية.'),
          QuizOptionModel(keyId: 'D', text: 'أقرأ بسرعة فائقة دون أن ينتبه أحد.', explanation: 'القراءة الهادئة تبرز جمال صوتك ورسالتك.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'خطيب وقائد مستقبلي! الشجاعة تصقل موهبتك وتزيدك فخراً.',
        gentleFeedbackWrong: 'محاولة جيدة! كل تجربة إلقاء تزيدك ثقة وقوة للمرات القادمة.',
      ),
      const QuizModel(
        situation: 'اختلف رأيك مع صديقك حول لعبة معينة، وترى أن رأيك صحيح ومناسب:',
        question: 'كيف تعبر عن وجهة نظرك بثقة؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أشرح وجهة نظري بهدوء واحترام مع الاستماع لرأيه.', explanation: 'الواثق من نفسه يناقش بهدوء ويحترم الطرف الآخر.'),
          QuizOptionModel(keyId: 'B', text: 'أصرخ وأفرض رأيي بالقوة.', explanation: 'الصراخ يدل على قلة الحيلة ويخسر الصداقات.'),
          QuizOptionModel(keyId: 'C', text: 'أستسلم فوراً وأكتم فكرتي.', explanation: 'من حقك التعبير عن رأيك بأدب دون خجل.'),
          QuizOptionModel(keyId: 'D', text: 'أخاصمه وأوقف اللعب.', explanation: 'الحوار الذكي يحل الخلافات ويبقى على المحبة.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'محاور بارع وواثق! الحوار الراقي يميز الأبطال الأذكياء.',
        gentleFeedbackWrong: 'محاولة طيبة! الثقة تعني التعبير بأدب مع احترام مشاعر الآخرين.',
      ),
      const QuizModel(
        situation: 'جربت لعبة جديدة ولم تتقنها من المحاولة الأولى وضحك أحد الزملاء:',
        question: 'ما هو رد فعلك الواثق؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أبتسم وأقول: سأتدرب وسأتقنها قريباً، ثم أواصل المحاولة.', explanation: 'عقلية النمو هي سر كل إنجاز، فكل خبير كان مبتدئاً يوماً ما.'),
          QuizOptionModel(keyId: 'B', text: 'أبكي وأترك المكان حزيناً.', explanation: 'لا تدع تعليقات الآخرين تحبط إصرارك الجميل.'),
          QuizOptionModel(keyId: 'C', text: 'أتشاجر معه وأغضب بشدة.', explanation: 'الهدوء يظهر قوتك الداخلية وثقتك الكبيرة.'),
          QuizOptionModel(keyId: 'D', text: 'أقسم ألا ألعب هذه اللعبة أبداً.', explanation: 'التخلي عن التجارب يحرمك من التطور والمتعة.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'إصرار أسطوري وثقة لا تهتز! ستصبح بطلاً في هذه اللعبة قريباً.',
        gentleFeedbackWrong: 'محاولة طيبة! الثقة بالنفس تجعلك أقوى من أي موقف عابر.',
      ),
      const QuizModel(
        situation: 'أثناء المشي في طابور المدرسة أو الممر:',
        question: 'كيف تعكس هيئتك الثقة بالنفس؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أمشي بقامة مستقيمة ورأس مرفوع وابتسامة مشرقة.', explanation: 'لغة الجسد الإيجابية تعزز ثقتك وتمنحك طاقة وحيوية.'),
          QuizOptionModel(keyId: 'B', text: 'أمشي منحنياً وأنظر للأرض فقط.', explanation: 'النظر للأمام يعبر عن الاستعداد والتفاؤل.'),
          QuizOptionModel(keyId: 'C', text: 'أركض وأدفع من حولي بعشوائية.', explanation: 'النظام والهدوء هما عنوان الرقي والانضباط.'),
          QuizOptionModel(keyId: 'D', text: 'أختبئ خلف زملائي حتى لا يراني المعلم.', explanation: 'أنت مميز وتستحق أن تظهر بكل اعتزاز.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'هيئة القائد البطل! قوامك المستقيم وابتسامتك عنوان ثقتك.',
        gentleFeedbackWrong: 'محاولة جيدة! مشيتك الواثقة تمنحك شعوراً فورياً بالقوة والنشاط.',
      ),
      const QuizModel(
        situation: 'لم تفهم جزءاً من الشرح أثناء الحصة المدرسية:',
        question: 'ما هو التصرف الذي يعبر عن الثقة والحرص على التعلم؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أرفع يدي بأدب وأطلب من المعلم إعادة توضيح النقطة.', explanation: 'السؤال علامة الذكاء والشجاعة في طلب العلم.'),
          QuizOptionModel(keyId: 'B', text: 'أخجل من السؤال حتى لا يقول زملائي أنني لم أفهم.', explanation: 'الخجل من التعلم يضيع عليك فرص الفهم والتفوق.'),
          QuizOptionModel(keyId: 'C', text: 'أتجاهل الأمر وأتظاهر بالفهم التام.', explanation: 'التظاهر لا يحل المشكلة بل يراكم الدروس.'),
          QuizOptionModel(keyId: 'D', text: 'أنتظر حتى يرسب زملائي في الاختبار.', explanation: 'حب الخير للجميع وطلب العلم هما جوهر البطولة.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'طالب علم شجاع وذكي! السؤال مفتاح كل معرفة عظيمة.',
        gentleFeedbackWrong: 'محاولة طيبة! السؤال بأدب يعكس ثقتك وحرصك على التميز دائماً.',
      ),
      const QuizModel(
        situation: 'أعطاك المعلم واجباً إضافياً صعباً لتحدي الطلاب المتميزين:',
        question: 'كيف تستقبل هذا التحدي بثقة؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أفرح بالتحدي وأقول: سأبذل كل جهدي لحله بتفوق.', explanation: 'الترحيب بالتحديات هو سمة الأذكياء والشجعان.'),
          QuizOptionModel(keyId: 'B', text: 'أتذمر وأقول هذا صعب ومستحيل.', explanation: 'لا يوجد مستحيل مع المحاولة والتركيز.'),
          QuizOptionModel(keyId: 'C', text: 'أطلب من أخي حله كاملاً بدلاً عني.', explanation: 'حلك الذاتي يطور مهاراتك ويزيدك ذكاءً.'),
          QuizOptionModel(keyId: 'D', text: 'أهمل الواجب ولا أحاول فيه إطلاقاً.', explanation: 'المحاولة هي أول درجات النجاح والتفوق.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'بطل التحديات! عقليتك الإيجابية تفتح لك أبواب العبقرية.',
        gentleFeedbackWrong: 'محاولة جميلة! الثقة بالنفس تجعلك تستمتع بحل أصعب المسائل.',
      ),
      const QuizModel(
        situation: 'رأيت شخصاً يحاول التقليل من قدراتك أو إحباطك بكلمات سلبية:',
        question: 'كيف تحمي ثقتك بنفسك وتتصرف بحكمة؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أثق بقدراتي، لا ألتفت لكلامه، وأثبت تميزي بأفعالي.', explanation: 'الرد بالأفعال والإنجازات هو أقوى رد على المشككين.'),
          QuizOptionModel(keyId: 'B', text: 'أصدقه وأشعر بالإحباط والفشل.', explanation: 'أنت بطل رائع ولديك قدرات لا حدود لها.'),
          QuizOptionModel(keyId: 'C', text: 'أرد عليه بألفاظ سيئة.', explanation: 'الكلمات الطيبة والأخلاق العالية ترفع من شأنك.'),
          QuizOptionModel(keyId: 'D', text: 'أبكي وأنعزل عن الجميع.', explanation: 'ثقتك بنفسك تنبع من داخلك ومن محبة الله لك.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'درع الثقة الذهبي! لا تدع أي كلمة سلبية تهز إيمانك بقدراتك.',
        gentleFeedbackWrong: 'محاولة طيبة! تذكر دائماً أنك بطل قادر على صنع المعجزات.',
      ),
      const QuizModel(
        situation: 'حققت اليوم إنجازاً رائعاً في دراستك أو نشاطك الرياضي:',
        question: 'ما هو الشعور المتوازن والواثق؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أشكر الله وأفخر بإنجازي بتواضع، وأشجع أصدقائي.', explanation: 'الثقة مع التواضع هي قمة كمال الشخصية القيادية.'),
          QuizOptionModel(keyId: 'B', text: 'أتكبر على زملائي وأسخر منهم.', explanation: 'التكبر يبعد الناس عنك ويمحو جمال إنجازك.'),
          QuizOptionModel(keyId: 'C', text: 'أقلل من قيمة ما فعلته وأقول إنه بالصدفة.', explanation: 'الاعتزاز بتعبك وجهدك يعزز تقديرك لذاتك.'),
          QuizOptionModel(keyId: 'D', text: 'أتوقف عن التدريب لأنني أصبحت الأفضل.', explanation: 'الاستمرار في التعلم يحافظ على تفوقك الدائم.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'قائد متواضع وواثق! فخورون بك وبإنجازاتك الرائعة يا بطل.',
        gentleFeedbackWrong: 'محاولة جميلة! الفخر المتواضع وشكر النعمة يزيدانك نجاحاً وبركة.',
      ),
    ],

    // ==========================================
    // Mission 5: النوم المبكر والنشاط (10 Questions)
    // ==========================================
    'w1_m5': [
      const QuizModel(
        situation: 'حان وقت النوم المحدد لك ولديك غداً مغامرة مدرسية شيقة:',
        question: 'ما هو القرار الأنسب؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أغلق الشاشات وأفرش أسناني وأذهب لسريري في الوقت المحدد.', explanation: 'رائع جداً! النوم الصحي يمنحك ذكاءً ونشاطاً استثنائياً.'),
          QuizOptionModel(keyId: 'B', text: 'أسهر لساعات متأخرة ألعب بالأجهزة.', explanation: 'السهر يسبب التعب وضعف التركيز في اليوم التالي.'),
          QuizOptionModel(keyId: 'C', text: 'أشرب مشروبات سكرية ومشروبات غازية قبل النوم.', explanation: 'السكريات قبل النوم تزعج نومك وتؤذي أسنانك.'),
          QuizOptionModel(keyId: 'D', text: 'أرفض النوم حتى الصباح.', explanation: 'النوم غير المنتظم يضر بصحتك ونموك البدني.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'أحسنت يا بطل! النوم المبكر يصنع الأبطال الأذكياء.',
        gentleFeedbackWrong: 'محاولة جميلة! راحة الجسم ضرورية لتستيقظ بكامل طاقتك وإبداعك.',
      ),
      const QuizModel(
        situation: 'قبل موعد النوم بساعة واحدة، ما هو النشاط الأفضل لتهيئة عقلك للراحة؟',
        question: 'اختر العادة المسائية الأذكى والأكثر هدوءاً:',
        options: [
          QuizOptionModel(keyId: 'A', text: 'قراءة قصة هادئة أو الاستماع لحديث عائلي لطيف.', explanation: 'القراءة الهادئة تريح الأعصاب وتساعدك على نوم عميق ومريح.'),
          QuizOptionModel(keyId: 'B', text: 'مشاهدة فيديوهات سريعة وصاخبة على الهاتف.', explanation: 'الضوء الأزرق للشاشات يمنع إفراز هرمون النوم ويجهد العين.'),
          QuizOptionModel(keyId: 'C', text: 'ممارسة الرياضة العنيفة والركض السريع.', explanation: 'الرياضة الشاقة قبل النوم مباشرة ترفع دقات القلب وتؤخر النوم.'),
          QuizOptionModel(keyId: 'D', text: 'تناول وجبة عشاء ثقيلة ودسمة.', explanation: 'الوجبات الدسمة تسبب عسر الهضم وتزعج نومك.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'بطل العادات المسائية الهادئة! نومك الهانئ يصنع صباحك المشرق.',
        gentleFeedbackWrong: 'محاولة طيبة! تهدئة الإضاءة والأنشطة الهادئة تمنحك نوماً عميقاً.',
      ),
      const QuizModel(
        situation: 'دق المنبه في الصباح الباكر للاستيقاظ لصلاة الصبح والمدرسة:',
        question: 'ما هو تصرف البطل المفعم بالحيوية؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أذكر الله، أبتسم، وأنهض بنشاط وأرتب سريري فوراً.', explanation: 'الاستيقاظ المبكر بابتسامة يملأ يومك بالبركة والطاقة الإيجابية.'),
          QuizOptionModel(keyId: 'B', text: 'أضغط زر الغفوة عدة مرات وأتأخر عن الحافلة.', explanation: 'التأجيل يسبب التوتر والاندفاع غير المنظم في الصباح.'),
          QuizOptionModel(keyId: 'C', text: 'أصرخ وأتذمر بغضب لأنني لا أريد الاستيقاظ.', explanation: 'البدء بالغضب يفسد جمال يومك ونشاطك.'),
          QuizOptionModel(keyId: 'D', text: 'أواصل النوم حتى يوقظني والدي عدة مرات بصعوبة.', explanation: 'الاعتماد على النفس في الاستيقاظ يعكس شخصيتك المنضبطة.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'صباح النشاط والبركة! استيقاظك المبكر يجعلك دائماً في المقدمة.',
        gentleFeedbackWrong: 'محاولة جيدة! النهوض فور رنين المنبه يمنحك شعوراً رائعاً بالإنجاز.',
      ),
      const QuizModel(
        situation: 'لماذا يحتاج دماغك وجسمك إلى 8-10 ساعات من النوم كل ليلة؟',
        question: 'ما هي الفائدة العظمى للنوم الليلي المنتظم؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'لإفراز هرمون النمو، تقوية المناعة، وتثبيت المعلومات والذاكرة.', explanation: 'أحسنت! النوم هو المصنع السري لنمو عضلاتك وذكاء عقلك.'),
          QuizOptionModel(keyId: 'B', text: 'فقط لتمضية الوقت حتى يأتي النهار.', explanation: 'النوم عملية حيوية بالغة الأهمية لصحتك وذكائك.'),
          QuizOptionModel(keyId: 'C', text: 'حتى لا نأكل طعاماً كثيراً في الليل.', explanation: 'الفائدة الحقيقية هي تجديد الخلايا وصحة الجهاز العصبي.'),
          QuizOptionModel(keyId: 'D', text: 'ليس للنوم أي فائدة حقيقية.', explanation: 'قلة النوم تسبب ضعف المناعة وصعوبة الفهم والتركيز.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'عالم صحي وبطل عبقري! فهمك لأهمية النوم يجعلك تحافظ على صحتك.',
        gentleFeedbackWrong: 'محاولة طيبة! النوم الليلي هو السر وراء قوتك وطاقتك وذكائك الدراسي.',
      ),
      const QuizModel(
        situation: 'في عطلة نهاية الأسبوع، كيف تحافظ على ساعتك البيولوجية ونشاطك؟',
        question: 'ما هو التوازن الصحي للنوم في الإجازة؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'أنام وأستيقظ في مواعيد قريبة من المعتاد للاستمتاع بنهار الإجازة.', explanation: 'الحفاظ على مواعيد نوم منتظمة يمنحك طاقة ويجنبك كسل بداية الأسبوع.'),
          QuizOptionModel(keyId: 'B', text: 'أسهر حتى الفجر وأنام طوال النهار حتى المغرب.', explanation: 'قلب الليل نهاراً يسبب الخمول والصداع ويفوت عليك متعة اليوم.'),
          QuizOptionModel(keyId: 'C', text: 'أرفض النوم ليومين متتاليين.', explanation: 'الحرمان من النوم خطر كبير على صحة القلب والدماغ.'),
          QuizOptionModel(keyId: 'D', text: 'أقضي الإجازة كاملة نائماً في السرير.', explanation: 'الاعتدال والنشاط الحركي هما جوهر الاستمتاع بالإجازة.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'بطل واعي ومنظم! التوازن في الإجازة يمنحك متعة وصحة مضاعفة.',
        gentleFeedbackWrong: 'محاولة جميلة! النوم المنتظم يحفظ طاقتك ويجعلك تستمتع بكل لحظة من الإجازة.',
      ),
      const QuizModel(
        situation: 'عند الذهاب للسرير، ما هي أفضل بيئة لغرفة نوم مريحة؟',
        question: 'كيف تجهز غرفتك لنوم عميق ومريح؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'إضاءة خافتة، جو هادئ ومعتدل الحرارة، وسرير نظيف ومرتب.', explanation: 'الظلام والهدوء يساعدان جسمك على الاسترخاء والنوم السريع.'),
          QuizOptionModel(keyId: 'B', text: 'أضواء قوية وشاشات تلفاز وموسيقى صاخبة.', explanation: 'الضجيج والضوء القوي يمنعان الوصول لمراحل النوم العميق.'),
          QuizOptionModel(keyId: 'C', text: 'غرفة مليئة بالألعاب المبعثرة على السرير.', explanation: 'ترتيب السرير يمنحك راحة نفسية وهدوءاً عند النوم.'),
          QuizOptionModel(keyId: 'D', text: 'النوم مع تشغيل أجهزة الهاتف بجانب رأسك.', explanation: 'إبعاد الأجهزة عن السرير يحميك من التشتت والموجات.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'بيئة نوم مثالية كالأمراء! أحسنت اختيار الهدوء والنظافة.',
        gentleFeedbackWrong: 'محاولة طيبة! الغرفة الهادئة والمظلمة هي مفتاح النوم السحري العميق.',
      ),
      const QuizModel(
        situation: 'ما هي العادة الصحية الواجب فعلها دائماً قبل وضع رأسك على الوسادة؟',
        question: 'اختر العادة النظيفة لحماية أسنانك وصحتك:',
        options: [
          QuizOptionModel(keyId: 'A', text: 'تنظيف أسناني بالفرشاة والمعجون، وقراءة أذكار النوم.', explanation: 'تنظيف الأسنان يحميها من التسوس طوال الليل والأذكار تبعث الطمأنينة.'),
          QuizOptionModel(keyId: 'B', text: 'أكل شوكولاتة وحلوى مصاص في السرير.', explanation: 'السكريات قبل النوم تدمر مينا الأسنان وتسبب التسوس.'),
          QuizOptionModel(keyId: 'C', text: 'النوم بحذاء المدرسة والملابس المتسخة.', explanation: 'تبديل الملابس وارتداء ثياب نوم نظيفة يمنحك راحة وانتعاشاً.'),
          QuizOptionModel(keyId: 'D', text: 'شرب كمية هائلة من المشروبات الغازية.', explanation: 'المشروبات الغازية تسبب الحموضة وتؤرق النوم.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'بطل نظيف ومحمي من التسوس! نومك الهانئ يبدأ بابتسامة ناصعة.',
        gentleFeedbackWrong: 'محاولة جيدة! تنظيف الأسنان بالفرشاة قبل النوم أهم عادة لحمايتها دائماً.',
      ),
      const QuizModel(
        situation: 'استيقظت صباحاً ولديك اختبار مدرسي مهم:',
        question: 'كيف يساعدك نومك المبكر الليلة الماضية في الاختبار؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'تركيزي عالٍ، ذهني صافٍ، وأتذكر المعلومات بكل سهولة وسرعة.', explanation: 'النوم الكافي يعزز الذاكرة ويجعلك تحل الأسئلة بثقة وذكاء.'),
          QuizOptionModel(keyId: 'B', text: 'أشعر بالنعاس وأنسى الإجابات.', explanation: 'هذا ما يحدث مع السهر، أما النوم المبكر فيعطيك تفوقاً باهراً.'),
          QuizOptionModel(keyId: 'C', text: 'أنام فوق ورقة الاختبار.', explanation: 'النوم الجيد ليلاً يجعلك مفعماً باليقظة والتألق في الصباح.'),
          QuizOptionModel(keyId: 'D', text: 'أصاب بالتوتر والصداع الشديد.', explanation: 'راحة الدماغ تزيل التوتر وتمنحك هدوءاً وثقة كاملة.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'عبقري ومتفوق! النوم المبكر هو السلاح السري للدرجات العالية.',
        gentleFeedbackWrong: 'محاولة طيبة! النوم الكافي هو من يثبت المعلومات ويجعلك تحصد أعلى الدرجات.',
      ),
      const QuizModel(
        situation: 'شعرت بالعطش الخفيف قبل النوم بدقائق:',
        question: 'ما هو المشروب الأفضل الذي يجب اختياره؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'رشفات قليلة من الماء النقي أو حليب دافئ.', explanation: 'الماء أو الحليب الدافئ خيار صحي يريح المعدة ويساعد على الاسترخاء.'),
          QuizOptionModel(keyId: 'B', text: 'عصير صناعي مليء بالصبغات والسكر.', explanation: 'السكريات ترفع الطاقة وتجعلك تتقلب في السرير بصعوبة.'),
          QuizOptionModel(keyId: 'C', text: 'شاي أو قهوة تحتوي على كافيين منبه.', explanation: 'المنبهات تطرد النوم وتسبب الأرق وتسارع ضربات القلب.'),
          QuizOptionModel(keyId: 'D', text: 'شرب لترين كاملين من الماء دفعة واحدة.', explanation: 'شرب كمية معتدلة يكفي ليروي عطشك دون إيقاظك عدة مرات.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'اختيار صحي وذكي! الماء والحليب الدافئ صديقان للنوم الهانئ.',
        gentleFeedbackWrong: 'محاولة جيدة! تجنب السكريات والمنبهات ليلاً يضمن لك نوماً عميقاً.',
      ),
      const QuizModel(
        situation: 'عندما تستيقظ كل صباح بنشاط بعد نوم صحي ومبكر:',
        question: 'ما هو أول شيء تفعله لشحن طاقتك لليوم الجديد؟',
        options: [
          QuizOptionModel(keyId: 'A', text: 'شرب كوب ماء دافئ، غسل الوجه، وتناول فطور صحي ومغذي.', explanation: 'شرب الماء والفطور يوقظان أجهزة جسمك ويمدانك بالطاقة الذهنية والبدنية.'),
          QuizOptionModel(keyId: 'B', text: 'البحث عن الهاتف واللعب بالألعاب الإلكترونية فوراً.', explanation: 'الشاشات عند الاستيقاظ تسبب تشتت الذهن والصداع.'),
          QuizOptionModel(keyId: 'C', text: 'الذهاب للمدرسة دون تناول أي إفطار.', explanation: 'الإفطار وقود دماغك وبدونه تشعر بالخمول في الحصص.'),
          QuizOptionModel(keyId: 'D', text: 'تناول كيس حلوى ومقرمشات مالحة.', explanation: 'الفطور الصحي المتوازن (بيض، حليب، خبز، فاكهة) هو طعام الأبطال.'),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'روتين صباحي أسطوري! أنت الآن مستعد لغزو كل التحديات والانتصار.',
        gentleFeedbackWrong: 'محاولة طيبة! الفطور والماء صباحاً هما طاقة البطل لبدء يومه بقوة.',
      ),
    ],
  };

  /// Generates a complete list of 10 quizzes for any mission by taking base quizzes and expanding them.
  static List<QuizModel> getExpanded10Quizzes(String missionId, String habitName, QuizModel baseQuiz) {
    final direct = _allMissionQuizzes[missionId];
    if (direct != null && direct.length >= 10) {
      return direct;
    }

    final result = <QuizModel>[];
    if (direct != null && direct.isNotEmpty) {
      result.addAll(direct);
    } else {
      result.add(baseQuiz);
    }

    final situations = [
      'واجهت موقفاً في المدرسة يختبر التزامك بعادة ($habitName):',
      'طلب منك أحد أصدقائك أو معلمك تطبيق ($habitName) في نشاط جماعي:',
      'في منزلك مع أسرتك الكريمة، حان وقت إظهار ($habitName):',
      'أثناء وجودك في النادي الرياضي أو الحديقة العامة واجهك تحدٍ يتعلق بـ ($habitName):',
      'كنت بمفردك ولا يراك أحد، كيف تطبق ($habitName) بأمانة وإخلاص؟',
      'اقترح أحد الزملاء فكرة تخالف عادة ($habitName)، كيف تتصرف بحكمة؟',
      'حققت نجاحاً بفضل التزامك بـ ($habitName)، ما هي الخطوة القادمة؟',
      'واجهتك صعوبة بسيطة في الاستمرار على ($habitName)، ما هو قرار القائد؟',
      'كيف تلهم الصغار وأصدقاءك ليتعلموا منك عادة ($habitName) الجميلة؟',
      'في نهاية اليوم وأنت تفكر في إنجازاتك مع عادة ($habitName):',
    ];

    while (result.length < 10) {
      final index = result.length;
      final sit = situations[index % situations.length];

      result.add(QuizModel(
        situation: sit,
        question: 'ما هو التصرف الأكثر نضجاً وإيجابية كبطل GLOW؟',
        options: [
          QuizOptionModel(
            keyId: 'A',
            text: 'أختار التصرف السليم دائماً وألتزم بـ $habitName بحماس واعتزاز.',
            explanation: 'تصرف القادة الأبطال! الالتزام بالعادات الإيجابية يصنع مستقبلك المشرق.',
          ),
          QuizOptionModel(
            keyId: 'B',
            text: 'أتجاهل الأمر وأتصرف بعشوائية دون اهتمام.',
            explanation: 'الإهمال يضيع عليك فرصة كسب ثقة الآخرين وتطوير شخصيتك.',
          ),
          QuizOptionModel(
            keyId: 'C',
            text: 'أقوم بالسلوك العكسي وأشجع غيري على الخطأ.',
            explanation: 'تشجيع السلوك السلبي يضر بالجميع وليس من شيم الأبطال.',
          ),
          QuizOptionModel(
            keyId: 'D',
            text: 'أستسلم فوراً وأقول أنا لا أستطيع الالتزام.',
            explanation: 'أنت قادر ومميز، وبالمحاولة اليومية تصبح العادة سهلة وطبيعية.',
          ),
        ],
        correctKeyId: 'A',
        encouragementCorrect: 'بطل العادات والقيم! اختيارك السليم يرفع قدرك دائماً.',
        gentleFeedbackWrong: 'محاولة جميلة! تذكر أن العادة الإيجابية تصنع شخصيتك القوية كل يوم.',
      ));
    }

    return result;
  }
}
