import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_text_styles.dart';

/// Notes input field widget
class NotesInputField extends StatelessWidget {
  final TextEditingController controller;

  const NotesInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notes, color: Color(0xFF00BCD4), size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 2,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'أضف ملاحظة',
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
