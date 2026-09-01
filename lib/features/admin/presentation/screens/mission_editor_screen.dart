import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../child/data/models/child_models.dart';

class MissionEditorScreen extends StatefulWidget {
  final int worldNumber;
  final MissionModel? initialMission;
  final int nextMissionNumber;
  final Function(MissionModel mission) onSave;

  const MissionEditorScreen({
    super.key,
    required this.worldNumber,
    this.initialMission,
    required this.nextMissionNumber,
    required this.onSave,
  });

  @override
  State<MissionEditorScreen> createState() => _MissionEditorScreenState();
}

class _MissionEditorScreenState extends State<MissionEditorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController _idController;
  late TextEditingController _numberController;
  late TextEditingController _titleController;
  late TextEditingController _habitNameController;
  late TextEditingController _habitDescController;
  late TextEditingController _starsController;
  late TextEditingController _pointsController;

  late List<StorySceneModel> _scenes;

  late TextEditingController _situationController;
  late TextEditingController _questionController;
  late TextEditingController _correctFeedbackController;
  late TextEditingController _wrongFeedbackController;
  late String _correctKeyId;

  late TextEditingController _optAText;
  late TextEditingController _optAExp;
  late TextEditingController _optBText;
  late TextEditingController _optBExp;
  late TextEditingController _optCText;
  late TextEditingController _optCExp;
  late TextEditingController _optDText;
  late TextEditingController _optDExp;

  final List<String> _speakers = ['PORT', 'MORT', 'FORT', 'QORT', 'LORT'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    final m = widget.initialMission;
    final defId = 'w${widget.worldNumber}_m${m?.number ?? widget.nextMissionNumber}';

    _idController = TextEditingController(text: m?.id ?? defId);
    _numberController = TextEditingController(
      text: (m?.number ?? widget.nextMissionNumber).toString(),
    );
    _titleController = TextEditingController(text: m?.title ?? '');
    _habitNameController = TextEditingController(text: m?.habitName ?? '');
    _habitDescController = TextEditingController(text: m?.habitDescription ?? '');
    _starsController = TextEditingController(text: (m?.rewardStars ?? 3).toString());
    _pointsController = TextEditingController(text: (m?.rewardPoints ?? 150).toString());

    if (m != null && m.storyScenes.isNotEmpty) {
      _scenes = List.from(m.storyScenes);
    } else {
      _scenes = [
        const StorySceneModel(
          sceneIndex: 0,
          speakerName: 'PORT',
          dialogue: 'مرحباً بك يا بطل! أنا PORT واليوم سنخوض مغامرة ممتعة لاكتشاف عادة جديدة.',
          sceneDescription: 'يقف PORT في مدخل المرحلة مبتسماً بحماس.',
          backgroundTheme: 'forest_day',
        ),
      ];
    }

    final q = m?.quiz;
    _situationController = TextEditingController(text: q?.situation ?? '');
    _questionController = TextEditingController(text: q?.question ?? 'ما هو التصرف الأكثر وعياً وإيجابية؟');
    _correctFeedbackController = TextEditingController(
      text: q?.encouragementCorrect ?? 'أحسنت يا بطل! تصرفك رائع ويعبر عن قيم حقيقية.',
    );
    _wrongFeedbackController = TextEditingController(
      text: q?.gentleFeedbackWrong ?? 'محاولة طيبة! تذكر دائماً أن العادات الإيجابية تجعل يومك أفضل.',
    );
    _correctKeyId = q?.correctKeyId ?? 'A';

    String getOptText(String key, String def) {
      if (q == null) return def;
      final opt = q.options.where((o) => o.keyId == key).toList();
      return opt.isNotEmpty ? opt.first.text : def;
    }

    String getOptExp(String key, String def) {
      if (q == null) return def;
      final opt = q.options.where((o) => o.keyId == key).toList();
      return opt.isNotEmpty ? opt.first.explanation : def;
    }

    _optAText = TextEditingController(text: getOptText('A', ''));
    _optAExp = TextEditingController(text: getOptExp('A', 'تصرف سليم ومثالي.'));
    _optBText = TextEditingController(text: getOptText('B', ''));
    _optBExp = TextEditingController(text: getOptExp('B', ''));
    _optCText = TextEditingController(text: getOptText('C', ''));
    _optCExp = TextEditingController(text: getOptExp('C', ''));
    _optDText = TextEditingController(text: getOptText('D', ''));
    _optDExp = TextEditingController(text: getOptExp('D', ''));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _idController.dispose();
    _numberController.dispose();
    _titleController.dispose();
    _habitNameController.dispose();
    _habitDescController.dispose();
    _starsController.dispose();
    _pointsController.dispose();
    _situationController.dispose();
    _questionController.dispose();
    _correctFeedbackController.dispose();
    _wrongFeedbackController.dispose();
    _optAText.dispose();
    _optAExp.dispose();
    _optBText.dispose();
    _optBExp.dispose();
    _optCText.dispose();
    _optCExp.dispose();
    _optDText.dispose();
    _optDExp.dispose();
    super.dispose();
  }

  void _saveMission() {
    final title = _titleController.text.trim();
    final habitName = _habitNameController.text.trim();
    if (title.isEmpty || habitName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء عنوان المهمة واسم العادة أولاً')),
      );
      _tabController.animateTo(0);
      return;
    }

    final options = [
      QuizOptionModel(keyId: 'A', text: _optAText.text.trim(), explanation: _optAExp.text.trim()),
      QuizOptionModel(keyId: 'B', text: _optBText.text.trim(), explanation: _optBExp.text.trim()),
      QuizOptionModel(keyId: 'C', text: _optCText.text.trim(), explanation: _optCExp.text.trim()),
      QuizOptionModel(keyId: 'D', text: _optDText.text.trim(), explanation: _optDExp.text.trim()),
    ].where((o) => o.text.isNotEmpty).toList();

    final quiz = QuizModel(
      situation: _situationController.text.trim(),
      question: _questionController.text.trim(),
      options: options,
      correctKeyId: _correctKeyId,
      encouragementCorrect: _correctFeedbackController.text.trim(),
      gentleFeedbackWrong: _wrongFeedbackController.text.trim(),
    );

    final scenesToSave = _scenes.isNotEmpty
        ? _scenes
        : [
            StorySceneModel(
              sceneIndex: 0,
              speakerName: 'PORT',
              dialogue: 'مرحباً بك يا بطل في مهمة $title! اليوم سنكتشف معاً عادة $habitName.',
              sceneDescription: 'يقف PORT مبتسماً بحماس.',
              backgroundTheme: 'forest_day',
            ),
          ];

    final mission = MissionModel(
      id: _idController.text.trim(),
      number: int.tryParse(_numberController.text.trim()) ?? widget.nextMissionNumber,
      title: title,
      habitName: habitName,
      habitDescription: _habitDescController.text.trim(),
      rewardStars: int.tryParse(_starsController.text.trim()) ?? 3,
      rewardPoints: int.tryParse(_pointsController.text.trim()) ?? 150,
      storyScenes: scenesToSave,
      quiz: quiz,
    );

    widget.onSave(mission);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.initialMission != null;

    return AppScaffold(
      title: isEditing ? 'تعديل المهمة رقم ${widget.initialMission!.number}' : 'إضافة مهمة وعادة جديدة',
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Container(
            color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              dividerHeight: 0,
              indicatorColor: AppColors.terracottaOrange,
              labelColor: AppColors.terracottaOrange,
              unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              tabs: const [
                Tab(text: 'البيانات الأساسية'),
                Tab(text: 'مشاهد القصة'),
                Tab(text: 'السؤال والتحدي'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicInfoTab(isDark),
                _buildStoryScenesTab(isDark),
                _buildQuizTab(isDark),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
          border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
        ),
        child: AppButton(
          text: isEditing ? 'حفظ التعديلات' : 'إضافة المهمة إلى العالم رقم ${widget.worldNumber}',
          variant: AppButtonVariant.primary,
          height: 48,
          onPressed: _saveMission,
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المعرف ورقم الترتيب',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        label: 'معرف المهمة (ID)',
                        controller: _idController,
                        hint: 'w1_m1',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: AppTextField(
                        label: 'رقم المهمة',
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        hint: '1',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العنوان والعادة السلوكية',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'عنوان المهمة للطفل',
                  controller: _titleController,
                  hint: 'عنوان المهمة',
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'اسم العادة أو القيمة',
                  controller: _habitNameController,
                  hint: 'اسم العادة',
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'وصف العادة والشرح التربوي',
                  controller: _habitDescController,
                  hint: 'اكتب الشرح الإيجابي للعادة',
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المكافآت (النجوم والنقاط)',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'النجوم',
                        controller: _starsController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppTextField(
                        label: 'النقاط',
                        controller: _pointsController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStoryScenesTab(bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: AppButton(
            text: 'إضافة مشهد جديد للقصة',
            variant: AppButtonVariant.secondary,
            height: 44,
            onPressed: () {
              setState(() {
                _scenes.add(
                  StorySceneModel(
                    sceneIndex: _scenes.length,
                    speakerName: 'PORT',
                    dialogue: 'اكتب حوار المشهد هنا',
                    sceneDescription: 'وصف المشهد المرئي',
                    backgroundTheme: 'forest_day',
                  ),
                );
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: _scenes.length,
            itemBuilder: (context, index) {
              final scene = _scenes[index];
              return AppCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('المشهد رقم ${index + 1}', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        if (_scenes.length > 1)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _scenes.removeAt(index);
                              });
                            },
                            child: const Text('حذف المشهد', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                          ),
                      ],
                    ),
                    const Divider(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _speakers.contains(scene.speakerName) ? scene.speakerName : 'PORT',
                      decoration: InputDecoration(
                        labelText: 'الشخصية المتحدثة',
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: _speakers.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _scenes[index] = scene.copyWith(speakerName: val);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: scene.dialogue,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'نص الحوار والكلام',
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (val) {
                        _scenes[index] = scene.copyWith(dialogue: val);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: scene.sceneDescription,
                      decoration: InputDecoration(
                        labelText: 'وصف المشهد المرئي',
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (val) {
                        _scenes[index] = scene.copyWith(sceneDescription: val);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuizTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('نص الموقف والسؤال', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'الموقف والسيناريو',
                  controller: _situationController,
                  hint: 'الموقف التفاعلي',
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'نص السؤال',
                  controller: _questionController,
                  hint: 'ما هو التصرف الأكثر إيجابية؟',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('خيارات الإجابة', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('الإجابة الصحيحة:', style: AppTypography.bodySmall),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _correctKeyId,
                      items: ['A', 'B', 'C', 'D'].map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _correctKeyId = val);
                      },
                    ),
                  ],
                ),
                const Divider(height: 16),
                _buildOptionEditor('A', _optAText, _optAExp, isDark),
                const SizedBox(height: 10),
                _buildOptionEditor('B', _optBText, _optBExp, isDark),
                const SizedBox(height: 10),
                _buildOptionEditor('C', _optCText, _optCExp, isDark),
                const SizedBox(height: 10),
                _buildOptionEditor('D', _optDText, _optDExp, isDark),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('التغذية الراجعة والتشجيع', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'رسالة التشجيع عند الإجابة الصحيحة',
                  controller: _correctFeedbackController,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'رسالة التوجيه اللطيف عند الخطأ',
                  controller: _wrongFeedbackController,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildOptionEditor(String keyId, TextEditingController textCtrl, TextEditingController expCtrl, bool isDark) {
    final isCorrect = _correctKeyId == keyId;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isCorrect ? AppColors.mintGreen.withAlpha(25) : (isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCorrect ? AppColors.mintGreen : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
          width: isCorrect ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? 'الخيار $keyId (الإجابة الصحيحة)' : 'الخيار $keyId',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCorrect ? AppColors.mintGreen : null,
            ),
          ),
          const SizedBox(height: 6),
          AppTextField(
            hint: 'نص الخيار $keyId',
            controller: textCtrl,
          ),
          const SizedBox(height: 6),
          AppTextField(
            hint: 'التفسير والتعليل التربوي',
            controller: expCtrl,
          ),
        ],
      ),
    );
  }
}
