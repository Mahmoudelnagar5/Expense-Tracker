import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Attachment button widget
class AttachmentButton extends StatelessWidget {
  final VoidCallback onTap;

  const AttachmentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey[700],
          size: 32.sp,
        ),
      ),
    );
  }
}
