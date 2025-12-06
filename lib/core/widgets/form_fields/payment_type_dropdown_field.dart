import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/app_colors.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: context.themeColor(
          light: AppColors.neutralSoftGrey2,
          dark: const Color(0xFF253342),
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.wallet, color: AppColors.primaryBrand, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: DropdownButton<String>(
              value: selectedPaymentType,
              underline: SizedBox(),
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.primaryBrand,
                size: 24.sp,
              ),
              style: AppTextStyles.font15BlackMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              dropdownColor: context.surfaceColor,
              borderRadius: BorderRadius.circular(12.r),
              items: paymentTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    type,
                    style: AppTextStyles.font15BlackMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
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
