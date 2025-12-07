import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor = AppColors.primaryBrand,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,

          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 22.sp),
            ),

            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.font16BlackBold.copyWith(
                      fontSize: 15.sp,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        subtitle!,
                        style: AppTextStyles.font14GrayRegular.copyWith(
                          fontSize: 12.sp,
                          color: isDark
                              ? const Color(0xFFB8C5D6)
                              : Colors.grey[600],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Text content
            SizedBox(width: 12.w),
            // Trailing arrow or custom widget (on the left for RTL)
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? const Color(0xFF6B7A8F) : Colors.grey[500],
                  size: 16.sp,
                ),
          ],
        ),
      ),
    );
  }
}
