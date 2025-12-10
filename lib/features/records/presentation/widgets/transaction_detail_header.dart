import 'package:expense_tracker_ar/core/models/transaction_model.dart';
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:expense_tracker_ar/core/utils/app_colors.dart';
import 'package:expense_tracker_ar/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/font_weight_helper.dart';

class TransactionDetailHeader extends StatelessWidget {
  final TransactionModel transaction;
  final bool isIncome;
  final Color amountColor;
  final String currencyCode;
  final String currencySymbol;

  const TransactionDetailHeader({
    super.key,
    required this.transaction,
    required this.isIncome,
    required this.amountColor,
    required this.currencyCode,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xFF1E2A38) : Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xFF253342)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              transaction.categoryModel.icon,
              color: AppColors.primaryBrand,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            transaction.categoryModel.name,
            style: AppTextStyles.font16BlackBold.copyWith(
              fontSize: 20.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} $currencySymbol',
            style: AppTextStyles.font16BlackBold.copyWith(
              fontSize: 32.sp,
              color: amountColor,
              fontWeight: FontWeightHelper.bold,
            ),
          ),
        ],
      ),
    );
  }
}
