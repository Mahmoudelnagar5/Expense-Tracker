import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helper/constants/app_constants.dart';
import '../../../../core/helper/functions/pin_password.dart';
import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/services/local_notification_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../onboarding/presentation/widgets/currency_dialog.dart';
import '../../../onboarding/presentation/widgets/language_dialog.dart';
import '../controller/settings_cubit.dart';
import '../controller/settings_state.dart';
import '../widgets/backup_restore_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageDialog(
    BuildContext context,
    SettingsCubit cubit,
    String? currentLanguage,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => LanguageDialog(
        languages: AppConstants.languages,
        initialValue: currentLanguage,
        onSave: (code) async {
          // Change locale in EasyLocalization
          await LocalizationHelper.switchLanguage(context, code);
          // Save to cache
          await cubit.changeLanguage(code);
        },
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    SettingsCubit cubit,
    String? currentTheme,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => ThemeDialog(
        initialValue: currentTheme,
        onSave: (code) async {
          await cubit.toggleTheme(code);
        },
      ),
    );
  }

  void _showCurrencyDialog(
    BuildContext context,
    SettingsCubit cubit,
    String? currentCurrency,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => CurrencyDialog(
        currencies: AppConstants.currencies,
        initialValue: currentCurrency,
        onSave: (code) async {
          await cubit.changeCurrency(code);
          if (context.mounted) {
            ToastHelper.showSuccess(
              context,
              message: LocaleKeys.currencyChanged.tr(),
            );
          }
        },
      ),
    );
  }

  Future<void> _pickReminderTime(
    BuildContext context,
    SettingsCubit cubit,
    TimeOfDay currentTime,
    bool reminderEnabled,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: context.isDarkMode
                ? ColorScheme.dark(
                    primary: AppColors.primaryBrand,
                    onPrimary: Colors.white,
                    surface: context.backgroundColor,
                    onSurface: Colors.white,
                    secondary: AppColors.primaryBrand,
                  )
                : ColorScheme.light(
                    primary: AppColors.primaryBrand,
                    onPrimary: Colors.white,
                    surface: context.backgroundColor,
                    onSurface: Colors.black,
                    secondary: AppColors.primaryBrand,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != currentTime) {
      await cubit.setReminderTime(picked);
      // Reschedule notification with new time if reminder is enabled
      if (reminderEnabled) {
        await _scheduleNotification(picked, context);
      }
    }
  }

  Future<void> _scheduleNotification(
    TimeOfDay time,
    BuildContext context,
  ) async {
    await LocalNotificationService.scheduleDailyNotification(
      hour: time.hour,
      minute: time.minute,
      title: LocaleKeys.reminderNotification.tr(),
      body: LocaleKeys.dontForgetTrackExpenses.tr(),
    );
  }

  Future<void> _handleReminderToggle(
    BuildContext context,
    SettingsCubit cubit,
    bool value,
    TimeOfDay reminderTime,
  ) async {
    await cubit.toggleReminder(value);

    if (value) {
      // Schedule notification
      await _scheduleNotification(reminderTime, context);
      if (context.mounted) {
        ToastHelper.showSuccess(
          context,
          message: LocaleKeys.enableReminder.tr(),
        );
      }
    } else {
      // Cancel notification
      await LocalNotificationService.cancelDailyNotification();
      if (context.mounted) {
        ToastHelper.showInfo(
          context,
          message: LocaleKeys.reminderDisabled.tr(),
        );
      }
    }
  }

  String _formatTime(TimeOfDay time, BuildContext context) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am
        ? LocalizationHelper.isArabic(context)
              ? 'ص'
              : 'AM'
        : LocalizationHelper.isArabic(context)
        ? 'م'
        : 'PM';
    return '$hour:$minute $period';
  }

  String _getLanguageName(String? language) {
    if (language == null) return LocaleKeys.chooseLanguage.tr();
    final lang = AppConstants.languages.firstWhere(
      (l) => l['code'] == language,
      orElse: () => {'name': LocaleKeys.chooseLanguage.tr()},
    );
    return lang['name'] ?? LocaleKeys.chooseLanguage.tr();
  }

  String _getThemeName(String? theme) {
    switch (theme) {
      case 'light':
        return LocaleKeys.lightMode.tr();
      case 'dark':
        return LocaleKeys.darkMode.tr();
      case 'system':
        return LocaleKeys.auto.tr();
      default:
        return LocaleKeys.lightMode.tr();
    }
  }

  String _getCurrencySymbol(String? currency) {
    if (currency == null) return LocaleKeys.chooseCurrency.tr();
    final curr = AppConstants.currencies.firstWhere(
      (c) => c['code'] == currency,
      orElse: () => {'symbol': ''},
    );
    return curr['symbol'] ?? currency;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        if (state.isLoading) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

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
              LocaleKeys.settings.tr(),
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
                const ProfileHeader(),

                SizedBox(height: 20.h),

                // General Section
                SettingsSectionHeader(title: LocaleKeys.general.tr()),
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
                          title: LocaleKeys.appLanguage.tr(),
                          subtitle: _getLanguageName(state.language),
                          onTap: () => _showLanguageDialog(
                            context,
                            cubit,
                            state.language,
                          ),
                        ),
                        _buildDivider(context),

                        // Theme
                        SettingsTile(
                          icon: Icons.brightness_6,
                          iconColor: AppColors.primaryBrand,
                          title: LocaleKeys.themeSettings.tr(),
                          subtitle: _getThemeName(state.theme),
                          onTap: () =>
                              _showThemeDialog(context, cubit, state.theme),
                        ),
                        _buildDivider(context),

                        // Currency
                        SettingsTile(
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: AppColors.primaryBrand,
                          title: LocaleKeys.currencySettings.tr(),
                          subtitle:
                              '${LocaleKeys.currencySymbol.tr()} : ${_getCurrencySymbol(state.currency)}',
                          onTap: () => _showCurrencyDialog(
                            context,
                            cubit,
                            state.currency,
                          ),
                        ),
                        _buildDivider(context),

                        // App Lock
                        SettingsTile(
                          icon: Icons.lock_outline,
                          iconColor: AppColors.primaryBrand,
                          title: LocaleKeys.appLock.tr(),
                          subtitle: state.appLockEnabled
                              ? LocaleKeys.enableAppLock.tr()
                              : LocaleKeys.disableAppLock.tr(),
                          trailing: Switch(
                            inactiveThumbColor: Colors.grey[700],
                            inactiveTrackColor: Colors.grey[300],
                            value: state.appLockEnabled,
                            onChanged: (value) async {
                              if (value) {
                                final pin = await promptForPinCreation(
                                  context,
                                  title: LocaleKeys.setPin.tr(),
                                  confirmTitle: LocaleKeys.confirmPin.tr(),
                                );
                                if (pin != null) {
                                  await cubit.setAppLock(
                                    enabled: true,
                                    pin: pin,
                                  );
                                  if (context.mounted) {
                                    ToastHelper.showSuccess(
                                      context,
                                      message: LocaleKeys.appLockEnabled.tr(),
                                    );
                                  }
                                }
                              } else {
                                // Require current PIN to disable if set
                                final currentPin = state.appLockPin;
                                if (currentPin != null) {
                                  final verified =
                                      await promptForPinVerification(
                                        context,
                                        title: LocaleKeys.enterCurrentPin.tr(),
                                        correctPin: currentPin,
                                      );
                                  if (!verified) return;
                                }
                                await cubit.setAppLock(enabled: false);
                                if (context.mounted) {
                                  ToastHelper.showInfo(
                                    context,
                                    message: LocaleKeys.appLockDisabled.tr(),
                                  );
                                }
                              }
                            },
                            activeThumbColor: AppColors.primaryBrand,
                          ),
                          onTap: () async {
                            // Change PIN flow
                            if (!state.appLockEnabled) {
                              final pin = await promptForPinCreation(
                                context,
                                title: LocaleKeys.setPin.tr(),
                                confirmTitle: LocaleKeys.confirmPin.tr(),
                              );
                              if (pin != null) {
                                await cubit.setAppLock(enabled: true, pin: pin);
                                if (context.mounted) {
                                  ToastHelper.showSuccess(
                                    context,
                                    message: LocaleKeys.appLockEnabled.tr(),
                                  );
                                }
                              }
                              return;
                            }

                            // If enabled, verify current PIN then change
                            final currentPin = state.appLockPin;
                            if (currentPin != null) {
                              final verified = await promptForPinVerification(
                                context,
                                title: LocaleKeys.enterCurrentPin.tr(),
                                correctPin: currentPin,
                              );
                              if (!verified) return;
                            }

                            final newPin = await promptForPinCreation(
                              context,
                              title: LocaleKeys.setPin.tr(),
                              confirmTitle: LocaleKeys.confirmPin.tr(),
                            );
                            if (newPin != null) {
                              await cubit.updateAppLockPin(newPin);
                              if (context.mounted) {
                                ToastHelper.showSuccess(
                                  context,
                                  message: LocaleKeys.pinUpdated.tr(),
                                );
                              }
                            }
                          },
                        ),
                        // _buildDivider(context),

                        // // Categories
                        // SettingsTile(
                        //   icon: Icons.category_outlined,
                        //   iconColor: AppColors.secondaryBrown,
                        //   title: LocaleKeys.categorySettings.tr(),
                        //   subtitle: LocaleKeys.editCategories.tr(),
                        //   onTap: () {
                        //     ToastHelper.showInfo(
                        //       context,
                        //       message: LocaleKeys.comingSoon.tr(),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Reminder Section
                SettingsSectionHeader(title: LocaleKeys.reminder.tr()),
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
                          title: LocaleKeys.enableReminder.tr(),
                          subtitle: LocaleKeys.reminderNotification.tr(),
                          trailing: Switch(
                            inactiveThumbColor: Colors.grey[700],
                            inactiveTrackColor: Colors.grey[300],
                            value: state.reminderEnabled,
                            onChanged: (value) => _handleReminderToggle(
                              context,
                              cubit,
                              value,
                              state.reminderTime,
                            ),
                            activeThumbColor: AppColors.primaryBrand,
                          ),
                          onTap: () => _handleReminderToggle(
                            context,
                            cubit,
                            !state.reminderEnabled,
                            state.reminderTime,
                          ),
                        ),
                        _buildDivider(context),

                        // Reminder Time
                        SettingsTile(
                          icon: Icons.access_time,
                          iconColor: AppColors.primaryBrand,
                          title: LocaleKeys.reminderTime.tr(),
                          subtitle: _formatTime(state.reminderTime, context),
                          onTap: () => _pickReminderTime(
                            context,
                            cubit,
                            state.reminderTime,
                            state.reminderEnabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Backup & Restore Section
                SettingsSectionHeader(title: LocaleKeys.backupRestore.tr()),
                SizedBox(height: 8.h),

                const BackupRestoreSection(),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivider(BuildContext context) {
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
