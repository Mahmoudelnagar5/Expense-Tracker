import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/helper/constants/app_constants.dart';
import 'package:expense_tracker_ar/core/helper/functions/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/models/transaction_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/form_fields/date_selector_field.dart';
import '../../../../core/widgets/form_fields/payment_type_dropdown_field.dart';
import '../../../../core/widgets/form_fields/amount_input_field.dart';
import '../../../../core/widgets/form_fields/notes_input_field.dart';
import '../../../../core/widgets/form_fields/image_attachment_section.dart';
import '../../../../core/widgets/form_fields/form_section_label.dart';
import '../../controller/record_cubit.dart';
import '../../controller/transaction_form_cubit.dart';
import '../../controller/transaction_form_state.dart';

class TransactionFormWidget extends StatefulWidget {
  final CategoryModel category;
  final TransactionModel? transaction; // For edit mode
  final RecordCubit? recordCubit; // To refresh transactions after submit

  const TransactionFormWidget({
    super.key,
    required this.category,
    this.transaction,
    this.recordCubit,
  });

  bool get isEditMode => transaction != null;

  @override
  State<TransactionFormWidget> createState() => _TransactionFormWidgetState();
}

class _TransactionFormWidgetState extends State<TransactionFormWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Initialize with existing transaction data if in edit mode
    if (widget.isEditMode) {
      final transaction = widget.transaction!;
      _amountController.text = transaction.amount.toStringAsFixed(0);
      _notesController.text = transaction.notes ?? '';
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TransactionFormCubit cubit,
    DateTime currentDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
    if (picked != null && picked != currentDate) {
      cubit.setSelectedDate(picked);
    }
  }

  Future<void> _handleSubmit(TransactionFormCubit cubit) async {
    // Update cubit with current text values
    cubit.setAmount(_amountController.text);
    cubit.setNotes(_notesController.text);

    await cubit.submitTransaction();
  }

  Future<void> _handleSuccess() async {
    // Animate out before closing
    await _animationController.reverse();

    // Refresh transactions in RecordScreen
    widget.recordCubit?.refreshTransactions();

    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionFormCubit(
        category: widget.category,
        transaction: widget.transaction,
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: BlocConsumer<TransactionFormCubit, TransactionFormState>(
                listener: (context, state) {
                  if (state.status == TransactionFormStatus.success) {
                    ToastHelper.showSuccess(
                      context,
                      message: state.isEditMode
                          ? LocaleKeys.updatedSuccessfully.tr()
                          : LocaleKeys.savedSuccessfully.tr(),
                    );
                    _handleSuccess();
                  } else if (state.status == TransactionFormStatus.failure) {
                    ToastHelper.showError(
                      context,
                      message:
                          state.errorMessage ?? LocaleKeys.errorOccurred.tr(),
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<TransactionFormCubit>();

                  return Column(
                    children: [
                      // Header
                      _buildHeader(),
                      Divider(height: 1),

                      // Form Content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date Selector
                              FormSectionLabel(
                                label: LocaleKeys.selectDateLabel.tr(),
                              ),
                              SizedBox(height: 8.h),
                              DateSelectorField(
                                selectedDate: state.selectedDate,
                                onTap: () => _selectDate(
                                  context,
                                  cubit,
                                  state.selectedDate,
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Payment Type
                              FormSectionLabel(
                                label: LocaleKeys.paymentTypeLabel.tr(),
                              ),
                              SizedBox(height: 8.h),
                              PaymentTypeDropdownField(
                                selectedPaymentType: state.selectedPaymentType,
                                paymentTypes: AppConstants.paymentTypes,
                                onChanged: (value) {
                                  if (value != null) {
                                    cubit.setPaymentType(value);
                                  }
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Amount
                              FormSectionLabel(
                                label: LocaleKeys.amountLabel.tr(),
                              ),
                              SizedBox(height: 8.h),
                              AmountInputField(controller: _amountController),
                              SizedBox(height: 20.h),

                              // Notes
                              FormSectionLabel(
                                label: LocaleKeys.noteOptionalLabel.tr(),
                              ),
                              SizedBox(height: 8.h),
                              NotesInputField(controller: _notesController),
                              SizedBox(height: 20.h),

                              // Attachment
                              FormSectionLabel(
                                label: LocaleKeys.attachmentLabel.tr(),
                              ),
                              SizedBox(height: 8.h),
                              ImageAttachmentSection(
                                images: state.attachmentImages,
                                onImageAdded: (imagePath) {
                                  cubit.addImage(imagePath);
                                },
                                onImageRemoved: (index) {
                                  cubit.removeImage(index);
                                },
                              ),
                              SizedBox(height: 30.h),

                              // Submit Button
                              _buildSubmitButton(cubit, state),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Text(
            widget.isEditMode
                ? LocaleKeys.editTransaction.tr()
                : LocaleKeys.addTransaction.tr(),
            style: AppTextStyles.font16BlackBold.copyWith(
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600], size: 20.sp),
            onPressed: () async {
              await _animationController.reverse();
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    TransactionFormCubit cubit,
    TransactionFormState state,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: state.isSubmitting ? null : () => _handleSubmit(cubit),
        style: ElevatedButton.styleFrom(
          shadowColor: AppColors.gradientG3_1,
          backgroundColor: AppColors.primaryBrand,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: state.isSubmitting
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                state.isEditMode ? LocaleKeys.edit.tr() : LocaleKeys.add.tr(),
                style: AppTextStyles.font16WhiteSemiBold,
              ),
      ),
    );
  }
}
