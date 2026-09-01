import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/network/supabase_config.dart';
import '../../../child/data/models/child_models.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';
import '../widgets/world_editor_dialog.dart';
import '../widgets/announcement_dialog.dart';
import '../widgets/child_stats_edit_dialog.dart';
import 'mission_editor_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchChildController = TextEditingController();
  String _childSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    context.read<AdminBloc>().add(const LoadAdminDashboardEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchChildController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.mintGreen,
            ),
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        return AppScaffold(
          title: 'لوحة تحكم المشرف',
          padding: EdgeInsets.zero,
          actions: [
            TextButton(
              onPressed: () {
                context.read<AdminBloc>().add(const ForceSyncEvent());
              },
              child: const Text('مزامنة', style: TextStyle(color: AppColors.qortColor)),
            ),
            TextButton(
              onPressed: () {
                context.read<AdminBloc>().add(const LoadAdminDashboardEvent());
              },
              child: const Text('تحديث'),
            ),
          ],
          body: Column(
            children: [
              Container(
                color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  indicatorColor: AppColors.terracottaOrange,
                  labelColor: AppColors.terracottaOrange,
                  unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  tabs: const [
                    Tab(text: 'الإحصائيات'),
                    Tab(text: 'العوالم والمهام'),
                    Tab(text: 'الأطفال والطلاب'),
                    Tab(text: 'الإعلانات'),
                    Tab(text: 'السحابة والصيانة'),
                  ],
                ),
              ),

              Expanded(
                child: state.status == AdminStatus.loading && state.worlds.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOverviewTab(context, state, isDark),
                          _buildWorldsManagementTab(context, state, isDark),
                          _buildChildrenTab(context, state, isDark),
                          _buildAnnouncementsTab(context, state, isDark),
                          _buildCloudMaintenanceTab(context, state, isDark),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==============================================================================
  // Key performance indicators and metrics.
  // ==============================================================================
  Widget _buildOverviewTab(BuildContext context, AdminState state, bool isDark) {
    final stats = state.stats;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            backgroundColor: AppColors.portColor.withAlpha(20),
            borderColor: AppColors.portColor.withAlpha(70),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المزامنة السحابية لـ Supabase',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'رفع كافة العوالم والمهام الافتراضية إلى قاعدة بيانات Supabase بنقرة واحدة',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: state.isSeeding ? 'جاري الرفع إلى Supabase...' : 'رفع الـ 30 مهمة الافتراضية إلى السحابة',
                  variant: AppButtonVariant.primary,
                  height: 44,
                  onPressed: state.isSeeding
                      ? null
                      : () {
                          context.read<AdminBloc>().add(const SeedInitialDataEvent());
                        },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'إجمالي الأطفال',
                  value: stats.totalChildren.toString(),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard(
                  title: 'أولياء الأمور',
                  value: stats.totalParents.toString(),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'المهام المنجزة',
                  value: stats.totalCompletedMissions.toString(),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard(
                  title: 'المنظمات والمدارس',
                  value: stats.totalOrganizations.toString(),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'إجمالي النجوم الممنوحة',
                  value: stats.totalStarsGiven.toString(),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard(
                  title: 'إجمالي النقاط الممنوحة',
                  value: stats.totalPointsGiven.toString(),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          AppCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stats.isSupabaseConnected ? 'اتصال Supabase نشط ومتزامن' : 'الاتصال السحابي غير مفعل / وضع محلي',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  SupabaseConfig.supabaseUrl,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required bool isDark,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================================
  // ==============================================================================
  Widget _buildWorldsManagementTab(BuildContext context, AdminState state, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: AppButton(
            text: 'إضافة عالم ومرحلة جديدة',
            variant: AppButtonVariant.primary,
            height: 44,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => WorldEditorDialog(
                  nextWorldNumber: state.worlds.length + 1,
                  onSave: (world) {
                    context.read<AdminBloc>().add(SaveWorldEvent(world));
                  },
                ),
              );
            },
          ),
        ),
        Expanded(
          child: state.worlds.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('لا توجد عوالم بعد'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdminBloc>().add(const SeedInitialDataEvent());
                        },
                        child: const Text('استيراد العوالم الافتراضية'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: state.worlds.length,
                  itemBuilder: (context, index) {
                    final world = state.worlds[index];
                    return AppCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(side: BorderSide.none),
                        leading: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: world.worldColor.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '#${world.worldNumber}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: world.worldColor),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                world.name,
                                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (world.isPremium)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.warmGold.withAlpha(40),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('باقة التميز', style: TextStyle(fontSize: 10, color: AppColors.warmGold)),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          '${world.missions.length} مهام • ${world.description}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MissionEditorScreen(
                                      worldNumber: world.worldNumber,
                                      nextMissionNumber: world.missions.length + 1,
                                      onSave: (mission) {
                                        context.read<AdminBloc>().add(
                                          SaveMissionEvent(worldNumber: world.worldNumber, mission: mission),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: const Text('إضافة مهمة', style: TextStyle(color: AppColors.mintGreen, fontSize: 12)),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => WorldEditorDialog(
                                    initialWorld: world,
                                    nextWorldNumber: world.worldNumber,
                                    onSave: (updated) {
                                      context.read<AdminBloc>().add(SaveWorldEvent(updated));
                                    },
                                  ),
                                );
                              },
                              child: const Text('تعديل', style: TextStyle(fontSize: 12)),
                            ),
                            TextButton(
                              onPressed: () {
                                _confirmDeleteWorld(context, world);
                              },
                              child: const Text('حذف', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                            ),
                          ],
                        ),
                        children: [
                          const Divider(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  'قائمة المهام والعادات (${world.missions.length})',
                                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                TextButton(
                                  child: const Text('إضافة مهمة جديدة لهذا العالم', style: TextStyle(fontSize: 12)),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => MissionEditorScreen(
                                          worldNumber: world.worldNumber,
                                          nextMissionNumber: world.missions.length + 1,
                                          onSave: (mission) {
                                            context.read<AdminBloc>().add(
                                              SaveMissionEvent(worldNumber: world.worldNumber, mission: mission),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (world.missions.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('لا توجد مهام في هذا العالم حتى الآن.'),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: world.missions.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, mIndex) {
                                final mission = world.missions[mIndex];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppColors.portColor.withAlpha(30),
                                    child: Text('${mission.number}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.portColor)),
                                  ),
                                  title: Text(mission.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                  subtitle: Text(
                                    'عادة: ${mission.habitName} • ${mission.rewardStars} نجوم • ${mission.rewardPoints} نقطة • ${mission.storyScenes.length} مشاهد',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        child: const Text('تعديل', style: TextStyle(color: AppColors.terracottaOrange, fontSize: 12)),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => MissionEditorScreen(
                                                worldNumber: world.worldNumber,
                                                initialMission: mission,
                                                nextMissionNumber: mission.number,
                                                onSave: (updatedMission) {
                                                  context.read<AdminBloc>().add(
                                                    SaveMissionEvent(
                                                      worldNumber: world.worldNumber,
                                                      mission: updatedMission,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('حذف', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                                        onPressed: () {
                                          _confirmDeleteMission(context, world.worldNumber, mission);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _confirmDeleteWorld(BuildContext context, WorldModel world) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('حذف العالم رقم ${world.worldNumber}؟'),
        content: Text('هل أنت متأكد من حذف ${world.name} وكافة المهام المرتبطة به؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              context.read<AdminBloc>().add(DeleteWorldEvent(world.worldNumber));
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMission(BuildContext context, int worldNumber, MissionModel mission) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('حذف المهمة رقم ${mission.number}؟'),
        content: Text('هل أنت متأكد من حذف مهمة "${mission.title}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              context.read<AdminBloc>().add(
                DeleteMissionEvent(worldNumber: worldNumber, missionId: mission.id),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ==============================================================================
  // ==============================================================================
  Widget _buildChildrenTab(BuildContext context, AdminState state, bool isDark) {
    final filtered = state.children.where((c) {
      if (_childSearchQuery.isEmpty) return true;
      final q = _childSearchQuery.toLowerCase();
      final idMatch = c.childId.toLowerCase().contains(q);
      final nameMatch = c.name.toLowerCase().contains(q);
      return idMatch || nameMatch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _searchChildController,
            onChanged: (val) => setState(() => _childSearchQuery = val),
            decoration: InputDecoration(
              hintText: 'بحث بكود الطفل أو الاسم',
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              filled: true,
              fillColor: isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    state.children.isEmpty
                        ? 'لم يتم تسجيل أطفال في Supabase بعد.'
                        : 'لا توجد نتائج مطابقة للبحث.',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final child = filtered[index];
                    return AppCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(child.name, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.mintGreen.withAlpha(30),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(child.childId, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.mintGreen)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'النقاط: ${child.points} • النجوم: ${child.stars} • العالم: #${child.currentWorld}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                  ),
                                ),
                                if (child.parentEmail != null)
                                  Text(
                                    'ولي الأمر: ${child.parentEmail}',
                                    style: TextStyle(fontSize: 11, color: AppColors.qortColor.withAlpha(200)),
                                  ),
                              ],
                            ),
                          ),
                          TextButton(
                            child: const Text('تعديل الرصيد', style: TextStyle(color: AppColors.terracottaOrange, fontSize: 12)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => ChildStatsEditDialog(
                                  child: child,
                                  onSave: (stars, points, world) {
                                    context.read<AdminBloc>().add(
                                      UpdateChildStatsEvent(
                                        childCode: child.childId,
                                        stars: stars,
                                        points: points,
                                        currentWorld: world,
                                      ),
                                    );
                                  },
                                ),
                              );
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

  // ==============================================================================
  // ==============================================================================
  Widget _buildAnnouncementsTab(BuildContext context, AdminState state, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: AppButton(
            text: 'نشر إعلان وتوجيه جديد',
            variant: AppButtonVariant.primary,
            height: 44,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AnnouncementDialog(
                  onPublish: (announcement) {
                    context.read<AdminBloc>().add(CreateAnnouncementEvent(announcement));
                  },
                ),
              );
            },
          ),
        ),
        Expanded(
          child: state.announcements.isEmpty
              ? const Center(
                  child: Text('لا توجد إعلانات نشطة حالياً.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: state.announcements.length,
                  itemBuilder: (context, index) {
                    final item = state.announcements[index];
                    return AppCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(item.title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<AdminBloc>().add(DeleteAnnouncementEvent(item.id));
                                },
                                child: const Text('حذف', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(item.content, style: AppTypography.bodyMedium),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text('الموجهين: ${item.targetRole}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              const Spacer(),
                              Text(
                                '${item.createdAt.year}-${item.createdAt.month}-${item.createdAt.day}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
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

  // ==============================================================================
  // ==============================================================================
  Widget _buildCloudMaintenanceTab(BuildContext context, AdminState state, bool isDark) {
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
                Text('بيانات وإعدادات الربط مع Supabase', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                const Divider(height: 16),
                Text('Supabase URL:', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                SelectableText(SupabaseConfig.supabaseUrl, style: const TextStyle(color: AppColors.qortColor, fontSize: 13)),
                const SizedBox(height: 10),
                Text('حالة الاتصال:', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  SupabaseConfig.isConfigured ? 'مُهيأ وجاهز للعمل السحابي' : 'غير مُهيأ',
                  style: TextStyle(color: SupabaseConfig.isConfigured ? AppColors.mintGreen : Colors.redAccent),
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
                Text('أدوات الصيانة والمزامنة اليدوية', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                const Divider(height: 16),
                AppButton(
                  text: 'مزامنة كاملة وسحب أحدث بيانات من السحابة',
                  variant: AppButtonVariant.primary,
                  height: 44,
                  onPressed: () {
                    context.read<AdminBloc>().add(const ForceSyncEvent());
                  },
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: 'رفع كافة العوالم والـ 30 مهمة الافتراضية إلى Supabase',
                  variant: AppButtonVariant.secondary,
                  height: 44,
                  onPressed: () {
                    context.read<AdminBloc>().add(const SeedInitialDataEvent());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
