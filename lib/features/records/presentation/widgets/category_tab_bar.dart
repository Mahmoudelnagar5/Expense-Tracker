import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';

/// Custom tab bar widget for income/expense selection
class CategoryTabBar extends StatelessWidget {
  final TabController controller;

  const CategoryTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF253342) : Colors.grey[100],
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(25.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: isDark
            ? const Color(0xFFB8C5D6)
            : Colors.grey[600],
        labelStyle: AppTextStyles.font16BlackBold,
        unselectedLabelStyle: AppTextStyles.font16BlackBold,
        dividerColor: Colors.transparent,
        tabs: [
          _buildTab(icon: Icons.account_balance_wallet_outlined, label: 'دخل'),
          _buildTab(icon: Icons.receipt_long_outlined, label: 'النفقات'),
        ],
      ),
    );
  }

  Widget _buildTab({required IconData icon, required String label}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20.sp),
          SizedBox(width: 10.w),
          Text(label),
        ],
      ),
    );
  }
}
