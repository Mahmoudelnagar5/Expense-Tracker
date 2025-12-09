import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/helper/enums/date_filter_type.dart';
import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/models/transaction_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/font_weight_helper.dart';
import '../../../settings/presentation/controller/controller.dart';
import '../../controller/record_cubit.dart';
import '../../controller/record_state.dart';
import 'date_selector_widget.dart';
import 'empty_state_widget.dart';
import 'summary_card_widget.dart';
import 'transaction_form_widget.dart';
import 'transaction_list_item.dart';

class RecordScreenContent extends StatelessWidget {
  const RecordScreenContent({super.key});

  String _getFormattedDate(
    BuildContext context,
    DateTime selectedDate,
    DateFilterType filterType,
  ) {
    final locale = context.locale.languageCode;
    switch (filterType) {
      case DateFilterType.day:
        return intl.DateFormat('d MMMM، yyyy', locale).format(selectedDate);
      case DateFilterType.month:
        return intl.DateFormat('MMMM، yyyy', locale).format(selectedDate);
      case DateFilterType.year:
        return intl.DateFormat('yyyy', locale).format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecordCubit, RecordState>(
      listener: (context, state) {
        if (state.errorMessage?.isNotEmpty ?? false) {
          ToastHelper.showError(context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RecordCubit>();
        // watch currency changes from SettingsCubit
        final currency = context.watch<SettingsCubit>().state.currency ?? 'USD';
        return Column(
          children: [
            // Date Selector
            RepaintBoundary(
              child: DateSelectorWidget(
                dateText: _getFormattedDate(
                  context,
                  state.selectedDate,
                  state.filterType,
                ),
                onPreviousDate: cubit.goToPreviousDate,
                onNextDate: cubit.goToNextDate,
                onFilterPressed: () =>
                    _handleFilterPressed(context, state, cubit),
                onDatePressed: () => _handleDatePressed(context, state, cubit),
              ),
            ),

            // Divider
            _buildDivider(context),

            // Summary Card
            RepaintBoundary(
              child: SummaryCardWidget(
                incomeAmount: state.totalIncome.toStringAsFixed(0),
                expenseAmount: state.totalExpense.toStringAsFixed(0),
                totalAmount: state.totalBalance.toStringAsFixed(0),
                currency: currency,
              ),
            ),

            // Divider
            _buildDivider(context),

            // Transaction List or Empty State
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.transactions.isEmpty
                  ? const EmptyStateWidget()
                  : RepaintBoundary(
                      child: _buildTransactionList(
                        context,
                        state,
                        cubit,
                        currency,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    RecordState state,
    RecordCubit cubit,
    String currency,
  ) {
    // Group transactions by date
    final groupedTransactions = <String, List<TransactionModel>>{};
    final locale = context.locale.languageCode;

    // Determine the date format based on filter type
    String dateFormat;
    switch (state.filterType) {
      case DateFilterType.year:
        dateFormat = 'MMMM، yyyy';
        break;
      case DateFilterType.month:
      case DateFilterType.day:
        dateFormat = 'd MMMM، yyyy';
        break;
    }

    for (var transaction in state.transactions) {
      final dateKey = DateFormat(
        dateFormat,
        locale,
      ).format(transaction.dateTime);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedTransactions.keys.elementAt(index);
        final transactions = groupedTransactions[dateKey]!;

        return RepaintBoundary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF253342)
                    : Colors.grey[100],
                child: Text(
                  dateKey,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFB8C5D6)
                        : Colors.grey[700],
                  ),
                ),
              ),

              // Transactions for this date
              ...transactions.map(
                (transaction) => TransactionListItem(
                  transaction: transaction,
                  currency: currency,
                  onEdit: () =>
                      _handleEditTransaction(context, transaction, cubit),
                  onDelete: () =>
                      _handleDeleteTransaction(context, transaction, cubit),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 1.h,
      color: Theme.of(context).dividerColor.withOpacity(.5),
    );
  }

  Future<void> _handleDatePressed(
    BuildContext context,
    RecordState state,
    RecordCubit cubit,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: context.locale,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBrand,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != state.selectedDate) {
      cubit.setSelectedDate(picked);
    }
  }

  void _handleFilterPressed(
    BuildContext context,
    RecordState state,
    RecordCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.backgroundColor,
        title: Text(
          LocaleKeys.filterBy.tr(),
          style: AppTextStyles.font18BlackBold.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DateFilterType.values.map((type) {
            return RadioListTile<DateFilterType>(
              title: Text(
                type.arabicName,
                style: AppTextStyles.font15BlackMedium.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              value: type,
              groupValue: state.filterType,
              activeColor: AppColors.primaryBrand,
              onChanged: (value) {
                if (value != null) {
                  cubit.setFilterType(value);
                  Navigator.pop(dialogContext);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: AppTextStyles.font13BlueSemiBold,
            ),
          ),
        ],
      ),
    );
  }

  void _handleEditTransaction(
    BuildContext context,
    TransactionModel transaction,
    RecordCubit cubit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFormWidget(
        category: transaction.categoryModel,
        transaction: transaction,
        recordCubit: cubit,
      ),
    );
  }

  Future<void> _handleDeleteTransaction(
    BuildContext context,
    TransactionModel transaction,
    RecordCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.backgroundColor,
        title: Text(
          LocaleKeys.deleteTransactionTitle.tr(),
          style: AppTextStyles.font16BlackMedium,
        ),
        content: Text(
          LocaleKeys.deleteTransactionMessage.tr(),
          style: AppTextStyles.font14GrayRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: AppTextStyles.font13BlueSemiBold,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              LocaleKeys.delete.tr(),
              style: AppTextStyles.font13BlueSemiBold.copyWith(
                color: Colors.red,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await cubit.deleteTransaction(transaction.id!);
        if (context.mounted) {
          ToastHelper.showSuccess(
            context,
            message: LocaleKeys.deletedSuccessfully.tr(),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ToastHelper.showError(
            context,
            message: LocaleKeys.errorDeleting.tr(),
          );
        }
      }
    }
  }
}
