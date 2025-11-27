import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';

class SummaryCardWidget extends StatelessWidget {
  final String incomeAmount;
  final String expenseAmount;
  final String totalAmount;
  final String currency;

  const SummaryCardWidget({
    super.key,
    required this.incomeAmount,
    required this.expenseAmount,
    required this.totalAmount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryItem(
            label: 'دخل',
            amount: '$incomeAmount $currency',
            color: Colors.green,
          ),
          _buildDivider(),
          _buildSummaryItem(
            label: 'النفقات',
            amount: '$expenseAmount $currency',
            color: Colors.red,
          ),
          _buildDivider(),
          _buildSummaryItem(
            label: 'المجموع',
            amount: '$totalAmount $currency',
            color: const Color(0xFF00BCD4),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String amount,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.font16BlackBold.copyWith(fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            amount,
            style: AppTextStyles.font16BlackBold.copyWith(
              fontSize: 14.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40.h,
      width: 1.w,
      color: Colors.grey[300],
      margin: EdgeInsets.symmetric(horizontal: 8.w),
    );
  }
}
