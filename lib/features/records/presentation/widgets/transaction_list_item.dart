import 'package:expense_tracker_ar/core/helper/database/cache_helper.dart';
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import '../../../../core/helper/constants/app_constants.dart';
import '../../../../core/helper/database/cache_helper_keks.dart';
import '../../../../core/models/transaction_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.categoryModel.type.toString().contains(
      'income',
    );
    final amountColor = isIncome ? Colors.green : Colors.red;
    final currency = CacheHelper().getData(key: CacheHelperKeys.currency);
    final currencySymbol = AppConstants.currencies.firstWhere(
      (c) => c['code'] == currency,
      orElse: () => {'symbol': ''},
    );

    return SwipeActionCell(
      key: ObjectKey(transaction.id),
      trailingActions: [
        SwipeAction(
          title: "حذف",
          style: AppTextStyles.font16WhiteSemiBold.copyWith(fontSize: 14.sp),
          onTap: (CompletionHandler handler) async {
            await handler(false);
            onDelete?.call();
          },
          color: Colors.red,
          icon: Icon(Icons.delete, color: Colors.white, size: 24.sp),
        ),
        SwipeAction(
          title: "تعديل",
          style: AppTextStyles.font16WhiteSemiBold.copyWith(fontSize: 14.sp),

          onTap: (CompletionHandler handler) async {
            await handler(false);
            onEdit?.call();
          },
          color: AppColors.primaryBrand,
          icon: Icon(Icons.edit, color: Colors.white, size: 24.sp),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Category Icon
            Stack(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF253342)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    transaction.categoryModel.icon,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24.sp,
                  ),
                ),

                if (transaction.attachmentImages != null &&
                    transaction.attachmentImages!.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColors.systemBlue.withOpacity(1),
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.white,
                        size: 10.sp,
                        weight: 10,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.categoryModel.name,
                    style: AppTextStyles.font16BlackBold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (transaction.notes != null &&
                      transaction.notes!.isNotEmpty)
                    Text(
                      transaction.notes!,
                      style: AppTextStyles.font14GrayRegular.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFB8C5D6)
                            : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} ${(currencySymbol['symbol'] ?? currency)}',
                  style: AppTextStyles.font16BlackBold.copyWith(
                    color: amountColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.paymentType,
                  style: AppTextStyles.font14GrayRegular.copyWith(
                    color: context.themeColor(
                      light: Colors.grey[700]!,
                      dark: const Color(0xFFB8C5D6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
