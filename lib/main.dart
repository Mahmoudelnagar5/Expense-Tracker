import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:expense_tracker_ar/core/routing/app_router.dart';
import 'package:expense_tracker_ar/core/theme/dark_theme.dart';
import 'package:expense_tracker_ar/core/theme/light_theme.dart';
import 'package:expense_tracker_ar/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for desktop platforms (Windows, Linux, macOS)
  // This is REQUIRED for SQLite to work on Windows!
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await CacheHelper().init();
  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
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
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('ar', 'AE')],
                locale: const Locale('ar', 'AE'),
              );
            },
          );
        },
      ),
    );
  }
}
