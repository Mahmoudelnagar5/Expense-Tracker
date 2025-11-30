import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../utils/app_text_styles.dart';

/// Date selector field widget
class DateSelectorField extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const DateSelectorField({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.calendar_today, color: Color(0xFF00BCD4), size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              DateFormat('dd نوفمبر yyyy', 'ar').format(selectedDate),
              style: AppTextStyles.font15BlackMedium,
            ),
          ],
        ),
      ),
    );
  }
}
