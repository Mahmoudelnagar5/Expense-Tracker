import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_text_styles.dart';

/// Payment type dropdown field widget
class PaymentTypeDropdownField extends StatelessWidget {
  final String selectedPaymentType;
  final List<String> paymentTypes;
  final ValueChanged<String?> onChanged;

  const PaymentTypeDropdownField({
    super.key,
    required this.selectedPaymentType,
    required this.paymentTypes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.wallet, color: Color(0xFF00BCD4), size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: DropdownButton<String>(
              value: selectedPaymentType,
              underline: SizedBox(),
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF00BCD4),
                size: 24.sp,
              ),
              style: AppTextStyles.font15BlackMedium,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              items: paymentTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(type, style: AppTextStyles.font15BlackMedium),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
