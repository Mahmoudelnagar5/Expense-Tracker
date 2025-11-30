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
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                icon: Icons.receipt_long_outlined,
                label: 'السجلات',
                index: 0,
                isSelected: currentIndex == 0,
                onTap: () => onItemTapped(0),
              ),
              SizedBox(width: 80.w), // Space for FAB
              _buildNavItem(
                icon: Icons.description_outlined,
                label: 'تقارير',
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
                    color: const Color(0xFF00BCD4).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: onAddPressed,
                backgroundColor: const Color(0xFF00BCD4),
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
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? const Color(0xFF00BCD4) : Colors.grey[400];

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
                fontSize: 12.sp,
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
