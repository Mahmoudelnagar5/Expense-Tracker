import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';

class DateSelectorWidget extends StatelessWidget {
  final String dateText;
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;
  final VoidCallback onFilterPressed;

  const DateSelectorWidget({
    super.key,
    required this.dateText,
    required this.onPreviousDate,
    required this.onNextDate,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date Navigation
          Row(
            children: [
              IconButton(
                onPressed: onPreviousDate,
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width * .17),
              Text(
                dateText,
                style: AppTextStyles.font18BlackBold.copyWith(fontSize: 16.sp),
              ),
              SizedBox(width: MediaQuery.sizeOf(context).width * .12),
              IconButton(
                onPressed: onNextDate,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.sp,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          // Filter and Sort Icon
          IconButton(
            onPressed: onFilterPressed,
            icon: Icon(Icons.filter_list, size: 24.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
