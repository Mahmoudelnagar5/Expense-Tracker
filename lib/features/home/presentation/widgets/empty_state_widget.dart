import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    this.message = 'لا يوجد بيانات',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100.h),
          // Empty box illustration
          Container(
            width: 150.w,
            height: 150.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Box icon
                Icon(
                  Icons.inventory_2_outlined,
                  size: 80.sp,
                  color: Colors.grey[400],
                ),
                // Sparkle effect
                Positioned(
                  top: 20.h,
                  right: 30.w,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 24.sp,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            message,
            style: AppTextStyles.font18BlackBold.copyWith(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
