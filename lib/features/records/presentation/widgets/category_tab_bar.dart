import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';

/// Custom tab bar widget for income/expense selection
class CategoryTabBar extends StatelessWidget {
  final TabController controller;

  const CategoryTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: const Color(0xFF00BCD4),
          borderRadius: BorderRadius.circular(25.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: AppTextStyles.font16BlackBold,
        unselectedLabelStyle: AppTextStyles.font16BlackRegular,
        dividerColor: Colors.transparent,
        tabs: [
          Expanded(
            child: _buildTab(
              icon: Icons.account_balance_wallet_outlined,
              label: 'دخل',
            ),
          ),
          Expanded(
            child: _buildTab(
              icon: Icons.receipt_long_outlined,
              label: 'النفقات',
            ),
          ),
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
