import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import 'settings_tile.dart';

class BackupRestoreSection extends StatelessWidget {
  const BackupRestoreSection({super.key});

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
              onTap: () {
                ToastHelper.showInfo(
                  context,
                  message: LocaleKeys.comingSoon.tr(),
                );
              },
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
              onTap: () {
                ToastHelper.showInfo(
                  context,
                  message: LocaleKeys.comingSoon.tr(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
