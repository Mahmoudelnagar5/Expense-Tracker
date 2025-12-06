import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/app_colors.dart';
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
              title: 'النسخ الاحتياطي',
              subtitle: 'حفظ بياناتك على السحابة.',
              onTap: () {
                ToastHelper.showInfo(context, message: 'قريباً');
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
              title: 'استعادة البيانات',
              subtitle: 'استرجاع بياناتك من السحابة.',
              onTap: () {
                ToastHelper.showInfo(context, message: 'قريباً');
              },
            ),
          ],
        ),
      ),
    );
  }
}
