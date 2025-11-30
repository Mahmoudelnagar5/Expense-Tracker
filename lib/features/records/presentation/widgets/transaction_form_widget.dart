import 'package:expense_tracker_ar/core/helper/functions/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/widgets/form_fields/date_selector_field.dart';
import '../../../../core/widgets/form_fields/payment_type_dropdown_field.dart';
import '../../../../core/widgets/form_fields/amount_input_field.dart';
import '../../../../core/widgets/form_fields/notes_input_field.dart';
import '../../../../core/widgets/form_fields/attachment_button.dart';
import '../../../../core/widgets/form_fields/form_section_label.dart';

class TransactionFormWidget extends StatefulWidget {
  final CategoryModel category;

  const TransactionFormWidget({super.key, required this.category});

  @override
  State<TransactionFormWidget> createState() => _TransactionFormWidgetState();
}

class _TransactionFormWidgetState extends State<TransactionFormWidget>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentType = 'Cash';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _paymentTypes = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'UPI',
    'Wallet',
    'Cheque',
    'Net Banking',
  ];

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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF00BCD4),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    // Validate amount
    if (_amountController.text.isEmpty) {
      ToastHelper.showError(context, message: 'الرجاء إدخال المبلغ');
      return;
    }

    // Animate out before closing
    await _animationController.reverse();

    // Close the bottom sheet and return the transaction data
    if (mounted) {
      Navigator.pop(context, {
        'category': widget.category,
        'date': _selectedDate,
        'paymentType': _selectedPaymentType,
        'amount': double.tryParse(_amountController.text) ?? 0.0,
        'notes': _notesController.text,
        'categoryType': widget.category.type,
        'attachmentImages': null,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
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
                      FormSectionLabel(label: 'حدد التاريخ :'),
                      SizedBox(height: 8.h),
                      DateSelectorField(
                        selectedDate: _selectedDate,
                        onTap: () => _selectDate(context),
                      ),
                      SizedBox(height: 20.h),

                      // Payment Type
                      FormSectionLabel(label: 'نوع الدفع :'),
                      SizedBox(height: 8.h),
                      PaymentTypeDropdownField(
                        selectedPaymentType: _selectedPaymentType,
                        paymentTypes: _paymentTypes,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPaymentType = value;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Amount
                      FormSectionLabel(label: 'كمية :'),
                      SizedBox(height: 8.h),
                      AmountInputField(controller: _amountController),
                      SizedBox(height: 20.h),

                      // Notes
                      FormSectionLabel(label: 'ملحوظة (اختياري) :'),
                      SizedBox(height: 8.h),
                      NotesInputField(controller: _notesController),
                      SizedBox(height: 20.h),

                      // Attachment
                      FormSectionLabel(label: 'مرفق :'),
                      SizedBox(height: 8.h),
                      AttachmentButton(
                        onTap: () {
                          ToastHelper.showInfo(context, message: 'قريبا');
                        },
                      ),
                      SizedBox(height: 30.h),

                      // Submit Button
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ],
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
          Text('إضافة معاملة', style: AppTextStyles.font16BlackBold),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00BCD4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text('إضافة', style: AppTextStyles.font16WhiteSemiBold),
      ),
    );
  }
}
