import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shapes/port_shape_avatar.dart';
import '../../data/models/child_models.dart';
import '../bloc/child_bloc.dart';
import '../widgets/world_scenery_painter.dart';
import 'mission_selection_screen.dart';

/// World details screen with Interactive Adventure Mission Map and List View.
class WorldScreen extends StatefulWidget {
  final WorldModel world;

  const WorldScreen({super.key, required this.world});

  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen>
    with SingleTickerProviderStateMixin {
  bool _isMapView = true;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    // Preload the current active mission audio in the background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.world.missions.isNotEmpty) {
        final profile = context.read<ChildBloc>().state.profile;
        for (final mission in widget.world.missions) {
          if (!profile.completedMissions.contains(mission.id)) {
            TtsService().preloadMissionAudio(mission);
            break;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final world = widget.world;

    return BlocBuilder<ChildBloc, ChildState>(
      builder: (context, state) {
        final completedMissions = state.profile.completedMissions;
        final selectedCharacter = state.profile.selectedCharacter;
        final completedCount = world.missions
            .where((m) => completedMissions.contains(m.id))
            .length;
        final totalCount = world.missions.length;
        final isAllCompleted = completedCount == totalCount && totalCount > 0;

        return AppScaffold(
          title: world.name,
          subtitle: 'اختر مهمتك وانطلق في المغامرة',
          showBackButton: true,
          showThemeToggle: false,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          body: Column(
            children: [
              // 1. World Progress & Scenery Header Card
              _buildWorldHeaderCard(
                world: world,
                completedCount: completedCount,
                totalCount: totalCount,
                isDark: isDark,
              ),
              const SizedBox(height: 10),

              // 2. View Toggle Header (خريطة المغامرة / قائمة المهمات)
              _buildViewToggleHeader(isDark),
              const SizedBox(height: 10),

              // 3. Dynamic Content: Adventure Map View OR Classic List View
              Expanded(
                child: _isMapView
                    ? _buildInteractiveMissionMapView(
                        world: world,
                        completedMissions: completedMissions,
                        selectedCharacter: selectedCharacter,
                        isAllCompleted: isAllCompleted,
                        isDark: isDark,
                      )
                    : _buildClassicMissionListView(
                        world: world,
                        completedMissions: completedMissions,
                        isDark: isDark,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Compact, rich world scenery & progress banner
  Widget _buildWorldHeaderCard({
    required WorldModel world,
    required int completedCount,
    required int totalCount,
    required bool isDark,
  }) {
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;

    return AppCard(
      padding: EdgeInsets.zero,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
      borderWidth: 1,
      child: Column(
        children: [
          // Visual scenery canvas
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.cardRadiusValue),
            ),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: CustomPaint(
                painter: WorldSceneryPainter(
                  worldNumber: world.worldNumber,
                  isUnlocked: true,
                  isDark: isDark,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        world.name,
                        style: AppTypography.titleMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textCharcoal,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.softMintBackground,
                        borderRadius: AppRadius.badge,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '$completedCount من $totalCount مكتملة',
                        style: const TextStyle(
                          color: AppColors.sageGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Linear Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceVariant
                        : const Color(0xFFEFEBE4),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? AppColors.warmGold : AppColors.sageGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Toggle bar between Adventure Map View and List View
  Widget _buildViewToggleHeader(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFEFEBE4),
        borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFDDD8D0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Map View Option
          Expanded(
            child: InkWell(
              onTap: () {
                if (!_isMapView) setState(() => _isMapView = true);
              },
              borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 9),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _isMapView ? AppColors.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                  boxShadow: _isMapView
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_rounded,
                      size: 17,
                      color: _isMapView
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'خريطة المغامرة',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _isMapView
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // List View Option
          Expanded(
            child: InkWell(
              onTap: () {
                if (_isMapView) setState(() => _isMapView = false);
              },
              borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 9),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !_isMapView ? AppColors.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
                  boxShadow: !_isMapView
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.view_list_rounded,
                      size: 17,
                      color: !_isMapView
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'قائمة المهمات',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: !_isMapView
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textMuted),
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

  /// Winding Adventure Map View for Missions
  Widget _buildInteractiveMissionMapView({
    required WorldModel world,
    required List<String> completedMissions,
    required String selectedCharacter,
    required bool isAllCompleted,
    required bool isDark,
  }) {
    final missions = world.missions;

    // Determine the current active mission index
    int activeMissionIndex = -1;
    for (int i = 0; i < missions.length; i++) {
      final isDone = completedMissions.contains(missions[i].id);
      if (!isDone) {
        final isAvailable =
            i == 0 || completedMissions.contains(missions[i - 1].id);
        if (isAvailable) {
          activeMissionIndex = i;
          break;
        }
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              final isCompleted = completedMissions.contains(mission.id);
              final isAvailable = index == 0 ||
                  completedMissions.contains(missions[index - 1].id) ||
                  isCompleted;
              final isCurrentActive = index == activeMissionIndex;

              // Alternating serpentine path alignment: Left -> Center -> Right -> Center
              Alignment nodeAlignment;
              if (index % 4 == 0) {
                nodeAlignment = const Alignment(-0.55, 0);
              } else if (index % 4 == 1) {
                nodeAlignment = Alignment.center;
              } else if (index % 4 == 2) {
                nodeAlignment = const Alignment(0.55, 0);
              } else {
                nodeAlignment = Alignment.center;
              }

              return Column(
                children: [
                  // Connecting curved trail path from previous node
                  if (index > 0)
                    CustomPaint(
                      size: const Size(double.infinity, 65),
                      painter: _MissionTrailPainter(
                        isDark: isDark,
                        isUnlocked: isAvailable,
                        isLeadingToActive: isCurrentActive,
                        worldColor: world.worldColor,
                        fromIndex: index - 1,
                        toIndex: index,
                      ),
                    ),

                  Align(
                    alignment: nodeAlignment,
                    child: _buildMissionMapNode(
                      mission: mission,
                      isCompleted: isCompleted,
                      isAvailable: isAvailable,
                      isCurrentActive: isCurrentActive,
                      selectedCharacter: selectedCharacter,
                      worldColor: world.worldColor,
                      isDark: isDark,
                    ),
                  ),
                ],
              );
            },
          ),

          // Trail leading to the Grand World Treasure Chest at the end
          if (missions.isNotEmpty)
            CustomPaint(
              size: const Size(double.infinity, 65),
              painter: _MissionTrailPainter(
                isDark: isDark,
                isUnlocked: isAllCompleted,
                isLeadingToActive: !isAllCompleted && activeMissionIndex == missions.length - 1,
                worldColor: world.worldColor,
                fromIndex: missions.length - 1,
                toIndex: 1, // Ends in center
              ),
            ),

          // World Trophy / Mystery Treasure Chest Milestone
          _buildWorldTrophyMilestone(
            world: world,
            isAllCompleted: isAllCompleted,
            remainingCount: missions.length -
                missions.where((m) => completedMissions.contains(m.id)).length,
            isDark: isDark,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Individual Mission Map Node
  Widget _buildMissionMapNode({
    required MissionModel mission,
    required bool isCompleted,
    required bool isAvailable,
    required bool isCurrentActive,
    required String selectedCharacter,
    required Color worldColor,
    required bool isDark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Character avatar & banner for the active mission
        if (isCurrentActive) ...[
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final bounce = math.sin(_pulseController.value * math.pi) * 3.5;
              return Transform.translate(
                offset: Offset(0, bounce),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PortShapeAvatar(
                          characterName: selectedCharacter,
                          size: 38,
                          showBadge: false,
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.terracottaOrange,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.terracottaOrange
                                    .withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'أنت هنا يا بطل!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(Icons.arrow_downward_rounded,
                                  size: 13, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              );
            },
          ),
        ] else if (isCompleted) ...[
          // 3 Shiny Golden Stars floating above completed mission
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 14, color: AppColors.warmGold),
              Icon(Icons.star_rounded, size: 18, color: AppColors.warmGold),
              Icon(Icons.star_rounded, size: 14, color: AppColors.warmGold),
            ],
          ),
          const SizedBox(height: 3),
        ],

        // Circular Node Button
        InkWell(
          onTap: isAvailable
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MissionSelectionScreen(mission: mission),
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(50),
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final pulseScale = isCurrentActive
                  ? 1.0 + (_pulseController.value * 0.07)
                  : 1.0;

              return Transform.scale(
                scale: pulseScale,
                child: Container(
                  width: isCurrentActive ? 64 : 54,
                  height: isCurrentActive ? 64 : 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.sageGreen
                        : (isCurrentActive
                            ? AppColors.terracottaOrange
                            : (isDark
                                ? AppColors.darkSurfaceVariant
                                : const Color(0xFFD6CECE))),
                    boxShadow: [
                      if (isCurrentActive)
                        BoxShadow(
                          color: AppColors.terracottaOrange
                              .withValues(alpha: 0.45),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        )
                      else if (isCompleted)
                        BoxShadow(
                          color: AppColors.sageGreen.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                    ],
                    border: Border.all(
                      color: isCompleted
                          ? Colors.white
                          : (isCurrentActive
                              ? Colors.white
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder)),
                      width: isCurrentActive ? 3.0 : 2.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isCompleted
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 28)
                      : (isAvailable
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${mission.number}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                if (isCurrentActive)
                                  const Icon(Icons.play_arrow_rounded,
                                      color: Colors.white, size: 14),
                              ],
                            )
                          : const Icon(Icons.lock_rounded,
                              color: Color(0xFF8C827A), size: 22)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),

        // Mission Title & Habit Badge
        InkWell(
          onTap: isAvailable
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MissionSelectionScreen(mission: mission),
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(AppRadius.cardRadiusValue),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 165),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrentActive
                    ? AppColors.terracottaOrange
                    : (isCompleted
                        ? AppColors.sageGreen.withValues(alpha: 0.5)
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder)),
                width: isCurrentActive ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  mission.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isAvailable
                        ? (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textCharcoal)
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textLightMuted),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'عادة: ${mission.habitName}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: isCompleted
                        ? AppColors.sageGreen
                        : (isCurrentActive
                            ? AppColors.terracottaOrange
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textMuted)),
                    fontWeight: isCompleted || isCurrentActive
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Grand World Trophy / Milestone Node at the end of the map
  Widget _buildWorldTrophyMilestone({
    required WorldModel world,
    required bool isAllCompleted,
    required int remainingCount,
    required bool isDark,
  }) {
    return AppCard(
      backgroundColor: isAllCompleted
          ? (isDark ? const Color(0xFF2A2415) : const Color(0xFFFFF8E7))
          : (isDark ? AppColors.darkSurface : AppColors.pureWhite),
      borderWidth: 1.5,
      borderColor: isAllCompleted ? AppColors.warmGold : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAllCompleted
                  ? AppColors.warmGold
                  : (isDark
                      ? AppColors.darkSurfaceVariant
                      : const Color(0xFFF0EBE5)),
              boxShadow: isAllCompleted
                  ? [
                      BoxShadow(
                        color: AppColors.warmGold.withValues(alpha: 0.45),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Icon(
              isAllCompleted
                  ? Icons.emoji_events_rounded
                  : Icons.card_giftcard_rounded,
              color: isAllCompleted ? Colors.white : const Color(0xFF8C827A),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAllCompleted
                      ? 'مغامرة ${world.name} مكتملة! 🏆'
                      : 'كنز عالم ${world.name} 🎁',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isAllCompleted
                        ? AppColors.warmGoldDark
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textCharcoal),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isAllCompleted
                      ? 'أحسنت يا بطل! لقد أتممت جميع مهمات هذا العالم بنجاح باهر.'
                      : 'أكمل $remainingCount مهمات إضافية لفتح كنز ووسام هذا العالم!',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Classic List View (original cards preserved)
  Widget _buildClassicMissionListView({
    required WorldModel world,
    required List<String> completedMissions,
    required bool isDark,
  }) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: world.missions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final mission = world.missions[index];
        final isCompleted = completedMissions.contains(mission.id);
        final isAvailable = index == 0 ||
            completedMissions.contains(world.missions[index - 1].id) ||
            isCompleted;

        return AppCard(
          borderWidth: 1,
          backgroundColor: isAvailable
              ? (isDark ? AppColors.darkSurface : AppColors.pureWhite)
              : (isDark
                  ? AppColors.darkSurfaceVariant
                  : const Color(0xFFF5EBE0).withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          onTap: isAvailable
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MissionSelectionScreen(mission: mission),
                    ),
                  );
                }
              : null,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.sageGreen
                      : (isAvailable
                          ? AppColors.terracottaOrange
                          : const Color(0xFFB0A695)),
                  shape: BoxShape.circle,
                  boxShadow: isAvailable && !isCompleted
                      ? [
                          BoxShadow(
                            color: AppColors.terracottaOrange
                                .withValues(alpha: 0.35),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  '${mission.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: AppTypography.titleSmall.copyWith(
                        color: isAvailable
                            ? (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textCharcoal)
                            : AppColors.textLightMuted,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.softMintBackground,
                            borderRadius: AppRadius.badge,
                          ),
                          child: Text(
                            'عادة: ${mission.habitName}',
                            style: const TextStyle(
                              color: AppColors.sageGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${mission.rewardStars} نجوم',
                          style: const TextStyle(
                            color: AppColors.warmGoldDark,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (isCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.softMintBackground,
                    borderRadius: AppRadius.badge,
                    border: Border.all(color: AppColors.sageGreen, width: 1),
                  ),
                  child: const Text(
                    'مكتملة',
                    style: TextStyle(
                      color: AppColors.sageGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (isAvailable)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.terracottaOrange,
                    borderRadius: AppRadius.button,
                  ),
                  child: const Text(
                    'ابدأ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const Text(
                  'مقفل',
                  style: TextStyle(
                    color: AppColors.textLightMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom painter for the serpentine mission adventure trail
class _MissionTrailPainter extends CustomPainter {
  final bool isDark;
  final bool isUnlocked;
  final bool isLeadingToActive;
  final Color worldColor;
  final int fromIndex;
  final int toIndex;

  _MissionTrailPainter({
    required this.isDark,
    required this.isUnlocked,
    required this.isLeadingToActive,
    required this.worldColor,
    required this.fromIndex,
    required this.toIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final startX = _getXOffset(fromIndex, size.width);
    final endX = _getXOffset(toIndex, size.width);

    final path = Path();
    path.moveTo(startX, 0);
    path.cubicTo(
      startX,
      size.height * 0.5,
      endX,
      size.height * 0.5,
      endX,
      size.height,
    );

    if (isUnlocked) {
      final paint = Paint()
        ..color = AppColors.sageGreen
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, paint);

      // Stepping stone dots along the trail
      final metric = path.computeMetrics().firstOrNull;
      if (metric != null) {
        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        for (double d = 0.25; d <= 0.75; d += 0.25) {
          final pos = metric.getTangentForOffset(metric.length * d)?.position;
          if (pos != null) {
            canvas.drawCircle(pos, 2.8, dotPaint);
          }
        }
      }
    } else if (isLeadingToActive) {
      final paint = Paint()
        ..color = AppColors.terracottaOrange
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      _drawDashedPath(canvas, path, paint);
    } else {
      final paint = Paint()
        ..color = isDark ? AppColors.darkBorder : const Color(0xFFD6CECE)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      _drawDashedPath(canvas, path, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metric = path.computeMetrics().firstOrNull;
    if (metric == null) return;
    const double dashLength = 8.0;
    const double dashSpace = 6.0;
    double distance = 0.0;
    while (distance < metric.length) {
      final extractLength = math.min(dashLength, metric.length - distance);
      final segment = metric.extractPath(distance, distance + extractLength);
      canvas.drawPath(segment, paint);
      distance += dashLength + dashSpace;
    }
  }

  double _getXOffset(int index, double width) {
    if (index % 4 == 0) {
      return width * 0.23;
    } else if (index % 4 == 1) {
      return width * 0.50;
    } else if (index % 4 == 2) {
      return width * 0.77;
    } else {
      return width * 0.50;
    }
  }

  @override
  bool shouldRepaint(covariant _MissionTrailPainter oldDelegate) {
    return oldDelegate.isUnlocked != isUnlocked ||
        oldDelegate.isLeadingToActive != isLeadingToActive ||
        oldDelegate.isDark != isDark ||
        oldDelegate.fromIndex != fromIndex ||
        oldDelegate.toIndex != toIndex;
  }
}
