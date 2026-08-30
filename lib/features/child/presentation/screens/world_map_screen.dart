import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_shape_avatar.dart';
import '../../data/models/child_models.dart';
import '../../data/repositories/child_repository.dart';
import '../bloc/child_bloc.dart';
import '../widgets/world_scenery_painter.dart';
import 'mission_selection_screen.dart';
import 'reward_progress_screen.dart';
import 'world_screen.dart';

/// 5. شاشة خريطة العوالم التفاعلية (World Map Screen)
/// تدعم التبديل السلس بين عرض الكروت التفصيلي وخريطة المغامرة التفاعلية (مسار الجزر)
class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({super.key});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  bool _isMapView = false; // التبديل بين عرض الكروت (false) وعرض الخريطة التفاعلية (true)

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final worlds = ChildRepository.worlds;

    return BlocBuilder<ChildBloc, ChildState>(
      builder: (context, state) {
        final profile = state.profile;
        final completedMissions = profile.completedMissions;

        return AppScaffold(
          showBackButton: false,
          showThemeToggle: false,
          padding: EdgeInsets.zero,
          customHeader: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الصف الأول: التحية والرفيق وزر الأوسمة وزر الخريطة وزر الثيم
              Row(
                children: [
                  // صورة الرفيق الرمزية
                  PortShapeAvatar(
                    characterName: profile.selectedCharacter,
                    size: 40,
                    showBadge: false,
                  ),
                  const SizedBox(width: 8),

                  // التحية والرتبة والكود
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'مرحباً، ${profile.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textCharcoal,
                            fontWeight: FontWeight.w900,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2.5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFEFEBE4),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : const Color(0xFFDDD8D0),
                                  width: 0.8,
                                ),
                              ),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  'ID: ${profile.childId}',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                ChildRepository.calculateRankTitle(profile.points),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.sageGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  // عداد النجوم الذهبية
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceVariant : AppColors.warmGoldLight,
                      borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.warmGold.withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 13, color: AppColors.warmGoldDark),
                        const SizedBox(width: 1),
                        Text(
                          '${profile.stars}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                            color: AppColors.warmGoldDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 3),
                  // عداد النقاط
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceVariant : AppColors.softMintBackground,
                      borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.sageGreen.withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded, size: 13, color: AppColors.sageGreen),
                        const SizedBox(width: 1),
                        Text(
                          '${profile.points}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                            color: AppColors.sageGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  // زر أوسمتي
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const RewardProgressScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceVariant : AppColors.warmGoldLight,
                        borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.warmGold.withValues(alpha: 0.4),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.military_tech_rounded, size: 14, color: AppColors.warmGoldDark),
                          SizedBox(width: 2),
                          Text(
                            'أوسمتي',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warmGoldDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // زر تبديل الثيم
                  InkWell(
                    onTap: () => context.read<ThemeCubit>().toggleTheme(),
                    borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceVariant : AppColors.warmCream,
                        borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1.0,
                        ),
                      ),
                      child: Icon(
                        isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                        size: 15,
                        color: isDark ? AppColors.sunnyYellow : AppColors.textCharcoal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // شريط التبديل بين الخريطة والكروت أعلى الجسم (Body)
              _buildViewToggleHeader(isDark),

              // المحتوى المختار
              Expanded(
                child: _isMapView
                    ? _buildInteractiveAdventureMapView(
                        context: context,
                        worlds: worlds,
                        completedMissions: completedMissions,
                        selectedCharacter: profile.selectedCharacter,
                        isDark: isDark,
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: worlds.length,
                        itemBuilder: (context, index) {
                          final world = worlds[index];
                          final isUnlocked = ChildRepository.isWorldUnlocked(
                              world.worldNumber, completedMissions);
                          final isPremium = world.isPremium;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: _buildWorldIslandCard(
                              context: context,
                              world: world,
                              isUnlocked: isUnlocked,
                              isPremium: isPremium,
                              completedMissions: completedMissions,
                              isDark: isDark,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// شريط التبديل التفاعلي بين نمط الخريطة ونمط الكروت في أعلى الـ Body
  Widget _buildViewToggleHeader(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFEFEBE4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFDDD8D0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // خيار خريطة المغامرة
          Expanded(
            child: InkWell(
              onTap: () {
                if (!_isMapView) {
                  setState(() => _isMapView = true);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _isMapView
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isMapView
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.explore_rounded,
                      size: 16,
                      color: _isMapView
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.textCharcoal),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'خريطة المغامرة',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _isMapView
                            ? Colors.white
                            : (isDark ? AppColors.darkTextSecondary : AppColors.textCharcoal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // خيار قائمة العوالم
          Expanded(
            child: InkWell(
              onTap: () {
                if (_isMapView) {
                  setState(() => _isMapView = false);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !_isMapView
                      ? AppColors.terracottaOrange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !_isMapView
                      ? [
                          BoxShadow(
                            color: AppColors.terracottaOrange.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.view_agenda_rounded,
                      size: 16,
                      color: !_isMapView
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.textCharcoal),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'قائمة العوالم',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: !_isMapView
                            ? Colors.white
                            : (isDark ? AppColors.darkTextSecondary : AppColors.textCharcoal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// بناء بطاقة جزيرة العالم المصورة والتفاعلية بدون إيموجي
  Widget _buildWorldIslandCard({
    required BuildContext context,
    required WorldModel world,
    required bool isUnlocked,
    required bool isPremium,
    required List<String> completedMissions,
    required bool isDark,
  }) {
    final worldMissions = world.missions;
    final completedCount =
        worldMissions.where((m) => completedMissions.contains(m.id)).length;
    final totalCount = worldMissions.length;

    return AppCard(
      borderWidth: 1,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. المشهد الفني الكرتوني لبيئة العالم
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 125,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WorldSceneryPainter(
                        worldNumber: world.worldNumber,
                        isUnlocked: isUnlocked,
                        isDark: isDark,
                      ),
                    ),
                  ),

                  // شارة رقم العالم
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2522).withValues(alpha: 0.75),
                        borderRadius: AppRadius.badge,
                      ),
                      child: Text(
                        'العالم ${world.worldNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),

                  // شارة الحالة (متاح الآن / مقفل / باقة التميز)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? AppColors.sageGreen
                            : (isPremium
                                ? AppColors.warmGoldDark
                                : const Color(0xFF716862)),
                        borderRadius: AppRadius.badge,
                      ),
                      child: Text(
                        isUnlocked
                            ? 'متاح الآن'
                            : (isPremium ? 'باقة التميز' : 'مقفل'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. تفاصيل العالم والمهام الخمس
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  world.name,
                  style: AppTypography.displayMedium.copyWith(
                    color: isUnlocked
                        ? (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textCharcoal)
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textMuted),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  world.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textMuted,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 14),

                // 3. مؤشرات المحطات الخمس المصممة هندسياً
                if (isUnlocked) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceVariant
                          : const Color(0xFFFAF7F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(totalCount, (mIndex) {
                        final mission = worldMissions[mIndex];
                        final isMissionDone =
                            completedMissions.contains(mission.id);
                        final isCurrentActive = mIndex == 0 ||
                            completedMissions
                                .contains(worldMissions[mIndex - 1].id);

                        return Column(
                          children: [
                            InkWell(
                              onTap: isCurrentActive || isMissionDone
                                  ? () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MissionSelectionScreen(
                                                  mission: mission),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isMissionDone
                                      ? AppColors.sageGreen
                                      : (isCurrentActive
                                          ? AppColors.terracottaOrange
                                          : (isDark
                                              ? AppColors.darkBorder
                                              : const Color(0xFFD6CECE))),
                                  border: Border.all(
                                    color: isMissionDone
                                        ? AppColors.sageGreen
                                        : (isCurrentActive
                                            ? AppColors.terracottaOrange
                                            : (isDark
                                                ? AppColors.darkBorder
                                                : AppColors.lightBorder)),
                                    width: 1.5,
                                  ),
                                  boxShadow: isCurrentActive
                                      ? [
                                          BoxShadow(
                                            color: AppColors.terracottaOrange
                                                .withValues(alpha: 0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${mIndex + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isMissionDone
                                  ? 'مكتملة'
                                  : (isCurrentActive ? 'ابدأ' : 'قادمة'),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: isMissionDone || isCurrentActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isMissionDone
                                    ? AppColors.sageGreen
                                    : (isCurrentActive
                                        ? AppColors.terracottaOrange
                                        : (isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textMuted)),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // زر الدخول للعالم
                  AppButton(
                    text: completedCount == totalCount
                        ? 'مراجعة مهمات العالم'
                        : 'استعراض مهمات العالم',
                    variant: AppButtonVariant.primary,
                    height: 48,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WorldScreen(world: world),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  // العالم مقفل
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceVariant
                          : const Color(0xFFF3ECE4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFB0A49B),
                            borderRadius: AppRadius.badge,
                          ),
                          child: const Text(
                            'مقفل',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isPremium
                              ? 'يتطلب الاشتراك في باقة التميز'
                              : 'أكمل مهمات العالم السابق لفتح هذه المغامرة',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textCharcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// بناء خريطة المغامرة التفاعلية ومسار الجزر (Interactive Trail Map)
  Widget _buildInteractiveAdventureMapView({
    required BuildContext context,
    required List<WorldModel> worlds,
    required List<String> completedMissions,
    required String selectedCharacter,
    required bool isDark,
  }) {
    // تحديد العالم الحالي الفعال الذي يقف عليه رفيق الطفل
    int currentActiveWorldNumber = 1;
    for (int i = 0; i < worlds.length; i++) {
      final w = worlds[i];
      final isUnlocked = ChildRepository.isWorldUnlocked(w.worldNumber, completedMissions);
      if (isUnlocked) {
        currentActiveWorldNumber = w.worldNumber;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        children: [
          // شريط إرشادي خفيف في أعلى الخريطة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFFAF6F0),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE5DFD7),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.explore_rounded, size: 16, color: AppColors.sageGreen),
                const SizedBox(width: 6),
                Text(
                  'انقر على أي جزيرة مفتوحة لبدء التحديات والمغامرة!',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // مسار الجزر المتعرج (Winding Adventure Path)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: worlds.length,
            itemBuilder: (context, index) {
              final world = worlds[index];
              final isUnlocked = ChildRepository.isWorldUnlocked(world.worldNumber, completedMissions);
              final isPremium = world.isPremium;
              final isCurrentNode = world.worldNumber == currentActiveWorldNumber;
              final worldMissions = world.missions;
              final completedCount = worldMissions.where((m) => completedMissions.contains(m.id)).length;
              final isFullyCompleted = completedCount == worldMissions.length && worldMissions.isNotEmpty;

              // محاذاة متعرجة للجزر (يمين، وسط، يسار، وسط، يمين...)
              Alignment nodeAlignment = Alignment.center;
              if (index % 4 == 0) {
                nodeAlignment = const Alignment(-0.55, 0); // يسار
              } else if (index % 4 == 1) {
                nodeAlignment = Alignment.center; // وسط
              } else if (index % 4 == 2) {
                nodeAlignment = const Alignment(0.55, 0); // يمين
              } else {
                nodeAlignment = Alignment.center;
              }

              return Column(
                children: [
                  // خط الاتصال المتعرج بين الجزر
                  if (index > 0)
                    CustomPaint(
                      size: const Size(double.infinity, 45),
                      painter: _AdventurePathPainter(
                        isDark: isDark,
                        isUnlocked: isUnlocked,
                        fromIndex: index - 1,
                        toIndex: index,
                      ),
                    ),

                  // جزيرة العالم
                  Align(
                    alignment: nodeAlignment,
                    child: _buildAdventureWorldNode(
                      context: context,
                      world: world,
                      isUnlocked: isUnlocked,
                      isPremium: isPremium,
                      isCurrentNode: isCurrentNode,
                      isFullyCompleted: isFullyCompleted,
                      completedCount: completedCount,
                      totalCount: worldMissions.length,
                      selectedCharacter: selectedCharacter,
                      isDark: isDark,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// بناء عقدة الجزيرة في الخريطة التفاعلية
  Widget _buildAdventureWorldNode({
    required BuildContext context,
    required WorldModel world,
    required bool isUnlocked,
    required bool isPremium,
    required bool isCurrentNode,
    required bool isFullyCompleted,
    required int completedCount,
    required int totalCount,
    required String selectedCharacter,
    required bool isDark,
  }) {
    final worldColor = world.worldColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // رفيق الطفل الواقف على الجزيرة الحالية
        if (isCurrentNode && isUnlocked) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.coralOrange,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.coralOrange.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'أنت هنا يا بطل!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_downward_rounded, size: 12, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 4),
          PortShapeAvatar(
            characterName: selectedCharacter,
            size: 44,
            showBadge: false,
          ),
          const SizedBox(height: 6),
        ],

        // الزر الدائري للجزيرة
        InkWell(
          onTap: isUnlocked
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WorldScreen(world: world),
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(50),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCurrentNode ? 96 : 84,
            height: isCurrentNode ? 96 : 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? worldColor
                  : (isDark ? AppColors.darkSurfaceVariant : const Color(0xFFD6CECE)),
              gradient: isUnlocked
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        worldColor.withValues(alpha: 0.85),
                        worldColor,
                      ],
                    )
                  : null,
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: worldColor.withValues(alpha: isCurrentNode ? 0.5 : 0.25),
                        blurRadius: isCurrentNode ? 16 : 8,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
              border: Border.all(
                color: isFullyCompleted
                    ? AppColors.warmGold
                    : (isCurrentNode
                        ? Colors.white
                        : (isUnlocked ? Colors.white.withValues(alpha: 0.6) : Colors.transparent)),
                width: isCurrentNode || isFullyCompleted ? 3.5 : 2.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isUnlocked) ...[
                  // محتوى الجزيرة المفتوحة
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${world.worldNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      if (isFullyCompleted)
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.warmGoldLight)
                      else
                        Text(
                          '$completedCount/$totalCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ] else ...[
                  // الجزيرة المقفلة
                  Icon(
                    isPremium ? Icons.workspace_premium_rounded : Icons.lock_rounded,
                    size: 30,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF8C827A),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 6),

        // اسم العالم
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Text(
            world.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? (isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal)
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
            ),
          ),
        ),
      ],
    );
  }
}

/// رسام المسار المنقط والمموج بين جزر المغامرة
class _AdventurePathPainter extends CustomPainter {
  final bool isDark;
  final bool isUnlocked;
  final int fromIndex;
  final int toIndex;

  _AdventurePathPainter({
    required this.isDark,
    required this.isUnlocked,
    required this.fromIndex,
    required this.toIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isUnlocked
          ? (isDark ? AppColors.sageGreen.withValues(alpha: 0.6) : AppColors.sageGreen)
          : (isDark ? AppColors.darkBorder : const Color(0xFFD6CECE))
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final startX = _getXOffset(fromIndex, size.width);
    final endX = _getXOffset(toIndex, size.width);

    path.moveTo(startX, 0);
    path.cubicTo(
      startX,
      size.height * 0.5,
      endX,
      size.height * 0.5,
      endX,
      size.height,
    );

    // رسم المسار كخط متقطع جميل
    canvas.drawPath(path, paint);
  }

  double _getXOffset(int index, double width) {
    if (index % 4 == 0) {
      return width * 0.25;
    } else if (index % 4 == 1) {
      return width * 0.50;
    } else if (index % 4 == 2) {
      return width * 0.75;
    } else {
      return width * 0.50;
    }
  }

  @override
  bool shouldRepaint(covariant _AdventurePathPainter oldDelegate) {
    return oldDelegate.isUnlocked != isUnlocked ||
        oldDelegate.isDark != isDark ||
        oldDelegate.fromIndex != fromIndex ||
        oldDelegate.toIndex != toIndex;
  }
}
