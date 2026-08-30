import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_3d_model_viewer.dart';
import '../../data/models/child_models.dart';
import '../bloc/story_bloc.dart';
import 'story_complete_screen.dart';

/// 8. شاشة القصة (Story Screen) - الشاشة الأهم
/// سرد القصة التفاعلية عبر الشخصية المتحدثة مع نصوص، حركة بصرية، وأزرار تحكم كاملة:
/// (تشغيل / إيقاف / إعادة القصة / تخطي الحوار / استكمال لاحقاً وحفظ المشهد في Hive).
class StoryScreen extends StatefulWidget {
  final MissionModel mission;

  const StoryScreen({super.key, required this.mission});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  int _lastSceneIndex = -1;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<StoryBloc>().add(NextSceneEvent());
      }
    });
    context.read<StoryBloc>().add(InitStoryEvent(widget.mission));
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _onSaveAndExit() async {
    _progressController.stop();
    final shouldExit = await AppDialog.show(
      context,
      title: 'استكمال القصة لاحقاً',
      message: 'سيتم حفظ آخر مشهد توقفت عنده تلقائياً، ويمكنك العودة وإكمال المغامرة في أي وقت!',
      confirmText: 'حفظ وخروج',
      cancelText: 'البقاء في القصة',
    );

    if (shouldExit == true && mounted) {
      context.read<StoryBloc>().add(SaveAndExitStoryEvent());
      Navigator.of(context).maybePop();
    } else if (mounted && context.read<StoryBloc>().state.isPlaying) {
      _progressController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<StoryBloc, StoryState>(
      listener: (context, state) {
        if (state.isCompleted) {
          _progressController.stop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => StoryCompleteScreen(mission: widget.mission),
            ),
          );
        } else {
          if (_lastSceneIndex != state.currentSceneIndex) {
            _lastSceneIndex = state.currentSceneIndex;
            _progressController.reset();
            if (state.isPlaying) {
              _progressController.forward();
            }
          } else {
            if (state.isPlaying && !_progressController.isAnimating && _progressController.value < 1.0) {
              _progressController.forward();
            } else if (!state.isPlaying && _progressController.isAnimating) {
              _progressController.stop();
            }
          }
        }
      },
      builder: (context, state) {
        final scene = state.currentScene;
        final totalScenes = state.totalScenes;
        final currentIndex = state.currentSceneIndex;

        return AppScaffold(
          title: widget.mission.title,
          subtitle: 'مشهد ${currentIndex + 1} من $totalScenes',
          onBack: _onSaveAndExit,
          actions: [
            // زر استكمال لاحقاً
            InkWell(
              onTap: _onSaveAndExit,
              borderRadius: AppRadius.all,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                  borderRadius: AppRadius.all,
                ),
                child: Text(
                  'استكمال لاحقاً',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ],
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // شريط تقدم مشاهد القصة التفاعلي والمتحرك مع الثواني
              if (totalScenes > 0)
                Row(
                  children: List.generate(totalScenes, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsetsDirectional.only(
                          end: index < totalScenes - 1 ? 6 : 0,
                        ),
                        height: 7,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.sageGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, _) {
                            double segmentValue = 0.0;
                            if (index < currentIndex) {
                              segmentValue = 1.0;
                            } else if (index == currentIndex) {
                              segmentValue = _progressController.value;
                            }
                            return FractionallySizedBox(
                              alignment: AlignmentDirectional.centerStart,
                              widthFactor: segmentValue.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.sageGreen,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),

              const SizedBox(height: 12),

              // نافذة مشهد القصة والبيئة التفاعلية (Story Box - Soft Sage Green)
              Expanded(
                flex: 4,
                child: AppCard(
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.softMintBackground,
                  borderColor: isDark ? AppColors.darkBorder : AppColors.sageGreen.withValues(alpha: 0.3),
                  borderWidth: 1.5,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // مجسم الشخصية 3D التفاعلي الحقيقي
                      Expanded(
                        child: Port3DModelViewer(
                          key: ValueKey('story_glb_${scene?.speakerName ?? 'PORT'}'),
                          characterName: scene?.speakerName ?? 'PORT',
                          height: double.infinity,
                          autoRotate: true,
                          cameraControls: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // وصف المشهد
                      if (scene?.sceneDescription != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceVariant : AppColors.pureWhite,
                            borderRadius: AppRadius.card,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2D2522).withValues(alpha: 0.04),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            scene!.sceneDescription,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // مربع الحوار التفاعلي
              Expanded(
                flex: 3,
                child: AppCard(
                  backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.pureWhite,
                  borderColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.sageGreen,
                              borderRadius: AppRadius.badge,
                            ),
                            child: Text(
                              scene?.speakerName ?? 'PORT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            state.isPlaying ? 'تشغيل تلقائي' : 'متوقف مؤقتاً',
                            style: TextStyle(
                              fontSize: 11,
                              color: state.isPlaying ? AppColors.sageGreen : AppColors.warmGoldDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Text(
                            scene?.dialogue ?? 'جاري تحميل المشهد...',
                            style: AppTypography.titleSmall.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // أدوات التحكم كأيقونات متناسقة في أسفل منتصف كارد النص
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : const Color(0xFFF7F4F0),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // زر إعادة المشهد (أيقونة)
                              InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  _lastSceneIndex = -1;
                                  _progressController.reset();
                                  context.read<StoryBloc>().add(ReplayStoryEvent());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.replay_rounded,
                                    size: 20,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textCharcoal,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 1,
                                height: 16,
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                              const SizedBox(width: 6),
                              // زر تشغيل / إيقاف (أيقونة)
                              InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => context.read<StoryBloc>().add(ToggleStoryPlayPauseEvent()),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    size: 22,
                                    color: state.isPlaying ? AppColors.sageGreen : AppColors.terracottaOrange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // زر المشهد التالي / متابعة الأساسي
              AppButton(
                text: currentIndex + 1 >= totalScenes ? 'إنهاء القصة والتحدي' : 'متابعة المشهد',
                variant: AppButtonVariant.primary,
                height: 50,
                onPressed: () {
                  _progressController.reset();
                  context.read<StoryBloc>().add(NextSceneEvent());
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
