import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/database/hive_keys.dart';
import '../models/child_models.dart';
import 'world1_quizzes_data.dart';

/// Interactive 3D character component.
class ChildRepository {
  static final List<WorldModel> _defaultWorlds = [
    WorldModel(
      worldNumber: 1,
      name: 'غابة البدايات',
      description: 'عالم استكشاف العادات الأساسية: الثقة بالنفس، التعاون، النظافة، الصدق، والنوم المبكر.',
      worldColor: AppColors.mintGreen,
      isPremium: false,
      missions: [
        MissionModel(
          id: 'w1_m1',
          number: 1,
          title: 'شجاعة الصباح',
          habitName: 'الثقة بالنفس',
          habitDescription: 'الاعتزاز بالقدرات الشخصية والتعبير عن الرأي بوضوح وأدب.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'مرحباً بك يا بطلي! أنا PORT رفيقك وقائد رحلتك في غابة البدايات. اليوم سنكتشف قوة الثقة بالنفس والاعتزاز بقدراتنا.',
              sceneDescription: 'يقف PORT في مدخل الغابة الخضراء المشرقة ملوحاً بحماس لبدء الرحلة.',
              backgroundTheme: 'forest_day',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'FORT',
              dialogue: 'أنا FORT وأحب المغامرات! عندما ننظر للأمام بشجاعة وابتسامة، تصبح كل التحديات سهلة وممتعة.',
              sceneDescription: 'FORT يقفز بنشاط مشجعاً على المضي قدماً.',
              backgroundTheme: 'forest_bridge',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'PORT',
              dialogue: 'واجهنا جسراً خشبياً فوق النهر الهادئ. بالإرادة والهدوء نتجاوز كل خطوة بثقة ونجاح نحو القمة.',
              sceneDescription: 'جسر خشبي أنيق يمتد بين ضفتي النهر العذب.',
              backgroundTheme: 'forest_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'طلب المعلم في الصف مشاركة فكرة جديدة، وأنت لديك فكرة جميلة لكنك متردد:',
            question: 'ما هو التصرف الأكثر ثقة وإيجابية؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أرفع يدي بأدب وأشارك فكرتي بثقة وابتسامة.',
                explanation: 'رائع جداً! رفع اليد والمشاركة يعبر عن الثقة والحرص على التعلم.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'ألتزم الصمت التام ولا أتحدث أبداً.',
                explanation: 'الصمت يحرمك ويحرم أصدقاءك من الاستفادة من أفكارك الرائعة.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أطلب من زميلي أن يتكلم بدلاً عني.',
                explanation: 'صوتك وفكرتك مميزان جداً ويستحقان أن تعبر عنهما بنفسك.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أغلق دفاتري وأتجاهل الدرس.',
                explanation: 'تجاهل الدرس يضيع عليك فرصة التعلم والتألق في الصف.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'برافوو يا بطل! أحسنت الاختيار، الثقة بالنفس تصنع القادة دائماً.',
            gentleFeedbackWrong: 'محاولة جميلة! تذكر دائماً أن مشاركة أفكارك بجرأة وأدب هي سر النجاح والتفوق.',
          ),
        ),
        MissionModel(
          id: 'w1_m2',
          number: 2,
          title: 'يد واحدة في الحديقة',
          habitName: 'التعاون والمشاركة',
          habitDescription: 'مساعدة الأصدقاء والعائلة والعمل بروح الفريق الواحد.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'أهلاً بك مجدداً! اليوم يحتاج أصدقاؤنا إلى زراعة أزهار جديدة وترتيب حديقة الغابة الجميلة.',
              sceneDescription: 'حديقة واسعة تحتاج لترتيب وغرس الشتلات الملونة.',
              backgroundTheme: 'garden_start',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'MORT',
              dialogue: 'أنا MORT أحب العطف والمساعدة! عندما نضع أيدينا معاً يصبح العمل الشاق نزهة ممتعة ومليئة بالفرح.',
              sceneDescription: 'MORT يساعد في حمل الماء برفق ومحبة.',
              backgroundTheme: 'garden_work',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'QORT',
              dialogue: 'وأنا QORT الحكيم أقول لكم: التعاون يبني أجمل الحدائق وأقوى الصداقات التي تدوم طويلاً.',
              sceneDescription: 'QORT يشير إلى الأزهار المتفتحة بجمال.',
              backgroundTheme: 'garden_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'وجدت زميلك يحمل كتباً ثقيلة سقط بعضها على الأرض في ساحة المدرسة:',
            question: 'كيف تتصرف بمسؤولية وروح تعاون؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أبادر بابتسامة وأساعده في جمع الكتب وحمل جزء منها.',
                explanation: 'تصرف نبيل يعكس المروءة وحب الخير للآخرين.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أمر من جانبه مسرعاً دون أن أنظر إليه.',
                explanation: 'تجاهل المحتاج يقلل من روح الأخوة والتعاون.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أضحك على الموقف وأواصل المشي.',
                explanation: 'الضحك على تعثر الآخرين سلوك غير لائق ويجرح المشاعر.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أنتظر حتى يطلب مني ذلك بصوت عالٍ.',
                explanation: 'المبادرة الذاتية للمساعدة تصنع الصداقات الحقيقية.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'ما أجمل تعاونك! أنت صديق يعتمد عليه في كل الأوقات.',
            gentleFeedbackWrong: 'محاولة طيبة! تذكر دائماً أن مساعدة غيرك تنشر المحبة وتجعل يومك أجمل.',
          ),
        ),
        MissionModel(
          id: 'w1_m3',
          number: 3,
          title: 'بريق الماء النقي',
          habitName: 'النظافة والترتيب',
          habitDescription: 'الحفاظ على نظافة الجسم، المكان، وترتيب الأدوات اليومية.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'وصلنا إلى واحة الينابيع النقية! النظافة تمنحنا الانتعاش والصحة وتحمينا من الأمراض.',
              sceneDescription: 'ينبوع ماء كريستالي صافٍ تتراقص حوله قطرات الندى.',
              backgroundTheme: 'spring_water',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'FORT',
              dialogue: 'غسل اليدين بالماء والصابون وترتيب غرفتنا يجعلنا نشعر بالطاقة والقوة في كل صباح!',
              sceneDescription: 'FORT يغسل يديه بسعادة تحت الينبوع.',
              backgroundTheme: 'spring_clean',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'MORT',
              dialogue: 'المكان النظيف يعكس جمال قلوبنا. لنحافظ دائماً على نظافة بيئتنا وأدواتنا لتبدو لامعة.',
              sceneDescription: 'MORT يبتسم مشيراً للمكان المرتب والنظيف.',
              backgroundTheme: 'spring_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'بعد الانتهاء من تناول وجبة الغداء اللذيذة مع الأسرة:',
            question: 'ما هي الخطوة الأفضل؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أساعد في رفع طبقي وأغسل يدي وفمي بالماء والصابون.',
                explanation: 'أحسنت! هذا قمة النظافة والبر بالوالدين وحسن السلوك.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أترك الصحن على الطاولة وأركض للشاشة فوراً.',
                explanation: 'ترك الصحن يسبب الفوضى ويزيد العبء على أسرتك.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أمسح يدي بملابسي دون غسيل.',
                explanation: 'مسح اليد بالملابس ينقل الجراثيم ويتلف الثياب.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أنسى غسل فمي ويدي تماماً.',
                explanation: 'غسل اليدين يحميك من البكتيريا والجراثيم.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'بطل نظيف ومنظم! النظافة عنوان الرقي والأناقة دائماً.',
            gentleFeedbackWrong: 'محاولة جيدة! النظافة الشخصية والمساعدة المنزلية تجعل صحتنا وبيئتنا أفضل.',
          ),
        ),
        MissionModel(
          id: 'w1_m4',
          number: 4,
          title: 'كلمة الحق',
          habitName: 'الصدق والأمانة',
          habitDescription: 'قول الحقيقة دائماً بشجاعة والاعتراف بالخطأ والحرص على الأمانة.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'الصدق شجاعة حقيقية، وقول الحقيقة ينير دربنا ويبني ثقة الناس بنا دائماً.',
              sceneDescription: 'شجرة الصدق الوارفة تتلألأ بثمار المعرفة.',
              backgroundTheme: 'truth_tree',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'MORT',
              dialogue: 'حتى لو أخطأنا، فالاعتراف بالخطأ بصدق ولطف يجعلنا أبطالاً حقيقيين محبوبين لدى الجميع.',
              sceneDescription: 'MORT يشجع بحنان على قول الحق.',
              backgroundTheme: 'truth_speak',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'FORT',
              dialogue: 'الصدق كنز لا يفنى، ومن يقل الصدق يعش مرتاح البال ومرفوع الرأس بين أصدقائه.',
              sceneDescription: 'FORT يرفع شعلة الأمانة المضيئة.',
              backgroundTheme: 'truth_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'كسرت كأساً بالخطأ أثناء اللعب في الصالة:',
            question: 'كيف تتصرف بصدق وشجاعة؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أخبر والدي بالحقيقة وأعتذر بلطف وأساعد في تنظيف المكان بحذر.',
                explanation: 'ممتاز! الاعتراف بالخطأ شجاعة والصدق ينجي دائماً ويبني الثقة.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أخفي الزجاج تحت السجادة أو وراء الأريكة.',
                explanation: 'إخفاء الزجاج قد يؤذي أحداً ويعد سلوكاً غير صادق.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أقول أن القطة أو أخي الصغير هو من فعل ذلك.',
                explanation: 'إلقاء اللوم على الآخرين خطأ يضعف الثقة بك وبشخصيتك.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أنكر معرفتي بالأمر وأغضب.',
                explanation: 'الإنكار لا يحل المشكلة بل يزيدها تعقيداً.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'أنت بطل حقيقي وصادق! الصدق يرفع من قدرك بين الجميع دائماً.',
            gentleFeedbackWrong: 'محاولة طيبة! تذكر أن قول الحقيقة بجرأة وأدب يمنحك احترام الجميع.',
          ),
        ),
        MissionModel(
          id: 'w1_m5',
          number: 5,
          title: 'أحلام النجوم',
          habitName: 'النوم المبكر والنشاط',
          habitDescription: 'تنظيم مواعيد النوم للاستيقاظ بنشاط وطاقة متجددة.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'عندما يحل المساء، يحتاج جسمنا وعقلنا للراحة لينمو ويكتسب القوة ليوم جديد مليء بالمغامرات!',
              sceneDescription: 'سماء هادئة مليئة بالنجوم المضيئة والقمر المبتسم.',
              backgroundTheme: 'starry_night',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'QORT',
              dialogue: 'النوم المبكر ينظم دقات القلب ويصفي الذهن لنستيقظ في الصباح بكامل الذكاء والتركيز.',
              sceneDescription: 'QORT ينظر للنجوم ويشرح أهمية راحة العقل.',
              backgroundTheme: 'starry_rest',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'PORT',
              dialogue: 'أغمض عينيك الليلة بابتسامة، فالغد ينتظرك بمغامرات أروع وأجمل يا صديقي البطل!',
              sceneDescription: 'PORT يلوح متمنياً نوماً هنيئاً وأحلاماً سعيدة.',
              backgroundTheme: 'starry_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'حان وقت النوم المحدد لك ولديك غداً مغامرة مدرسية شيقة:',
            question: 'ما هو القرار الأنسب؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أغلق الشاشات وأفرش أسناني وأذهب لسريري في الوقت المحدد.',
                explanation: 'رائع جداً! النوم الصحي يمنحك ذكاءً ونشاطاً استثنائياً.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أسهر لساعات متأخرة ألعب بالأجهزة.',
                explanation: 'السهر يسبب التعب وضعف التركيز في اليوم التالي.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أشرب مشروبات سكرية ومشروبات غازية قبل النوم.',
                explanation: 'السكريات قبل النوم تزعج نومك وتؤذي أسنانك.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أرفض النوم حتى الصباح.',
                explanation: 'النوم غير المنتظم يضر بصحتك ونموك البدني.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'أحسنت يا بطل! النوم المبكر يصنع الأبطال الأذكياء.',
            gentleFeedbackWrong: 'محاولة جميلة! راحة الجسم ضرورية لتستيقظ بكامل طاقتك وإبداعك.',
          ),
        ),
        MissionModel(
          id: 'w1_m6',
          number: 6,
          title: 'احترام المواعيد',
          habitName: 'إدارة الوقت والالتزام',
          habitDescription: 'الحرص على أداء المهام في أوقاتها المحددة واحترام وقت الآخرين.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'الوقت كنز ثمين يا أصدقائي! والالتزام بالمواعيد يعكس احترامنا لأنفسنا وللآخرين.',
              sceneDescription: 'ساعة الغابة الكبيرة تدق بنغمات موسيقية منظمة.',
              backgroundTheme: 'clock_tower',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'FORT',
              dialogue: 'عندما ننجز واجباتنا أولاً في وقتها المحدد، نجد متسعاً كبيراً للعب والمرح دون قلق!',
              sceneDescription: 'FORT يرتب جدول أعماله اليومي بنشاط.',
              backgroundTheme: 'clock_schedule',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'QORT',
              dialogue: 'البطل الناجح هو من يقدر كل دقيقة ويجعل يومه مليئاً بالإنجاز والابتسامة.',
              sceneDescription: 'QORT يقف بثقة بجوار الساعة الذهبية.',
              backgroundTheme: 'clock_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'لديك واجب مدرسي وموعد لمشاهدة برنامجك المفضل:',
            question: 'كيف تنظم وقتك بذكاء؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أنهي واجبي بتركيز أولاً، ثم استمتع بمشاهدة برنامجي براحة بال.',
                explanation: 'أحسنت! إنجاز الأولويات أولاً هو أساس النجاح والتفوق.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أشاهد التلفاز وأؤجل الواجب حتى الصباح الباكر.',
                explanation: 'التأجيل يسبب التوتر وعدم إتقان العمل.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أترك واجبي تماماً وألعب طول اليوم.',
                explanation: 'إهمال الواجبات يقلل من تحصيلك العلمي.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أكتب بسرعة وعشوائية أثناء المشاهدة.',
                explanation: 'تشتيت الانتباه يسبب الأخطاء وضعف الفهم.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'بطل منظم ورائع! إدارة الوقت سر من أسرار العباقرة.',
            gentleFeedbackWrong: 'محاولة طيبة! تذكر أن إنهاء المهام أولاً يمنحك راحة وسعادة حقيقية.',
          ),
        ),
        MissionModel(
          id: 'w1_m7',
          number: 7,
          title: 'طاقة الغذاء الصحي',
          habitName: 'التغذية السليمة وشرب الماء',
          habitDescription: 'تناول الخضروات والفواكه وشرب الماء النقي لبناء جسم قوي ومناعة عالية.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'شجرة الفواكه الملونة ترحب بنا! الأكل الصحي يمد عضلاتنا بالقوة وعقولنا بالذكاء.',
              sceneDescription: 'بستان مليء بالأشجار المثمرة بالتفاح والبرتقال والموز.',
              backgroundTheme: 'orchard_start',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'MORT',
              dialogue: 'الخضار الطازجة وشرب الماء النقي بانتظام يحمي جسمنا ويمنحنا نشاطاً لا ينتهي.',
              sceneDescription: 'MORT يوزع سلال الفواكه اللذيذة بحب.',
              backgroundTheme: 'orchard_fruits',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'FORT',
              dialogue: 'ابتعد عن السكريات الزائدة واختر دائماً طعام الأبطال لتكون الأقوى والأسرع في كل تحدٍ!',
              sceneDescription: 'FORT يركض بحيوية وطاقة عالية بين الأشجار.',
              backgroundTheme: 'orchard_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'شعرت بالعطش والجوع الخفيف بين الوجبات:',
            question: 'ما هو الخيار الأكثر صحة لجسمك؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أشرب كوباً من الماء النقي وأتناول تفاحة أو موزة طازجة.',
                explanation: 'اختيار عبقري! الفواكه والماء تمنحك فيتامينات وطاقة طبيعية نقية.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أشرب مشروباً غازياً مليئاً بالسكريات.',
                explanation: 'المشروبات الغازية تضر الأسنان والمعدة.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'آكل حلوى مصنعة ملونة ومقرمشات ضارة.',
                explanation: 'الحلويات الزائدة تسبب الخمول وتضعف المناعة.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أهمل شرب الماء تماماً.',
                explanation: 'الماء ضروري جداً لترطيب الجسم وصحة العقل.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'يا لك من بطل صحي وذكي! غذاؤك الصحي يبني مستقبلك القوي.',
            gentleFeedbackWrong: 'محاولة طيبة! تذكر دائماً أن صحتك أمانة وغذاءك النظيف هو طاقتك الحقيقية.',
          ),
        ),
        MissionModel(
          id: 'w1_m8',
          number: 8,
          title: 'كنز الكلمات الطيبة',
          habitName: 'اللباقة والحديث الإيجابي',
          habitDescription: 'استخدام الكلمات المهذبة والثناء على الآخرين والابتعاد عن الألفاظ السيئة.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'الكلمة الطيبة كشجرة وارفة، تنشر الفرح في كل مكان وتصنع أصدقاء أوفياء في كل خطوة.',
              sceneDescription: 'وادي الصدى المضيء يردد الكلمات الجميلة بنغمات رائعة.',
              backgroundTheme: 'kind_words_start',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'QORT',
              dialogue: 'استخدام عبارات مثل شكراً، ومن فضلك، ولو سمحت تفتح لك القلوب وتجعلك مميزاً ومحبوباً.',
              sceneDescription: 'QORT يبتسم وينصح بلباقة وحكمة.',
              backgroundTheme: 'kind_words_echo',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'MORT',
              dialogue: 'عندما نتحدث بلطف وهدوء، نصبح قدوة حسنة ونسعد عائلتنا ومعلمينا في كل لحظة.',
              sceneDescription: 'MORT يعانق أصدقاءه بمودة ولطف.',
              backgroundTheme: 'kind_words_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'أعطاك صديقك أو والدك شيئاً جميلاً طلبته منه:',
            question: 'ما هي الكلمة الأجمل لتقولها؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أبتسم وأقول: شكراً جزيلاً لك، جزاك الله خيراً.',
                explanation: 'سلوك رفيع يعبر عن التقدير والامتنان ومكارم الأخلاق.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'آخذ الشيء دون أن أتكلم أو أنظر إليه.',
                explanation: 'عدم الشكر يقلل من المودة بين الناس.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أقول: هذا أقل مما أردت، وأتذمر.',
                explanation: 'التذمر يجرح مشاعر من يحاول إسعادك.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أرمي الشيء على الأرض بإهمال.',
                explanation: 'إهمال الهدايا سلوك غير لائق.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'ما أجمل لسانك وأخلاقك! صاحب الكلمات الطيبة محبوب من الجميع دائماً.',
            gentleFeedbackWrong: 'محاولة جميلة! تذكر أن الشكر والامتنان ينشران المحبة في كل مكان.',
          ),
        ),
        MissionModel(
          id: 'w1_m9',
          number: 9,
          title: 'حماية الطبيعة الخضراء',
          habitName: 'المحافظة على البيئة والأشجار',
          habitDescription: 'وضع المهملات في مكانها المخصص، وترشيد استهلاك الورق والمياه، والعناية بالنباتات.',
          rewardStars: 3,
          rewardPoints: 150,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'انظروا إلى جمال هذه الغابة والورود المتفتحة! مسؤوليتنا جميعاً الحفاظ على بيئتنا نقية وجميلة.',
              sceneDescription: 'مرج أخضر واسع تتفتح فيه الزهور البرية وتغرد العصافير.',
              backgroundTheme: 'nature_start',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'FORT',
              dialogue: 'رمي المهملات في سلتها المخصصة وعدم قطف الأزهار يحفظ بيئتنا للأجيال القادمة لتستمتع بها.',
              sceneDescription: 'FORT يضع عبوة في صندوق إعادة التدوير بحماس.',
              backgroundTheme: 'nature_recycle',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'MORT',
              dialogue: 'النباتات كائنات حية تمنحنا الأكسجين والجمال، لنعتنِ بها ونسقِها بالماء والاهتمام المستمر.',
              sceneDescription: 'MORT يسقي شتلة صغيرة بحنان.',
              backgroundTheme: 'nature_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'كنت في نزهة بالحديقة العامة وانتهيت من تناول وجبة خفيفة:',
            question: 'أين تضع غلاف الطعام والعلبة الفارغة؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أجمع كل المخلفات وأضعها في سلة المهملات المخصصة.',
                explanation: 'بطل بيئي حقيقي! نظافة الأماكن العامة مسؤولية وواجب يعكس وعيك.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أتركها على العشب الأخضر وأغادر.',
                explanation: 'ترك المهملات يشوه الطبيعة ويؤذي الحيوانات والزوار.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أرميها في بركة الماء أو تحت الشجرة.',
                explanation: 'تلويث المياه والأشجار يضر بالبيئة والكائنات الحية.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أدفنها في التراب عشوائياً.',
                explanation: 'البلاستيك لا يتحلل ويؤذي التربة الزراعية.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'بطل البيئة الرائع! بفضلك تظل مدينتنا وغاباتنا جنة خضراء جميلة.',
            gentleFeedbackWrong: 'محاولة طيبة! تذكر دائماً أن النظافة العامة مظهر حضاري وشارة للأبطال.',
          ),
        ),
        MissionModel(
          id: 'w1_m10',
          number: 10,
          title: 'تحدي القائد الشجاع',
          habitName: 'المثابرة والتفوق',
          habitDescription: 'مواصلة المحاولة وعدم الاستسلام والوصول إلى الأهداف بثبات واعتزاز.',
          rewardStars: 3,
          rewardPoints: 200,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'مرحى! لقد وصلنا إلى قمة جبل البدايات بعد رحلة رائعة مليئة بالتعلم والعادات العظيمة.',
              sceneDescription: 'قمة جبل شاهقة تطل على غابة البدايات كاملة تحت أشعة الشمس الذهبية.',
              backgroundTheme: 'summit_start',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'FORT',
              dialogue: 'الصبر والمثابرة هما سر الوصول إلى القمة! لم نستسلم أمام أي عائق حتى حققنا هدفنا بجدارة.',
              sceneDescription: 'FORT يرفع راية النصر والتفوق عالياً.',
              backgroundTheme: 'summit_flag',
            ),
            StorySceneModel(
              sceneIndex: 2,
              speakerName: 'MORT',
              dialogue: 'والآن أصبحت تمتلك عادات القادة العظماء: الصدق، النظافة، التعاون، واحترام الوقت والمواعيد.',
              sceneDescription: 'MORT يصفق بفخر واعتزاز بالبطل الصغير.',
              backgroundTheme: 'summit_cheer',
            ),
            StorySceneModel(
              sceneIndex: 3,
              speakerName: 'QORT',
              dialogue: 'فخورون بك جميعاً يا بطل GLOW! استعد الآن للحصول على وسام غابة البدايات الذهبي والانطلاق للعالم التالي!',
              sceneDescription: 'QORT يمسك بالوسام الذهبي اللامع وسط احتفال أبطال GLOW.',
              backgroundTheme: 'summit_trophy',
            ),
          ],
          quiz: QuizModel(
            situation: 'واجهتك مسألة رياضية أو لعبة تركيب صعبة ولم تنجح من أول محاولة:',
            question: 'ما هو تصرف القائد المثابر؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أهدأ، وأفكر بطريقة جديدة، وأحاول مرة بعد أخرى حتى أنجح بتفوق.',
                explanation: 'هذه عقلية الأبطال! الإصرار والمحاولة هما طريق كل نجاح واكتشاف عظيم.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أغضب وأرمي اللعبة أو الورقة وأستسلم.',
                explanation: 'الاستسلام يحرمك من متعة الفوز والتعلم.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أقول: أنا لا أستطيع فعل أي شيء مفيد.',
                explanation: 'أنت قادر ومميز، وكل محاولة تزيدك ذكاءً وخبرة.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أطلب من شخص آخر حلها لي بالكامل دون أن أحاول.',
                explanation: 'الاعتماد الكلي على الآخرين يمنعك من تطوير مهاراتك الذاتية.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'يا لك من قائد عبقري ومثابر! قمة المجد تليق بك دائماً يا بطل.',
            gentleFeedbackWrong: 'محاولة رائعة! تذكر أن كل فشل هو خطوة نحو النجاح إذا واصلت المحاولة بإصرار.',
          ),
        ),
      ],
    ),

    WorldModel(
      worldNumber: 2,
      name: 'محيط المشاعر',
      description: 'عالم فهم المشاعر والذكاء العاطفي: إدارة الغضب، التعبير عن النفس، التعاطف، الصبر، والشجاعة الأدبية.',
      worldColor: AppColors.primaryBlue,
      isPremium: false,
      missions: [
        MissionModel(
          id: 'w2_m1',
          number: 1,
          title: 'هدوء الأمواج',
          habitName: 'إدارة الغضب وضبط النفس',
          habitDescription: 'التحكم في الانفعالات والتنفس بعمق عند مواجهة المواقف الصعبة.',
          rewardStars: 3,
          rewardPoints: 160,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'أهلاً بك في محيط المشاعر! معي صديقنا MORT الذي يعلمنا العطف والهدوء.',
              sceneDescription: 'شاطئ هادئ بأمواج زرقاء رقراقة ونسمات عليلة.',
              backgroundTheme: 'ocean_shore',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'MORT',
              dialogue: 'عندما تغضب، تنفس بعمق 3 مرات كما تهدأ أمواج البحر، وسترى كل شيء بوضوح!',
              sceneDescription: 'MORT يتنفس بهدوء مع حركة الأمواج.',
              backgroundTheme: 'ocean_calm',
            ),
          ],
          quiz: QuizModel(
            situation: 'أثناء لعب مباراة مع أصدقائك خسرت جولتك وشعرت بالانزعاج:',
            question: 'ما هو التصرف الأكثر نضجاً وهدوءاً؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'آخذ نفساً عميقاً، أهنئ الفائز، وأحاول مرة أخرى بروح رياضية.',
                explanation: 'هذا سلوك الأبطال الكبار! الروح الرياضية تصنع الفوز الحقيقي.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أصرخ وأرمي الكرة بعيداً وأغادر غاضباً.',
                explanation: 'الصراخ يفسد اللعبة ويحرمك من متعة المشاركة.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أتشاجر مع الحكم أو زميلي.',
                explanation: 'الشجار يؤذي الأصدقاء ويفقدك احترام الآخرين.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أمتنع عن اللعب معهم إلى الأبد.',
                explanation: 'الانسحاب لا يحل المشكلة بل يعزلك عن أصدقائك.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'يا لك من بطل شجاع وصبور! ضبط النفس يصنع بطل الغد.',
            gentleFeedbackWrong: 'محاولة طيبة! تذكر أن كل خسارة هي فرصة للتعلم والتفوق القادم.',
          ),
        ),
        MissionModel(
          id: 'w2_m2',
          number: 2,
          title: 'صوت القلب',
          habitName: 'التعبير عن المشاعر بوضوح',
          habitDescription: 'شرح ما نشعر به بالكلمات دون عنف أو صمت مؤذٍ.',
          rewardStars: 3,
          rewardPoints: 160,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'MORT',
              dialogue: 'عندما نشعر بالحزن أو الخوف، أفضل حل هو الحديث مع من نحب بصراحة وطمأنينة.',
              sceneDescription: 'منارة المشاعر المضيئة ترسل أنوار الأمان.',
              backgroundTheme: 'ocean_lighthouse',
            ),
          ],
          quiz: QuizModel(
            situation: 'شعرت بالقلق أو الخوف من تجربة جديدة لأول مرة:',
            question: 'ما هو التصرف الصحي؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أتحدث مع أمي أو أبي أو معلمي وأخبرهم بما أشعر به بوضوح.',
                explanation: 'التحدث مع الكبار يريح قلبك ويوفر لك الدعم والحلول.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أكتم خوفي في قلبي وأبكي وحدي في الغرفة.',
                explanation: 'الكتمان يزيد من التوتر، والحديث يفرّج عن النفس.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أغضب على من حولي بدون سبب.',
                explanation: 'تفريغ الخوف في الغضب يؤذي مشاعر من يحبونك.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أهرب من المدرسة أو التجربة.',
                explanation: 'الهروب لا يزيل الخوف بل يجعله أكبر.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'أنت شجاع ومدرك لمشاعرك! التعبير الصادق يمنحك راحة وقوة.',
            gentleFeedbackWrong: 'محاولة طيبة! مشاركة مشاعرك مع من تثق بهم هي أول خطوة للأمان.',
          ),
        ),
        MissionModel(
          id: 'w2_m3',
          number: 3,
          title: 'مرآة القلوب',
          habitName: 'التعاطف والاهتمام بالآخرين',
          habitDescription: 'الإحساس بمشاعر الآخرين ومساندتهم عند الحاجة.',
          rewardStars: 3,
          rewardPoints: 160,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'MORT',
              dialogue: 'التعاطف هو أن تضع نفسك مكان صديقك لتشعر به وتهتم لأمره بحب ولطف.',
              sceneDescription: 'حلقة الأصدقاء في واحة المشاعر الدافئة.',
              backgroundTheme: 'ocean_empathy',
            ),
          ],
          quiz: QuizModel(
            situation: 'رأيت صديقك حزيناً لأن درجاته لم تكن كما تمنى:',
            question: 'كيف تسانده بعطف واهتمام؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أجلس بجانبه، أواسيه، وأشجعه على المذاكرة سوياً للمرة القادمة.',
                explanation: 'قمة النبل والوفاء! الصديق الحقيقي يساند في الأوقات الصعبة.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أتفاخر بدرجاتي العالية أمامه.',
                explanation: 'التفاخر يجرح مشاعره ويزيد من حزنه.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أسخر من خطئه أمام بقية الطلاب.',
                explanation: 'السخرية تصرف سيء يفرق بين الأصدقاء.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أتجاهله تماماً وأبتعد عنه.',
                explanation: 'ترك الصديق في حزنه يضعف روابط الصداقة.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'قلب طيب وصديق وفي! العطف ينشر المحبة في كل مكان.',
            gentleFeedbackWrong: 'محاولة جيدة! مساندة أصدقائك بكلمة طيبة تصنع فرقاً كبيراً.',
          ),
        ),
        MissionModel(
          id: 'w2_m4',
          number: 4,
          title: 'صبر اللؤلؤ',
          habitName: 'الصبر والانتظار الجميل',
          habitDescription: 'احترام الدور والانتظار دون تذمر أو مقاطعة.',
          rewardStars: 3,
          rewardPoints: 160,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'اللؤلؤة تتكون بصبر داخل المحار، وكذلك العادات العظيمة تنمو بالصبر!',
              sceneDescription: 'مغارة اللؤلؤ تتلألأ بأنوار الصبر والجمال.',
              backgroundTheme: 'ocean_pearl',
            ),
          ],
          quiz: QuizModel(
            situation: 'أنت في طابور المقصف المدرسي أو الألعاب وتريد الوصول بسرعة:',
            question: 'ما هو السلوك المحترم والصبور؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أنتظر دوري بهدوء واحترام دون دفع أو تجاوز للآخرين.',
                explanation: 'احترام الدور يعكس الرقي وحسن التربية والنظام.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أدفع من أمامي لآخذ مكانه بالقوة.',
                explanation: 'الدفع تصرف غير لائق قد يؤذي الآخرين.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أصرخ على البائع ليعطيني أولاً.',
                explanation: 'الصراخ يقلل من احترامك لنفسك وللآخرين.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أخرج من الطابور غاضباً وألقي طعامي.',
                explanation: 'الغضب لا يوفر لك ما تريده بل يضيع وقتك.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'صبور ومنظم! احترام الأدوار سمة الأبطال والناجحين.',
            gentleFeedbackWrong: 'محاولة طيبة! الصبر في الطابور يصنع مجتمعاً منظماً وجميلاً.',
          ),
        ),
        MissionModel(
          id: 'w2_m5',
          number: 5,
          title: 'شجاعة الحق',
          habitName: 'الشجاعة الأدبية والاعتذار',
          habitDescription: 'الاعتراف بالخطأ بجرأة وتقديم الاعتذار الصادق.',
          rewardStars: 3,
          rewardPoints: 160,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'الشجاعة ليست في عدم الخطأ، بل في الاعتراف به والاعتذار الصادق وإصلاحه!',
              sceneDescription: 'قوس قزح يرتفع فوق مياه المحيط بعد انتهاء العاصفة.',
              backgroundTheme: 'ocean_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'أخطأت وتسببت في مضايقة أخيك أو زميلك عن غير قصد:',
            question: 'كيف تتصرف بشجاعة أدبية؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أنظر في عينيه وأقول: "أعتذر منك بصدق، لم أقصد إيذاءك".',
                explanation: 'الاعتذار الصادق يزيل كل الخلافات ويزيدك رفعة.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أكابر وأقول: "أنت السبب في كل ما حدث".',
                explanation: 'المكابرة تزيد الخلاف وتفقدك أصدقاءك.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أبتسم بسخرية وأتركه.',
                explanation: 'الاستهزاء بمشاعر الغير تصرف مؤذٍ.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أختبئ ولا أتحدث معه مجدداً.',
                explanation: 'الهروب لا يصلح الخطأ بل يعقده.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'أنت بطل شجاع وصادق! الاعتذار خلق الكبار والأقوياء.',
            gentleFeedbackWrong: 'محاولة جميلة! الاعتذار يداوي القلوب ويعيد المحبة بسرعة.',
          ),
        ),
      ],
    ),

    WorldModel(
      worldNumber: 3,
      name: 'جبال التحديات',
      description: 'عالم مواجهة الصعاب وبناء العزيمة: حل المشكلات، المثابرة، الدفاع عن الحق، مواجهة المخاوف، والاستقلالية.',
      worldColor: AppColors.coralOrange,
      isPremium: false,
      missions: [
        MissionModel(
          id: 'w3_m1',
          number: 1,
          title: 'قمة الإصرار',
          habitName: 'المثابرة وعدم الاستسلام',
          habitDescription: 'مواصلة المحاولة بثبات حتى بلوغ الهدف والنجاح.',
          rewardStars: 3,
          rewardPoints: 170,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'مرحباً بك في جبال التحديات! معي صديقنا FORT ديناصور القوة والشجاعة.',
              sceneDescription: 'جبال صخرية شاهقة تضيئها شمس العزيمة.',
              backgroundTheme: 'mountain_base',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'FORT',
              dialogue: 'كل خطوة للأعلى تقربنا من القمة! لا نستسلم أمام الصعاب بل نتعلم من كل عثرة.',
              sceneDescription: 'FORT يتسلق الصخور بقوة وثقة ويشجع رفاقه.',
              backgroundTheme: 'mountain_climb',
            ),
          ],
          quiz: QuizModel(
            situation: 'واجهت مسألة صعبة في واجبك واستغرقت وقتاً طويلاً:',
            question: 'ما هو قرار بطل التحديات؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أحاول مجدداً بطرق مختلفة، وإذا احتجت أسأل معلمي أو والدي بإصرار.',
                explanation: 'المثابرة سر كل تفوق ونجاح دراسي وعملي.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أمزق الورقة وأقول أنا لا أستطيع.',
                explanation: 'الاستسلام يحرمك من متعة الوصول للحل.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أنقل الحل مباشرة دون أن أفهم.',
                explanation: 'النقل دون فهم يضعف مهاراتك الذاتية.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أترك الواجب فارغاً وأنام.',
                explanation: 'الإهمال يضيع عليك فرصة التميز.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'بطل مثابر وقوي! عزيمتك ستصل بك إلى أعلى القمم.',
            gentleFeedbackWrong: 'محاولة طيبة! بالمحاولة المتكررة تصبح أصعب المسائل سهلة وممتعة.',
          ),
        ),
        MissionModel(
          id: 'w3_m2',
          number: 2,
          title: 'مفتاح الحل الذكي',
          habitName: 'التفكير في حل المشكلات',
          habitDescription: 'البحث عن بدائل إيجابية وحلول عملية بهدوء.',
          rewardStars: 3,
          rewardPoints: 170,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'FORT',
              dialogue: 'القوة الحقيقية هي في استخدام العقل للبحث عن مخرج وحل لكل عقبة!',
              sceneDescription: 'طريق مقطوع بصخرة، ويبحث الأبطال عن مسار بديل آمن.',
              backgroundTheme: 'mountain_path',
            ),
          ],
          quiz: QuizModel(
            situation: 'نسيت كراسة الرسم في البيت ولديك حصة فنية الآن:',
            question: 'كيف تحل الموقف بذكاء؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أستأذن معلمي بلطف لاستخدام ورقة بيضاء إضافية وأرسم عليها بجد.',
                explanation: 'طلب المساعدة بأدب يعكس التفكير العملي السريع.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أبكي وأرفض المشاركة في الحصة.',
                explanation: 'البكاء لا يوفر كراسة بل يضيع وقت الدرس.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'آخذ كراسة زميلي دون إذنه.',
                explanation: 'أخذ ممتلكات الآخرين دون إذنهم خطأ مرفوض.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'ألوم والدي بغضب.',
                explanation: 'ترتيب حقيبتك ومستلزماتك مسؤوليتك الشخصية كبطل.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'تفكير ذكي وحل رائع! القادة يجدون الحلول دوماً.',
            gentleFeedbackWrong: 'محاولة جيدة! التفكير بهدوء يحل أي مشكلة بسيطة.',
          ),
        ),
        MissionModel(
          id: 'w3_m3',
          number: 3,
          title: 'درع الشجاعة واللطف',
          habitName: 'الدفاع عن المظلوم واللطف',
          habitDescription: 'مساندة الضعيف والوقوف مع الحق بلطف وشهامة.',
          rewardStars: 3,
          rewardPoints: 170,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'FORT',
              dialogue: 'الشجاعة العظمى هي أن نكون عوناً وسنداً لمن يحتاجنا، وندافع عن اللطف والحق.',
              sceneDescription: 'قلعة الشجاعة تضيئها مشاعل الشهامة والنبل.',
              backgroundTheme: 'mountain_fort',
            ),
          ],
          quiz: QuizModel(
            situation: 'رأيت طفلاً يتعرض للمضايقة أو التنمر في ساحة المدرسة:',
            question: 'ما هو موقف البطل الشهم؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أقف بجانبه وأطلب منهم التوقف بأدب وحزم، وأبلغ المعلم فوراً.',
                explanation: 'تصرف بطولي يحمي الآخرين وينشر الأمان في المدرسة.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أضحك مع المتنمرين وأشاركهم.',
                explanation: 'مشاركة التنمر سلوك مؤذٍ يغضب الله والناس.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أتفرج بصمت وأشجعهم.',
                explanation: 'السكوت عن الإيذاء يضر بالجميع.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أهرب وأتجاهل ما يحدث.',
                explanation: 'نصرة المظلوم وإبلاغ المسؤول واجب أخلاقي نبيل.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'يا لك من بطل شهم ونبيل! صنعت فرقاً حقيقياً بشجاعتك.',
            gentleFeedbackWrong: 'محاولة طيبة! الدفاع عن الحق ومساعدة الضعيف جوهر البطولة الحقيقية.',
          ),
        ),
        MissionModel(
          id: 'w3_m4',
          number: 4,
          title: 'قاهر المخاوف',
          habitName: 'مواجهة المخاوف والتجربة',
          habitDescription: 'تجاوز الخوف الطبيعي وتجربة الأمور النافعة بشجاعة.',
          rewardStars: 3,
          rewardPoints: 170,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'FORT',
              dialogue: 'الخوف شعور طبيعي، لكن الشجاع هو من يتقدم خطوة للأمام ويهزم خوفه!',
              sceneDescription: 'ممر الكهف المضيء ببلورات الشجاعة البراقة.',
              backgroundTheme: 'mountain_cave',
            ),
          ],
          quiz: QuizModel(
            situation: 'أتيحت لك فرصة إلقاء كلمة في الإذاعة المدرسية وتشعر برهبة الجمهور:',
            question: 'كيف تواجه مخاوفك وتتألق؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أتدرب جيداً في المنزل أمام المرآة، وألقي الكلمة بثقة وابتسامة.',
                explanation: 'التدريب يزيل الرهبة، والتجربة تبني فيك شجاعة الإلقاء.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أعتذر وأقول أنا خائف ولن أشارك أبداً.',
                explanation: 'الانسحاب الدائم يمنعك من اكتشاف مهاراتك الرائعة.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أتظاهر بالمرض للهروب.',
                explanation: 'الصدق مع النفس ومواجهة التحدي هو طريق النجاح.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'ألقي الكلمة وأنا أبكي بصوت منخفض.',
                explanation: 'الثقة بالنفس والتنفس الهادئ يمنحانك قوة وصوتاً واضحاً.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'خطيب وقائد شجاع! هزمت الخوف وصنعت نجاحاً باهراً.',
            gentleFeedbackWrong: 'محاولة جيدة! كل تجربة شجاعة تجعلك أقوى وأكثر ثقة للمستقبل.',
          ),
        ),
        MissionModel(
          id: 'w3_m5',
          number: 5,
          title: 'راية الاستقلال',
          habitName: 'الاستقلالية والاعتماد على النفس',
          habitDescription: 'أداء المهام الشخصية وترتيب المقتنيات دون اتكالية.',
          rewardStars: 3,
          rewardPoints: 170,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'وصلنا لقمة جبال التحديات! البطل الحقيقي يعتمد على نفسه في ترتيب حياته وواجباته.',
              sceneDescription: 'راية جبال التحديات ترفرف في سماء العزيمة الصافية.',
              backgroundTheme: 'mountain_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'عدت من المدرسة وغرفتك وحقيبتك بحاجة لترتيب:',
            question: 'ما هو سلوك البطل المستقل؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أعلق ملابسي، أرتب حقيبتي لليوم التالي، وأنظم مكتبي بنفسي.',
                explanation: 'الاعتماد على النفس والاستقلال يصنعان شخصيتك القيادية القوية.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أرمي الحقيبة والحذاء في وسط الصالة وأنتظر أمي.',
                explanation: 'الفوضى تزيد الأعباء على الأسرة وتظهر الاتكالية.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أترك كل شيء مبعثراً في الأرض.',
                explanation: 'عدم الترتيب يضيع مقتنياتك ويسبب الفوضى.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أرفض ترتيب ألعابي وغرفتي تماماً.',
                explanation: 'المسؤولية الذاتية تبدأ من تنظيم مساحتك الخاصة.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'بطل مستقل ومنظم! ترتيبك ومسؤوليتك يفرحان قلب والديك.',
            gentleFeedbackWrong: 'محاولة طيبة! الاعتماد على النفس مهارة تصنع منك قائداً مستقبلياً.',
          ),
        ),
      ],
    ),

    WorldModel(
      worldNumber: 4,
      name: 'مملكة الحكمة',
      description: 'عالم التفكير الاستراتيجي والتعلم المستمر: التخطيط، حب القراءة، احترام الوقت، الامتنان، والتفكير الإيجابي.',
      worldColor: AppColors.sunnyYellow,
      isPremium: false,
      missions: [
        MissionModel(
          id: 'w4_m1',
          number: 1,
          title: 'خريطة الأهداف',
          habitName: 'التخطيط وتحديد الأهداف',
          habitDescription: 'رسم خطة يومية واضحة لإنجاز الواجبات والأهداف.',
          rewardStars: 3,
          rewardPoints: 180,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'مرحباً بك في مملكة الحكمة! معنا صديقنا QORT ديناصور الحكمة والرأي السديد.',
              sceneDescription: 'مكتبة كبرى تضيئها بلورات المعرفة والحكمة.',
              backgroundTheme: 'kingdom_library',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'QORT',
              dialogue: 'الحكمة تبدأ بالتخطيط! من يعرف هدفه ويرتب خطواته يصل لما يريد بسهولة.',
              sceneDescription: 'QORT يرسم خريطة الأهداف اليومية بدقة.',
              backgroundTheme: 'kingdom_map',
            ),
          ],
          quiz: QuizModel(
            situation: 'لديك اليوم واجب مدرسي، موعد زيارة عائلية، ووقت للعب:',
            question: 'كيف ترتب يومك بحكمة؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أنجز واجبي أولاً، ثم أزور العائلة، وأستمتع بوقي المتبقي في اللعب.',
                explanation: 'تنظيم الأولويات يجعلك تنجز كل شيء براحة وسعادة.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'ألعب طوال اليوم وأترك الواجب لآخر لحظة قبل النوم.',
                explanation: 'تأجيل الواجبات يسبب القلق والتعب وضعف الأداء.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أرفض الذهاب مع العائلة من أجل الألعاب الإلكترونية.',
                explanation: 'صلة الرحم والاجتماع الأسري من أهم القيم الجميلة.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أهمل كل شيء ولا أفعل شيئاً مفيداً.',
                explanation: 'الوقت كنز ثمين واستثماره يصنع مستقبلك المشرق.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'حكيم ومنظم! ترتيب الأولويات هو سر تفوق كل الناجحين.',
            gentleFeedbackWrong: 'محاولة جيدة! إنجاز الأهم فالمهم يمنحك وقتاً كافياً للعب براحة بال.',
          ),
        ),
        MissionModel(
          id: 'w4_m2',
          number: 2,
          title: 'بوابة المعرفة',
          habitName: 'حب القراءة والاستكشاف',
          habitDescription: 'تخصيص وقت يومي لقراءة القصص المفيدة والكتب الممتعة.',
          rewardStars: 3,
          rewardPoints: 180,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'QORT',
              dialogue: 'الكتب نوافذ سحرية نسافر عبرها لكل بلدان العالم ونكتسب حكمة العصور.',
              sceneDescription: 'برج القراءة الأثري تملؤه كتب المعرفة والعلوم.',
              backgroundTheme: 'kingdom_tower',
            ),
          ],
          quiz: QuizModel(
            situation: 'وجدت وقتاً فارغاً في المساء وتريد استثماره بشيء ممتع وذكي:',
            question: 'ما هو الخيار الأمثل؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أقرأ فصلاً من قصة مشوقة أو موسوعة علمية للأطفال.',
                explanation: 'القراءة تغذي عقلك وتنمي خيالك ومفرداتك اللغوية.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أحدّق في شاشة الهاتف بالساعات دون هدف.',
                explanation: 'الشاشات الطويلة تجهد عينيك وتضيع وقتك الثمين.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أشكو من الملل دون محاولة تجربة شيء جديد.',
                explanation: 'الملل يزول حين تفتح كتاباً وتبدأ مغامرة جديدة.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أمزق أوراق الكتب والدفاتر.',
                explanation: 'احترام الكتب وأدوات التعلم واجب على كل طالب علم.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'عقل مفكر وبطل قارئ! القراءة تصنع العقول الذهبية.',
            gentleFeedbackWrong: 'محاولة طيبة! كتاب واحد يومياً يصنع منك عالماً ومبتكراً كبيراً.',
          ),
        ),
        MissionModel(
          id: 'w4_m3',
          number: 3,
          title: 'ساعة الانضباط',
          habitName: 'احترام الوقت والمواعيد',
          habitDescription: 'الالتزام بالمواعيد المحددة وعدم التأخير.',
          rewardStars: 3,
          rewardPoints: 180,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'QORT',
              dialogue: 'الوقت أغلى ما نملك، واحترام مواعيدنا يعكس احترامنا لأنفسنا وللآخرين.',
              sceneDescription: 'ساعة المملكة الشمسية الكبرى تدق بدقة متناهية.',
              backgroundTheme: 'kingdom_clock',
            ),
          ],
          quiz: QuizModel(
            situation: 'اتفقت مع أصدقائك أو معلمك على الحضور في الساعة الرابعة تماماً:',
            question: 'ما هو السلوك المحترم؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أستعد مبكراً وأصل قبل الموعد بخمس دقائق.',
                explanation: 'الالتزام بالموعد خلق راقٍ يكسبك ثقة واحترام الجميع.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أصل متأخراً بنصف ساعة دون اعتذار.',
                explanation: 'التأخر يزعج المنتظرين ويهدر أوقاتهم.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أنسى الموعد وأذهب لمكان آخر.',
                explanation: 'نسيان المواعيد يقلل من جديتك وموثوقيتك.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أطلب منهم الانتظار طويلاً لأنني غير مستعد.',
                explanation: 'أوقات الناس ثمينة ويجب احترامها دائماً.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'منضبط ودقيق! احترام المواعيد سمة القادة والناجحين.',
            gentleFeedbackWrong: 'محاولة جيدة! التواجد في الموعد يبني لك سمعة رائعة بين أصدقائك.',
          ),
        ),
        MissionModel(
          id: 'w4_m4',
          number: 4,
          title: 'شجرة الشكر',
          habitName: 'الامتنان وشكر النعم',
          habitDescription: 'شكر الله على النعم وشكر الوالدين والناس على إحسانهم.',
          rewardStars: 3,
          rewardPoints: 180,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'QORT',
              dialogue: 'من لا يشكر الناس لا يشكر الله، والامتنان يملأ القلب بالرضا والسكينة.',
              sceneDescription: 'شجرة الامتنان الكريستالية تعكس أنوار الرضا والسعادة.',
              backgroundTheme: 'kingdom_thanks',
            ),
          ],
          quiz: QuizModel(
            situation: 'قدمت لك أمك وجبة طعام دافئة صنعتها لك بحب وتعب:',
            question: 'ما هي الكلمة الأجمل والأكثر أدباً؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أقول: "شكراً يا أمي، سلمت يداك وجزاك الله خيراً".',
                explanation: 'كلمات الشكر تفرح قلب الوالدين وتزيد من البر والمحبة.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'آكل بصمت وأغادر دون أي كلمة.',
                explanation: 'الاعتراف بفضل الوالدين واجب ويسعد الأسرة.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أنتقد الطعام وأقول إنه لا يعجبني بصوت غاضب.',
                explanation: 'نقد الطعام يجرح مشاعر من أعده بحب وتعب.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أرمي الصحن وأطلب طعاماً سريعاً.',
                explanation: 'شكر النعمة وحفظها سبب لبركتها واستمرارها.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'قلب بار وممتن! الشكر مفتاح الخير وزيادة النعم.',
            gentleFeedbackWrong: 'محاولة طيبة! الكلمة الطيبة وشكر الوالدين سر من أسرار التوفيق والبركة.',
          ),
        ),
        MissionModel(
          id: 'w4_m5',
          number: 5,
          title: 'تاج الحكمة',
          habitName: 'التفكير الإيجابي والحوار',
          habitDescription: 'التركيز على الجانب المشرق واختيار الحوار لحل الخلافات.',
          rewardStars: 3,
          rewardPoints: 180,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'QORT',
              dialogue: 'مبارك وصولك لتاج الحكمة! الحكمة أن تحوّل كل عثرة إلى خطوة جديدة للأمام.',
              sceneDescription: 'قاعة الحكمة الكبرى وتاج النجاح يتلألأ بالذهب.',
              backgroundTheme: 'kingdom_crown',
            ),
          ],
          quiz: QuizModel(
            situation: 'اختلف رأيك مع زميلك حول موضوع النشاط المدرسي المشترك:',
            question: 'كيف تصنع الحل السلمي الذكي؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أستمع لرأيه بهدوء، ونجمع أفضل ما في الفكرتين معاً بالتشاور.',
                explanation: 'الحوار والتكامل يصنعان أفضل النتائج ويبقيان على الصداقة.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أصر على رأيي بالقوة وأرفض سماعه.',
                explanation: 'التعصب للرأي يفسد العمل الجماعي.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أخاصمه وأترك النشاط تماماً.',
                explanation: 'الخصام لا يحل الخلاف بل يوسع الفجوة.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أقلل من قيمة فكرته أمام زملائي.',
                explanation: 'احترام آراء الآخرين أساس الأخلاق الإسلامية والإنسانية.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'حكيم وملهم! الحوار البناء هو لغة القادة الأذكياء.',
            gentleFeedbackWrong: 'محاولة جيدة! الاستماع لغيرك يفتح لك آفاقاً جديدة وأفكاراً مبتكرة.',
          ),
        ),
      ],
    ),

    WorldModel(
      worldNumber: 5,
      name: 'واحة الإبداع',
      description: 'عالم الابتكار والتفكير الخلاق: الفضول العلمي، حماية البيئة، تنمية المواهب، العمل الجماعي، والحلول غير التقليدية.',
      worldColor: AppColors.lavenderPurple,
      isPremium: true,
      missions: [
        MissionModel(
          id: 'w5_m1',
          number: 1,
          title: 'شرارة الفكرة',
          habitName: 'الفضول العلمي وطرح الأسئلة',
          habitDescription: 'التساؤل والبحث عن أسباب الأشياء واكتشاف الطبيعة.',
          rewardStars: 3,
          rewardPoints: 200,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'أهلاً بك في واحة الإبداع! معنا صديقنا LORT ديناصور الذكاء والتفكير العبقري.',
              sceneDescription: 'واحة ممتدة تتطاير فيها فقاعات الأفكار الملونة.',
              backgroundTheme: 'oasis_start',
            ),
            StorySceneModel(
              sceneIndex: 1,
              speakerName: 'LORT',
              dialogue: 'أنا LORT أحب التفكير وحل الألغاز! كل اختراع عظيم بدأ بسؤال ذكي وبسيط.',
              sceneDescription: 'LORT يفحص عدسة مكبرة ويكتشف أسرار الطبيعة.',
              backgroundTheme: 'oasis_idea',
            ),
          ],
          quiz: QuizModel(
            situation: 'رأيت ظاهرة طبيعية غريبة في الحديقة ولم تفهم سبب حدوثها:',
            question: 'ما هو تصرف العالِم والمبتكر الصغير؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أسأل معلمي أو والدي وأبحث في كتاب علمي موثوق لمعرفة السبب.',
                explanation: 'السؤال والبحث هما طريق العلماء والمكتشفين الكبار.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أتجاهل الأمر وأقول هذا غير مهم.',
                explanation: 'تجاهل المعرفة يحد من ذكائك وفضولك الطبيعي.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أخترع إشاعة غير صحيحة وأخيف بها غيري.',
                explanation: 'نشر المعلومات الخاطئة يضلل الناس.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أشعر بالخوف وأهرب.',
                explanation: 'العلم والمعرفة يزيلان الخوف ويبعثان على الطمأنينة.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'مستكشف عبقري! بالسؤال والبحث ستصل لأعظم الاختراعات.',
            gentleFeedbackWrong: 'محاولة طيبة! الفضول وحب الاستكشاف هما محرك الإبداع والتميز.',
          ),
        ),
        MissionModel(
          id: 'w5_m2',
          number: 2,
          title: 'إعادة التدوير الفني',
          habitName: 'المحافظة على البيئة وإعادة التدوير',
          habitDescription: 'الاستفادة من الخامات القديمة وتحويلها لابتكارات فنية نافعة.',
          rewardStars: 3,
          rewardPoints: 200,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'LORT',
              dialogue: 'في واحة الإبداع، لا نرمي شيئاً نافعاً، بل نحوّله بذكاء لقطع فنية مبهرة!',
              sceneDescription: 'ورشة الابتكار اليدوي ممتلئة بمجسمات فنية مذهلة.',
              backgroundTheme: 'oasis_workshop',
            ),
          ],
          quiz: QuizModel(
            situation: 'لديك صندوق كرتوني فارغ بعد شراء حذاء جديد:',
            question: 'كيف تستفيد منه بطريقة إبداعية؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أقوم بتلوينه وتزيينه وتحويله إلى صندوق منظم لأقلامي وألعابي.',
                explanation: 'ابتكار رائع يحفظ البيئة وينظم غرفتك بأقل التكاليف.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أرميه في الشارع من النافذة.',
                explanation: 'رمي النفايات في الشارع يشوه البيئة ويؤذي المارة.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أمزقه وأرميه في صالة المنزل.',
                explanation: 'الفوضى تزيد الأعباء على الأسرة وتفسد الترتيب.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أتركه في الممر ليعثر به أحد.',
                explanation: 'ترك العوائق في الممرات قد يتسبب في إصابة الآخرين.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'فنان ومبتكر صديق للبيئة! لمستك الفنية صنعت فرقاً.',
            gentleFeedbackWrong: 'محاولة جيدة! إعادة استخدام الأشياء القديمة متعة وفائدة كبيرة.',
          ),
        ),
        MissionModel(
          id: 'w5_m3',
          number: 3,
          title: 'قوس قزح التعبير',
          habitName: 'استكشاف المواهب والفنون',
          habitDescription: 'ممارسة الرسم، الإلقاء، أو الكتابة للتعبير عن الذات.',
          rewardStars: 3,
          rewardPoints: 200,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'LORT',
              dialogue: 'كل طفل بداخله موهبة فريدة، وممارستها تضيء شخصيته كألوان قوس قزح!',
              sceneDescription: 'لوحة رسم عملاقة ترسم عليها أصابع الطبيعة ألواناً خلابة.',
              backgroundTheme: 'oasis_art',
            ),
          ],
          quiz: QuizModel(
            situation: 'أقامت المدرسة مسابقة للمواهب (رسم، كتابة، إلقاء، اختراع):',
            question: 'ما هي الخطوة التي تعبر عن رغبتك في التطور؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أسجل في المجال الذي أحبه وأتدرب جيداً وأشارك بحماس.',
                explanation: 'المشاركة والتجربة تصقل الموهبة وتزيد من ثقتك بنفسك.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أقول أنا لا أمتلك أي موهبة وأخجل من المشاركة.',
                explanation: 'التدريب يظهر المواهب، والتجربة هي أول خطوة.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أسخر من زملائي المشاركين.',
                explanation: 'تشجيع الأصدقاء يعكس نقاء القلب وحسن الخلق.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أشترط الفوز بالمركز الأول فقط وإلا سأغضب.',
                explanation: 'شرف المحاولة والتعلم هو المكسب الأكبر دائماً.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'موهوب وشجاع! روح المبادرة ستجعلك نجماً لامعاً.',
            gentleFeedbackWrong: 'محاولة طيبة! كل موهبة تبدأ بتجربة ومحاولة شجاعة.',
          ),
        ),
        MissionModel(
          id: 'w5_m4',
          number: 4,
          title: 'العمل الجماعي الذكي',
          habitName: 'العمل الجماعي والتكامل',
          habitDescription: 'الاستفادة من تنوع مواهب أعضاء الفريق لإنتاج عمل متميز.',
          rewardStars: 3,
          rewardPoints: 200,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'LORT',
              dialogue: 'عندما يجتمع المبرمج والرسام والكاتب، يولد مشروع أسطوري يبهر العالم!',
              sceneDescription: 'فريق من المبتكرين يعملون سوياً لتركيب روبوت الواحة الصغير.',
              backgroundTheme: 'oasis_team',
            ),
          ],
          quiz: QuizModel(
            situation: 'تعمل مع مجموعة في مشروع علمي وكل زميل له مهارة مختلفة:',
            question: 'كيف تقسمون العمل بنجاح؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'يتولى كل شخص الجزء الذي يتقنه، ونراجع العمل سوياً كفريق واحد.',
                explanation: 'هذا قمة الاحترافية والتكامل الإبداعي.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أقوم بكل شيء وحدي ولا أسمح لأحد بالمساعدة.',
                explanation: 'العمل الفردي مرهق ويحرمك من أفكار زملائك الرائعة.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أترك كل العمل على زملائي وأنا أنام.',
                explanation: 'الاتكالية سلوك غير عادل يضر بالفريق.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'نتشاجر على من يكتب اسمه في البداية.',
                explanation: 'نجاح العمل هو فخر لجميع أفراد الفريق.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'قائد ومبتكر ملهم! العمل بروح الفريق سر أعظم المشاريع.',
            gentleFeedbackWrong: 'محاولة جيدة! استثمار طاقات الجميع يجعل مشروعكم الأفضل دوماً.',
          ),
        ),
        MissionModel(
          id: 'w5_m5',
          number: 5,
          title: 'شعلة الابتكار',
          habitName: 'التفكير خارج الصندوق',
          habitDescription: 'إيجاد حلول غير تقليدية وجديدة لتسهيل الحياة اليومية.',
          rewardStars: 3,
          rewardPoints: 200,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'LORT',
              dialogue: 'أبدعت في واحة الإبداع! تذكر دائماً أن الخيال لا حدود له والذكاء يفتح كل الأبواب.',
              sceneDescription: 'شعلة الإبداع المضيئة ترسل أنوارها نحو آفاق النجوم.',
              backgroundTheme: 'oasis_finish',
            ),
          ],
          quiz: QuizModel(
            situation: 'واجهتك مشكلة في تذكر مواعيد المهام اليومية في المنزل والمدرسة:',
            question: 'ما هو الحل المبتكر والعملي؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أصمم لوحة متابعة ملونة وجذابة أعلقها بجانب مكتبي وأضع شارات عند الإنجاز.',
                explanation: 'فكرة إبداعية ومحفزة تحول الالتزام إلى لعبة ممتعة.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أعتمد على الحفظ العشوائي وأنسى المهام.',
                explanation: 'الاعتماد على الذاكرة دون تدوين يسبب نسيان الواجبات.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أطلب من أمي تذكيري كل 5 دقائق طوال اليوم.',
                explanation: 'الاعتماد على النفس والاستقلال يصنعان شخصيتك القوية.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أتوقف عن أداء المهام المدرسية.',
                explanation: 'التراجع يضيع مستقبلك وفرص تفوقك.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'مبتكر استثنائي! التفكير العملي يجعل حياتك منظمة وسهلة.',
            gentleFeedbackWrong: 'محاولة طيبة! ابتكار وسائل بصرية يساعدك على الالتزام الذاتي.',
          ),
        ),
      ],
    ),

    WorldModel(
      worldNumber: 6,
      name: 'قمة الإنجاز',
      description: 'عالم القيادة وصناعة الأثر: القيادة بالقدوة، العطاء المجتمعي، الرقابة الذاتية، الصحة والرياضة، وترسيخ العادات.',
      worldColor: AppColors.warmGoldDark,
      isPremium: true,
      missions: [
        MissionModel(
          id: 'w6_m1',
          number: 1,
          title: 'القدوة الحسنة',
          habitName: 'القيادة بالقدوة والأفعال',
          habitDescription: 'أن تكون نموذجاً يحتذى به في الأخلاق والتصرفات السليمة.',
          rewardStars: 3,
          rewardPoints: 250,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'مرحباً بك في قمة الإنجاز! القائد الحقيقي يقود بأفعاله وأخلاقه قبل كلماته.',
              sceneDescription: 'قمم جبال ذهبية شاهقة تلامس السحاب بنقاء وشموخ.',
              backgroundTheme: 'summit_start',
            ),
          ],
          quiz: QuizModel(
            situation: 'أنت الأخ الأكبر أو طالب متميز في الصف يراك الصغار ويقلدونك:',
            question: 'كيف تكون قدوة حسنة ومصدر إلهام؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'ألتزم بالأخلاق العالية، أساعدهم بلطف، وأعاملهم باحترام ومودة.',
                explanation: 'هذا سلوك القائد المؤثر الذي يترك أثراً طيباً في كل مكان.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أتصرف بفوقية وتكبر وأعاملهم بخشونة.',
                explanation: 'التكبر يبعد الناس عنك ويفقدك محبتهم.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أشجعهم على ارتكاب الأخطاء والضحك على المعلم.',
                explanation: 'تشجيع الخطأ تصرف غير مسؤول يضر بالجميع.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أتجاهلهم ولا أهتم بما يرونه مني.',
                explanation: 'القدوة مسؤولية نبيلة تصنع أجيالاً واعية.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'قائد حقيقي وقدوة ملهمة! تصرفك ينشر الخير ويبني الأجيال.',
            gentleFeedbackWrong: 'محاولة طيبة! تذكر أن كل تصرف نبيل منك يلهم من حولك ليكونوا أفضل.',
          ),
        ),
        MissionModel(
          id: 'w6_m2',
          number: 2,
          title: 'غرس الخير',
          habitName: 'العطاء والمبادرة المجتمعية',
          habitDescription: 'المشاركة في الأعمال التطوعية والخيرية ومساعدة المجتمع.',
          rewardStars: 3,
          rewardPoints: 250,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'السعادة الحقيقية هي في العطاء وإدخال السرور على قلوب الناس ونظافة بيئتنا.',
              sceneDescription: 'مزرعة الخير على سفح الجبل، يزرع فيها الأبطال شتلات الأمل.',
              backgroundTheme: 'summit_giving',
            ),
          ],
          quiz: QuizModel(
            situation: 'أعلنت مدرستك أو حيك السكني عن حملة تطوعية لزراعة الأشجار وتنظيف الحديقة:',
            question: 'ما هو القرار الذي يعبر عن مواطنتك الصالحة؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أبادر بالتسجيل بحماس، وأرتدي قفازاتي وأشارك بجهدي في غرس الأشجار.',
                explanation: 'التطوع ينمي روح المواطنة ويجعل مدينتنا أجمل وأنقى.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أفضل الجلوس بالبيت لمشاهدة التلفاز.',
                explanation: 'المشاركة المجتمعية تمنحك طاقة وتجارب لا تعوض.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أذهب فقط للتصوير وتناول الطعام دون أن أساعد.',
                explanation: 'الإخلاص في العمل التطوعي هو جوهر العطاء الحقيقي.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أسخر من المتطوعين وأعتبر عملهم غير مهم.',
                explanation: 'غرس الأشجار صدقة جارية وعمل نبيل أمر به ديننا.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'بطل مجتمعي معطاء! يدك التي تزرع الخير تبني وطناً مزدهراً.',
            gentleFeedbackWrong: 'محاولة جيدة! العطاء والمبادرة التطوعية تصنع فيك روح القائد الحقيقي.',
          ),
        ),
        MissionModel(
          id: 'w6_m3',
          number: 3,
          title: 'بوصلة الانضباط الذاتي',
          habitName: 'الرقابة الذاتية والنزاهة',
          habitDescription: 'الالتزام بالأمانة والصدق حتى حين لا يراك أحد.',
          rewardStars: 3,
          rewardPoints: 250,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'النزاهة هي أن تفعل الصواب دائماً حتى لو لم يكن هناك من يراقبك، فالله يرانا دوماً.',
              sceneDescription: 'مرصد القمة الكريستالي يكشف صفاء السماء ونقاء النوايا.',
              backgroundTheme: 'summit_integrity',
            ),
          ],
          quiz: QuizModel(
            situation: 'خرج المعلم من قاعة الاختبار لبضع دقائق وتركت ورقة الإجابة بجانبك:',
            question: 'كيف تثبت نزاهتك وانضباطك الذاتي؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أركز في ورقتي فقط وأعتمد على ما درسته بتعب وجهد شخصي.',
                explanation: 'هذا هو النجاح الحقيقي المشرف الذي تفخر به ويسعد والديك.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أسرق النظرات لورقة زميلي وأنقل الإجابات.',
                explanation: 'الغش خداع للنفس يضر بمستواك ويفقدك بركة العلم.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أطلب من زملائي الإجابات بصوت منخفض.',
                explanation: 'الاعتماد على جهود الآخرين يضعف شخصيتك وقدراتك.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أفتح الكتاب سراً.',
                explanation: 'الأمانة تاج على رؤوس الأبطال الصادقين.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'نزيه وأمين وبطل حقيقي! النجاح بجهدك له طعم فخر لا يقارن.',
            gentleFeedbackWrong: 'محاولة طيبة! الأمانة هي أساس الثقة والتفوق الحقيقي في الحياة.',
          ),
        ),
        MissionModel(
          id: 'w6_m4',
          number: 4,
          title: 'صحة الجسد والعقل',
          habitName: 'النشاط البدني والغذاء الصحي',
          habitDescription: 'ممارسة الرياضة اليومية وتناول الأغذية الطبيعية المفيدة.',
          rewardStars: 3,
          rewardPoints: 250,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'العقل السليم في الجسم السليم! الرياضة تمنحنا الحيوية وتصقل عزيمتنا.',
              sceneDescription: 'ميدان السباق الجبلي الممتلئ بالحيوية والنشاط.',
              backgroundTheme: 'summit_sports',
            ),
          ],
          quiz: QuizModel(
            situation: 'تريد اختيار وجبة خفيفة ونشاط بعد العودة من المدرسة:',
            question: 'ما هو النمط الحياتي الأكثر صحة وطاقة؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'أتناول فواكه طازجة مع ماء نقي، وأمارس رياضة خفيفة أو أركض في الحديقة.',
                explanation: 'اختيار رائع يمنحك قوة بدنية ومناعة عالية وصفاء ذهنياً.',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'آكل رقائق مقلية وحلويات دسمة وأجلس بالساعات دون حركة.',
                explanation: 'الأطعمة غير الصحية والخمول يسببان التعب وزيادة الوزن.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أمتنع عن شرب الماء تماماً وأشرب مشروبات الطاقة.',
                explanation: 'مشروبات الطاقة ضارة جداً للأطفال وتؤذي القلب.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أرفض تناول أي طعام صحي مفيد.',
                explanation: 'التغذية المتوازنة أساس نمو عظامك وعضلاتك بشكل سليم.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'رياضي وبطل مفعم بالحيوية! صحتك هي أغلى استثمار لمستقبلك.',
            gentleFeedbackWrong: 'محاولة جيدة! الغذاء الطبيعي والرياضة يمنحانك طاقة هائلة لتحقيق أهدافك.',
          ),
        ),
        MissionModel(
          id: 'w6_m5',
          number: 5,
          title: 'راية البطولة الكبرى',
          habitName: 'صناعة الأثر وترسيخ العادات',
          habitDescription: 'ترسيخ العادات الـ 30 في الحياة اليومية لتكون أسلوب حياة دائم.',
          rewardStars: 5,
          rewardPoints: 300,
          storyScenes: [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'ألف مبروك يا بطلنا العظيم! لقد أتممت رحلة العوالم الست واكتسبت أسلحة العادات والقيم الـ 30.',
              sceneDescription: 'قمة العالم الذهبية وراية النصر ترفرف بشموخ تحت شمس المجد.',
              backgroundTheme: 'summit_victory',
            ),
          ],
          quiz: QuizModel(
            situation: 'بعد أن أتممت تعلم العادات الإيجابية واكتسبت قوى أبطال PORT ومساعديه:',
            question: 'ما هو التعهد والعهد الذي تقطعه على نفسك؟',
            options: [
              QuizOptionModel(
                keyId: 'A',
                text: 'ألتزم بهذه العادات يومياً في بيتي ومدرستي، وأساعد أصدقائي على تعلمها.',
                explanation: 'هذا هو التتويج الحقيقي لبطل GLOW الأسطوري!',
              ),
              QuizOptionModel(
                keyId: 'B',
                text: 'أنساها فور إغلاق التطبيق وأعود للعادات السلبية.',
                explanation: 'العادات الحقيقية تُمارس في الواقع لتصنع فارقاً في حياتك.',
              ),
              QuizOptionModel(
                keyId: 'C',
                text: 'أحتفظ بها لنفسي ولا أنفع بها أحداً.',
                explanation: 'زكاة العلم ونشر القيم ينفعان مجتمعك ويزيدانك رفعة.',
              ),
              QuizOptionModel(
                keyId: 'D',
                text: 'أتوقف عن التعلم والتطوير.',
                explanation: 'رحلة التعلم مستمرة دائماً طوال الحياة.',
              ),
            ],
            correctKeyId: 'A',
            encouragementCorrect: 'مبارك يا أسطورة GLOW! لقد أصبحت قائداً حقيقياً وقدوة للأبطال.',
            gentleFeedbackWrong: 'محاولة طيبة! تذكر أن العادات تصنع مستقبلك كل يوم.',
          ),
        ),
      ],
    ),
  ];

  static List<WorldModel> _enrichWorlds(List<WorldModel> list) {
    return list.map((w) {
      final enrichedMissions = w.missions.map((m) {
        if (m.quizzes.length >= 10) return m;
        final expanded = World1QuizzesData.getExpanded10Quizzes(m.id, m.habitName, m.quiz);
        return m.copyWith(quizzes: expanded);
      }).toList();
      return WorldModel(
        worldNumber: w.worldNumber,
        name: w.name,
        description: w.description,
        worldColor: w.worldColor,
        isPremium: w.isPremium,
        missions: enrichedMissions,
      );
    }).toList();
  }

  static List<WorldModel> get defaultWorlds => _enrichWorlds(_defaultWorlds);

  static List<WorldModel> getWorlds() {
    final cached = HiveService.getCachedWorlds();
    if (cached != null && cached.isNotEmpty) {
      try {
        final parsed = cached.map((map) => WorldModel.fromMap(map)).toList();
        return _enrichWorlds(parsed);
      } catch (_) {
        return defaultWorlds;
      }
    }
    return defaultWorlds;
  }

  static List<WorldModel> get worlds => getWorlds();

  /// Persists state changes.
  static Future<void> saveCachedWorlds(List<WorldModel> newWorlds) async {
    final maps = newWorlds.map((w) => w.toMap()).toList();
    await HiveService.saveCachedWorlds(maps);
  }

  static ChildProfileModel getChildProfile() {
    final data = HiveService.getChildData<Map>(HiveKeys.childProfileKey);
    if (data != null) {
      return ChildProfileModel.fromMap(data);
    }
    final defaultId = ChildProfileModel.generateUniqueChildId();
    final initialProfile = ChildProfileModel(
      childId: defaultId,
      name: 'بطل GLOW',
      age: 7,
      avatarShape: 'shape_default',
      selectedCharacter: 'PORT',
      currentWorld: 1,
      stars: 0,
      points: 0,
      completedMissions: const [],
      earnedBadges: const [],
    );
    // Persists state changes.
    HiveService.saveChildData(HiveKeys.childProfileKey, initialProfile.toMap());
    return initialProfile;
  }

  /// Persists state changes.
  static Future<void> saveChildProfile(ChildProfileModel profile) async {
    await HiveService.saveChildData(HiveKeys.childProfileKey, profile.toMap());
  }

  static bool isProfileSetupComplete() {
    final isComplete = HiveService.getSetting<bool>(
      HiveKeys.isProfileCompleteKey,
      defaultValue: false,
    );
    if (isComplete) return true;

    final data = HiveService.getChildData<Map>(HiveKeys.childProfileKey);
    if (data != null) {
      final name = data['name']?.toString() ?? '';
      final missions = (data['completedMissions'] as List?) ?? [];
      final points = (data['points'] as num?)?.toInt() ?? 0;
      final stars = (data['stars'] as num?)?.toInt() ?? 0;

      if (missions.isNotEmpty ||
          points > 0 ||
          stars > 0 ||
          (name.isNotEmpty && name != 'بطل GLOW' && name != 'بطل المستقبل')) {
        HiveService.saveSetting(HiveKeys.isProfileCompleteKey, true);
        return true;
      }
    }
    return false;
  }

  static Future<void> markProfileSetupComplete() async {
    await HiveService.saveSetting(HiveKeys.isProfileCompleteKey, true);
  }

  static String calculateRankTitle(int points) {
    if (points >= 3000) return 'قائد أسطوري';
    if (points >= 2000) return 'حكيم القيم';
    if (points >= 1000) return 'فارس التحدي';
    if (points >= 400) return 'بطل العادات';
    return 'مستكشف البدايات';
  }

  static double calculateLevelProgress(int points) {
    if (points >= 3000) return 1.0;
    if (points >= 2000) return (points - 2000) / 1000;
    if (points >= 1000) return (points - 1000) / 1000;
    if (points >= 400) return (points - 400) / 600;
    return (points / 400).clamp(0.0, 1.0);
  }

  static bool isWorldUnlocked(int worldNumber, List<String> completedMissions, {bool isSubscribed = false}) {
    if (worldNumber == 1) return true;
    final prevWorldIndex = worldNumber - 2;
    if (prevWorldIndex < 0 || prevWorldIndex >= worlds.length) return false;
    final prevWorld = worlds[prevWorldIndex];
    final prevWorldMissionIds = prevWorld.missions.map((m) => m.id).toSet();
    if (prevWorldMissionIds.isEmpty) return false;

    final completedPrevious = prevWorldMissionIds.every((id) => completedMissions.contains(id));
    if (!completedPrevious) return false;

    if (worldNumber >= 5 && !isSubscribed) {
      return false;
    }

    return true;
  }
}
