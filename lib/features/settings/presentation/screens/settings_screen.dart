import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helper/constants/app_constants.dart';
import '../../../../core/helper/database/cache_helper.dart';
import '../../../../core/helper/database/cache_helper_keks.dart';
import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../onboarding/presentation/widgets/currency_dialog.dart';
import '../../../onboarding/presentation/widgets/language_dialog.dart';
import '../widgets/backup_restore_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final CacheHelper _cacheHelper = CacheHelper();

  // User data
  File? _imageFile;
  String? _username;
  String? _currency;
  String? _language;
  String? _theme;
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // Load profile image
    final imageProfilePath = _cacheHelper.getData(
      key: CacheHelperKeys.imageProfile,
    );
    if (imageProfilePath != null && imageProfilePath is String) {
      _imageFile = File(imageProfilePath);
    }

    // Load other settings
    _username = _cacheHelper.getData(key: CacheHelperKeys.username);
    _currency = _cacheHelper.getData(key: CacheHelperKeys.currency);
    _language = _cacheHelper.getData(key: CacheHelperKeys.language);
    _theme = _cacheHelper.getData(key: CacheHelperKeys.theme) ?? 'light';
    _reminderEnabled =
        _cacheHelper.getData(key: CacheHelperKeys.reminderEnabled) ?? false;

    final savedHour = _cacheHelper.getData(key: CacheHelperKeys.reminderHour);
    final savedMinute = _cacheHelper.getData(
      key: CacheHelperKeys.reminderMinute,
    );
    if (savedHour != null && savedMinute != null) {
      _reminderTime = TimeOfDay(hour: savedHour, minute: savedMinute);
    }

    setState(() {});
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => LanguageDialog(
        languages: AppConstants.languages,
        initialValue: _language,
        onSave: (code) async {
          await _cacheHelper.saveData(
            key: CacheHelperKeys.language,
            value: code,
          );
          setState(() {
            _language = code;
          });
          if (mounted) {
            ToastHelper.showSuccess(context, message: 'تم تغيير اللغة');
          }
        },
      ),
    );
  }

  void _showThemeDialog() {
    final themeCubit = context.read<ThemeCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => ThemeDialog(
        initialValue: _theme,
        onSave: (code) async {
          await themeCubit.setTheme(code);
          setState(() {
            _theme = code;
          });
        },
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => CurrencyDialog(
        currencies: AppConstants.currencies,
        initialValue: _currency,
        onSave: (code) async {
          await _cacheHelper.saveData(
            key: CacheHelperKeys.currency,
            value: code,
          );
          setState(() {
            _currency = code;
          });
          if (mounted) {
            ToastHelper.showSuccess(context, message: 'تم تغيير العملة');
          }
        },
      ),
    );
  }

  Future<void> _toggleReminder(bool value) async {
    await _cacheHelper.saveData(
      key: CacheHelperKeys.reminderEnabled,
      value: value,
    );
    setState(() {
      _reminderEnabled = value;
    });
  }

  Future<void> _pickReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBrand,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _reminderTime) {
      await _cacheHelper.saveData(
        key: CacheHelperKeys.reminderHour,
        value: picked.hour,
      );
      await _cacheHelper.saveData(
        key: CacheHelperKeys.reminderMinute,
        value: picked.minute,
      );
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  String _getLanguageName() {
    if (_language == null) return 'اختر اللغة';
    final lang = AppConstants.languages.firstWhere(
      (l) => l['code'] == _language,
      orElse: () => {'name': 'اختر اللغة'},
    );
    return lang['name'] ?? 'اختر اللغة';
  }

  String _getThemeName() {
    switch (_theme) {
      case 'light':
        return 'وضع الإضاءة';
      case 'dark':
        return 'الوضع الليلي';
      case 'system':
        return 'تلقائي';
      default:
        return 'وضع الإضاءة';
    }
  }

  String _getCurrencySymbol() {
    if (_currency == null) return 'اختر العملة';
    final curr = AppConstants.currencies.firstWhere(
      (c) => c['code'] == _currency,
      orElse: () => {'symbol': ''},
    );
    return curr['symbol'] ?? _currency!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'إعدادات',
          style: AppTextStyles.font18BlackBold.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            ProfileHeader(),

            SizedBox(height: 20.h),

            // General Section
            const SettingsSectionHeader(title: 'عام'),
            SizedBox(height: 8.h),

            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    // Language
                    SettingsTile(
                      icon: Icons.translate,
                      iconColor: AppColors.primaryBrand,
                      title: 'لغات التطبيق',
                      subtitle: _getLanguageName(),
                      onTap: _showLanguageDialog,
                    ),
                    _buildDivider(),

                    // Theme
                    SettingsTile(
                      icon: Icons.brightness_6,
                      iconColor: AppColors.primaryBrand,
                      title: 'مواضيع التطبيق',
                      subtitle: _getThemeName(),
                      onTap: _showThemeDialog,
                    ),
                    _buildDivider(),

                    // Currency
                    SettingsTile(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: AppColors.primaryBrand,
                      title: 'إعداد العملة',
                      subtitle: 'رمز العملة : ${_getCurrencySymbol()}',
                      onTap: _showCurrencyDialog,
                    ),
                    _buildDivider(),

                    // Categories
                    SettingsTile(
                      icon: Icons.category_outlined,
                      iconColor: AppColors.secondaryBrown,
                      title: 'إعدادات الفئة',
                      subtitle: 'تعديل فئات الدخل/النفقات الخاصة بك.',
                      onTap: () {
                        ToastHelper.showInfo(context, message: 'قريباً');
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Reminder Section
            const SettingsSectionHeader(title: 'تذكير'),
            SizedBox(height: 8.h),

            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    // Enable Reminder Toggle
                    SettingsTile(
                      icon: Icons.notifications_outlined,
                      iconColor: AppColors.primaryBrand,
                      title: 'تمكين التذكير',
                      subtitle: 'إشعار لإضافة نفقاتك اليومية.',
                      trailing: Switch(
                        inactiveThumbColor: Colors.grey[700],
                        inactiveTrackColor: Colors.grey[300],
                        value: _reminderEnabled,
                        onChanged: _toggleReminder,
                        activeThumbColor: AppColors.primaryBrand,
                      ),
                      onTap: () => _toggleReminder(!_reminderEnabled),
                    ),
                    _buildDivider(),

                    // Reminder Time
                    SettingsTile(
                      icon: Icons.access_time,
                      iconColor: AppColors.primaryBrand,
                      title: 'وقت التذكير',
                      subtitle: _formatTime(_reminderTime),
                      onTap: _pickReminderTime,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Backup & Restore Section
            const SettingsSectionHeader(title: 'النسخ الاحتياطي والاستعادة'),
            SizedBox(height: 8.h),

            BackupRestoreSection(),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        color: context.themeColor(
          light: Colors.grey[300]!,
          dark: context.primaryColor.withOpacity(0.2),
        ),
      ),
    );
  }
}
