import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/services/backup_restore_service.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import 'settings_tile.dart';

class BackupRestoreSection extends StatefulWidget {
  const BackupRestoreSection({super.key});

  @override
  State<BackupRestoreSection> createState() => _BackupRestoreSectionState();
}

class _BackupRestoreSectionState extends State<BackupRestoreSection> {
  final BackupRestoreService _backupRestoreService = BackupRestoreService();
  bool isLoadingBackup = false;
  bool isLoadingRestore = false;

  Future<void> _handleBackup() async {
    setState(() => isLoadingBackup = true);
    try {
      final success = await _backupRestoreService.createBackup();
      if (success && mounted) {
        ToastHelper.showSuccess(
          context,
          message: LocaleKeys.backupCreatedSuccessfully.tr(),
        );
      } else if (mounted) {
        ToastHelper.showError(context, message: LocaleKeys.backupFailed.tr());
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, message: LocaleKeys.backupError.tr());
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingBackup = false);
      }
    }
  }

  Future<void> _handleRestore() async {
    setState(() => isLoadingRestore = true);
    try {
      final success = await _backupRestoreService.restoreFromBackup();
      if (success && mounted) {
        ToastHelper.showSuccess(
          context,
          message: LocaleKeys.restoreSuccessful.tr(),
        );
      } else if (mounted) {
        ToastHelper.showError(context, message: LocaleKeys.restoreFailed.tr());
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, message: LocaleKeys.restoreError.tr());
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingRestore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            // Backup
            SettingsTile(
              icon: Icons.cloud_upload_outlined,
              iconColor: AppColors.systemGreen,
              title: LocaleKeys.backup.tr(),
              subtitle: LocaleKeys.backupDescription.tr(),
              onTap: isLoadingBackup ? null : _handleBackup,
              trailing: isLoadingBackup
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Divider(
                height: 1,
                color: context.themeColor(
                  light: Colors.grey[300]!,
                  dark: context.primaryColor.withOpacity(0.2),
                ),
              ),
            ),

            // Restore
            SettingsTile(
              icon: Icons.cloud_download_outlined,
              iconColor: AppColors.systemBlue,
              title: LocaleKeys.restore.tr(),
              subtitle: LocaleKeys.restoreDescription.tr(),
              onTap: isLoadingRestore ? null : _handleRestore,
              trailing: isLoadingRestore
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
