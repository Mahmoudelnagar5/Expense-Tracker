import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_text_styles.dart';

/// Amount input field widget
class AmountInputField extends StatelessWidget {
  final TextEditingController controller;

  const AmountInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.attach_money, color: Color(0xFF00BCD4), size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'إضافة المبلغ',
                hintStyle: AppTextStyles.font14LightGrayRegular,
              ),
              style: AppTextStyles.font15BlackMedium,
            ),
          ),
        ],
      ),
    );
  }
}
