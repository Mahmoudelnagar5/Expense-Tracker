import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/utils/locale_keys.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

/// Notes input field widget
class NotesInputField extends StatelessWidget {
  final TextEditingController controller;

  const NotesInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.themeColor(
          light: AppColors.neutralSoftGrey2,
          dark: const Color(0xFF253342),
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: 1,
        cursorColor: AppColors.primaryBrand,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.notes,
            color: AppColors.primaryBrand,
            size: 20.sp,
          ),
          border: InputBorder.none,
          hintText: LocaleKeys.addNote.tr(),
          hintStyle: AppTextStyles.font14LightGrayRegular,
        ),
        style: AppTextStyles.font15BlackMedium.copyWith(
          fontSize: 14.5.sp,
          color: context.textColor,
        ),
      ),
    );
  }
}
