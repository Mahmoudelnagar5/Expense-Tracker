import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/routing/app_router.dart';
import 'package:expense_tracker_ar/core/services/local_notification_service.dart';
import 'package:expense_tracker_ar/core/theme/dark_theme.dart';
import 'package:expense_tracker_ar/core/theme/light_theme.dart';
import 'package:expense_tracker_ar/core/theme/theme_cubit.dart';
import 'package:expense_tracker_ar/features/settings/presentation/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper_keks.dart';
import 'package:go_router/go_router.dart';

import 'core/services/work_manger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cache
  await CacheHelper().init();

  // Load saved language
  final cacheHelper = CacheHelper();
  final savedLanguage = cacheHelper.getData(key: CacheHelperKeys.language);
  final startLocale = savedLanguage != null
      ? Locale(savedLanguage)
      : const Locale('ar');

  // Check if setup is complete
  final isSetupComplete =
      cacheHelper.getData(key: CacheHelperKeys.isSetupComplete) ?? false;

  // Initialize easy_localization
  await EasyLocalization.ensureInitialized();

  // Defer heavy initializations until after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Future.wait([
      LocalNotificationService.init(),
      WorkManagerService().init(),
    ]);
  });

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: startLocale,
      child: MyApp(isSetupComplete: isSetupComplete),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isSetupComplete;

  const MyApp({super.key, required this.isSetupComplete});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Create router once and keep it
    _router = AppRouter.getRouter(widget.isSetupComplete);
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
            builder: (_, child) {
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
