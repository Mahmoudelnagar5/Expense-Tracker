import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/helper/constants/app_constants.dart';
import 'package:expense_tracker_ar/core/models/transaction_model.dart';
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:expense_tracker_ar/core/utils/app_text_styles.dart';
import 'package:expense_tracker_ar/core/utils/locale_keys.dart';
import 'package:expense_tracker_ar/features/records/presentation/widgets/transaction_detail_header.dart';
import 'package:expense_tracker_ar/features/records/presentation/widgets/transaction_detail_row.dart';
import 'package:expense_tracker_ar/features/records/presentation/widgets/transaction_image_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final TransactionModel transaction;
  final String? currency;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
    this.currency,
  });

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.transaction.categoryModel.type.toString().contains(
      'income',
    );
    final amountColor = isIncome ? Colors.green : Colors.red;
    final currencyCode = widget.currency ?? 'USD';
    final currencySymbol = AppConstants.currencies.firstWhere(
      (c) => c['code'] == currencyCode,
      orElse: () => {'symbol': ''},
    );

    final hasImages =
        widget.transaction.attachmentImages != null &&
        widget.transaction.attachmentImages!.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          LocaleKeys.transactionDetails.tr(),
          style: AppTextStyles.font16BlackBold.copyWith(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionDetailHeader(
              transaction: widget.transaction,
              isIncome: isIncome,
              amountColor: amountColor,
              currencyCode: currencyCode,
              currencySymbol: (currencySymbol['symbol'] ?? currencyCode),
            ),

            // Details Section
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  TransactionDetailRow(
                    label: LocaleKeys.date.tr(),
                    value: DateFormat(
                      'dd MMM yyyy, hh:mm a',
                      context.locale.languageCode,
                    ).format(widget.transaction.dateTime),
                    icon: Icons.calendar_today_outlined,
                  ),
                  SizedBox(height: 16.h),

                  // Payment Type
                  TransactionDetailRow(
                    label: LocaleKeys.paymentTypeLabel.tr(),
                    value: widget.transaction.paymentType,
                    icon: Icons.payment_outlined,
                  ),
                  SizedBox(height: 16.h),

                  // Type (Income/Expense)
                  TransactionDetailRow(
                    label: LocaleKeys.type.tr(),
                    value: isIncome
                        ? LocaleKeys.income.tr()
                        : LocaleKeys.expense.tr(),
                    icon: isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                  ),

                  // Notes (if available)
                  if (widget.transaction.notes != null &&
                      widget.transaction.notes!.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    Text(
                      LocaleKeys.notes.tr(),
                      style: AppTextStyles.font16BlackBold.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? const Color(0xFF1E2A38)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        widget.transaction.notes!,
                        style: AppTextStyles.font14GrayRegular.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],

                  // Images Gallery (if available)
                  if (hasImages) ...[
                    SizedBox(height: 24.h),
                    Text(
                      LocaleKeys.attachmentLabel.tr(),
                      style: AppTextStyles.font16BlackBold.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TransactionImageGallery(
                      images: widget.transaction.attachmentImages!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
