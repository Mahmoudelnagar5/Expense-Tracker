import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/routing/app_router.dart';
import 'package:expense_tracker_ar/core/theme/dark_theme.dart';
import 'package:expense_tracker_ar/core/theme/light_theme.dart';
import 'package:expense_tracker_ar/core/theme/theme_cubit.dart';
import 'package:expense_tracker_ar/features/settings/presentation/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper_keks.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize easy_localization
  await EasyLocalization.ensureInitialized();

  // Initialize SQLite for desktop platforms (Windows, Linux, macOS)
  // This is REQUIRED for SQLite to work on Windows!
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await CacheHelper().init();

  // Load saved language
  final cacheHelper = CacheHelper();
  final savedLanguage = cacheHelper.getData(key: CacheHelperKeys.language);
  final startLocale = savedLanguage != null
      ? Locale(savedLanguage)
      : const Locale('ar');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: startLocale,
      child: DevicePreview(enabled: false, builder: (context) => const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                routerConfig: AppRouter.router,
                title: 'Expense Tracker',
                debugShowCheckedModeBanner: false,
                theme: LightTheme.theme,
                darkTheme: DarkTheme.theme,
                themeMode: themeMode,
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
