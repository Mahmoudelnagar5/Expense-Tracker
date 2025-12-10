import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'core/routing/app_router.dart';
import 'core/services/app_lock_service.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/settings/presentation/controller/settings_cubit.dart';

class MyApp extends StatefulWidget {
  final bool isSetupComplete;

  const MyApp({super.key, required this.isSetupComplete});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;
  final AppLockService _appLockService = AppLockService();
  bool _hasShownInitialLock = false;

  @override
  void initState() {
    super.initState();
    // Create router once and keep it
    _router = AppRouter.getRouter(widget.isSetupComplete);

    // Reset lock service state for fresh app start
    _appLockService.reset();

    // Show lock screen after app is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _showLockScreenIfNeeded();
      });
    });
  }

  void _showLockScreenIfNeeded() {
    if (_hasShownInitialLock || !_appLockService.shouldLock) return;

    final navContext = _router.routerDelegate.navigatorKey.currentContext;
    if (navContext != null) {
      _hasShownInitialLock = true;
      _appLockService.showLockScreen(navContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) =>
              SettingsCubit(themeCubit: context.read<ThemeCubit>()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (screenUtilContext, child) {
              return MaterialApp.router(
                routerConfig: _router,
                title: 'Expense Tracker',
                debugShowCheckedModeBanner: false,
                theme: LightTheme.theme,
                darkTheme: DarkTheme.theme,
                themeMode: themeMode,
                themeAnimationCurve: Curves.easeInOut,
                themeAnimationDuration: const Duration(milliseconds: 300),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              );
            },
          );
        },
      ),
    );
  }
}
