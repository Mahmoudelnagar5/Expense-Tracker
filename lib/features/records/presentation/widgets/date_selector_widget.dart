import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';

class DateSelectorWidget extends StatelessWidget {
  final String dateText;
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;
  final VoidCallback onFilterPressed;
  final VoidCallback? onDatePressed;

  const DateSelectorWidget({
    super.key,
    required this.dateText,
    required this.onPreviousDate,
    required this.onNextDate,
    required this.onFilterPressed,
    this.onDatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          // Date Navigation
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onPreviousDate,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                    color: isDark ? const Color(0xFFB8C5D6) : Colors.grey[700],
                  ),
                ),
                // SizedBox(width: MediaQuery.sizeOf(context).width * .15),
                TextButton(
                  onPressed: onDatePressed,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      dateText,
                      style: AppTextStyles.font18BlackBold.copyWith(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: MediaQuery.sizeOf(context).width * .13),
                IconButton(
                  onPressed: onNextDate,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: isDark ? const Color(0xFFB8C5D6) : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Filter and Sort Icon
          IconButton(
            onPressed: onFilterPressed,
            icon: Icon(
              Icons.filter_list,
              size: 24.sp,
              color: isDark ? const Color(0xFFB8C5D6) : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
