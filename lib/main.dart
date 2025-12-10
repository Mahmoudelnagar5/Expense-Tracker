import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import 'package:expense_tracker_ar/core/helper/database/cache_helper.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper_keks.dart';

import 'core/services/local_notification_service.dart';
import 'my_app.dart';

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
    await LocalNotificationService.init();
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
