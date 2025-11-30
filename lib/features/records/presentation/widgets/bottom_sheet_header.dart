import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';

/// Header widget for the bottom sheet with title and close button
class BottomSheetHeader extends StatelessWidget {
  final VoidCallback? onClose;

  const BottomSheetHeader({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('اختر الفئة', style: AppTextStyles.font16BlackBold),
          IconButton(
            onPressed: onClose ?? () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.grey[600], size: 20.sp),
          ),
        ],
      ),
    );
  }
}
