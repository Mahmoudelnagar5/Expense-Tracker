import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/utils/app_colors.dart';
import 'package:expense_tracker_ar/core/utils/font_weight_helper.dart';
import 'package:expense_tracker_ar/core/utils/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onAddPressed;
  final Function(int) onItemTapped;

  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onAddPressed,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom Navigation Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.receipt_long_outlined,
                label: LocaleKeys.records.tr(),
                index: 0,
                isSelected: currentIndex == 0,
                onTap: () => onItemTapped(0),
              ),
              SizedBox(width: 80.w), // Space for FAB
              _buildNavItem(
                context: context,
                icon: Icons.description_outlined,
                label: LocaleKeys.reports.tr(),
                index: 0,
                isSelected: currentIndex == 1,
                onTap: () => onItemTapped(1),
              ),
            ],
          ),

          // Floating Action Button
          Positioned(
            top: -25.h,
            left: MediaQuery.of(context).size.width / 2 - 30.w,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientG3_1,
                    offset: const Offset(0, 1),
                    blurRadius: 12,
                    spreadRadius: 1.2,
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: onAddPressed,
                backgroundColor: AppColors.primaryBrand,
                elevation: 0,
                child: Icon(Icons.add, size: 32.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : (isDark ? const Color(0xFF6B7A8F) : Colors.grey[700]);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28.sp, color: color),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.font14LightGrayRegular.copyWith(
                color: color,
                fontWeight: isSelected
                    ? FontWeightHelper.bold
                    : FontWeightHelper.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
