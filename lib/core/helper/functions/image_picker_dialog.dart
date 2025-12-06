import 'package:expense_tracker_ar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_text_styles.dart';

void showImagePickerDialog(
  BuildContext context, {
  required Future<Null> Function() onTapGallery,
  required Future<Null> Function() onTapCamera,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'اختر مصدر الصورة',
          style: AppTextStyles.font16BlackBold,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: AppColors.primaryBrand,
                size: 28.sp,
              ),
              title: Text('الكاميرا', style: AppTextStyles.font16BlackBold),
              onTap: onTapCamera,
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: AppColors.primaryBrand,
                size: 28.sp,
              ),
              title: Text('المعرض', style: AppTextStyles.font16BlackBold),
              onTap: onTapGallery,
            ),
          ],
        ),
      );
    },
  );
}
