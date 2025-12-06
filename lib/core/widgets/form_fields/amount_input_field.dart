import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

/// Amount input field widget
class AmountInputField extends StatelessWidget {
  final TextEditingController controller;

  const AmountInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? const Color(0xFF253342)
            : AppColors.gradientG10_1,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Expanded(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.right,

          cursorColor: AppColors.primaryBrand,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.attach_money,
              color: AppColors.primaryBrand,
              size: 20.sp,
            ),
            border: InputBorder.none,

            hintText: 'إضافة المبلغ',
            hintStyle: AppTextStyles.font14LightGrayRegular,
          ),
          style: AppTextStyles.font15BlackMedium.copyWith(
            fontSize: 16.sp,
            color: context.textColor,
          ),
        ),
      ),
    );
  }
}
