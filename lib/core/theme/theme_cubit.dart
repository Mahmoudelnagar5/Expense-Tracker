import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helper/database/cache_helper.dart';
import '../helper/database/cache_helper_keks.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final CacheHelper _cacheHelper;

  ThemeCubit({CacheHelper? cacheHelper})
    : _cacheHelper = cacheHelper ?? CacheHelper(),
      super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = _cacheHelper.getData(key: CacheHelperKeys.theme);

    if (savedTheme == null) {
      emit(ThemeMode.light);
      return;
    }

    switch (savedTheme) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      case 'system':
        emit(ThemeMode.system);
        break;
      default:
        emit(ThemeMode.light);
    }
  }

  Future<void> setTheme(String themeMode) async {
    await _cacheHelper.saveData(key: CacheHelperKeys.theme, value: themeMode);

    switch (themeMode) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      case 'system':
        emit(ThemeMode.system);
        break;
      default:
        emit(ThemeMode.light);
    }
  }

  String get currentThemeString {
    switch (state) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
