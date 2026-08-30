import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/database/hive_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/network/offline_first_sync_manager.dart';
import 'features/child/presentation/bloc/child_bloc.dart';
import 'features/child/presentation/bloc/quiz_bloc.dart';
import 'features/child/presentation/bloc/story_bloc.dart';
import 'features/organization/presentation/bloc/org_bloc.dart';
import 'features/parent/presentation/bloc/parent_bloc.dart';
import 'features/splash_and_auth/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة البيانات المحلية Hive والمزامنة السحابية Offline-First مع Supabase
  await HiveService.init();
  await OfflineFirstSyncManager.initializeAndSync();

  runApp(const PortApp());
}

/// تطبيق PORT - بناء العادات والقيم للأطفال والأسر والمنظمات التعليمية
class PortApp extends StatelessWidget {
  const PortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<ChildBloc>(
          create: (_) => ChildBloc()..add(LoadChildProfileEvent()),
        ),
        BlocProvider<StoryBloc>(
          create: (_) => StoryBloc(),
        ),
        BlocProvider<QuizBloc>(
          create: (_) => QuizBloc(),
        ),
        BlocProvider<ParentBloc>(
          create: (_) => ParentBloc()..add(LoadParentDashboardEvent()),
        ),
        BlocProvider<OrgBloc>(
          create: (_) => OrgBloc()..add(LoadOrgDataEvent()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'PORT - تطبيق العادات والقيم',
            debugShowCheckedModeBanner: false,
            // اتجاه الواجهة من اليمين لليسار (RTL) للغة العربية
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
