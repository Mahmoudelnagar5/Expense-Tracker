import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:expense_tracker_ar/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';
import 'save_button.dart';

class CurrencyDialog extends StatefulWidget {
  final List<Map<String, String>> currencies;
  final String? initialValue;
  final Function(String) onSave;

  const CurrencyDialog({
    super.key,
    required this.currencies,
    this.initialValue,
    required this.onSave,
  });

  @override
  State<CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends State<CurrencyDialog> {
  late String? _selectedCurrency;
  late List<Map<String, String>> _filteredCurrencies;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.initialValue;
    _filteredCurrencies = widget.currencies;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCurrencies = widget.currencies.where((currency) {
        final name = currency['name']!.toLowerCase();
        final code = currency['code']!.toLowerCase();
        final symbol = currency['symbol']!.toLowerCase();
        return name.contains(query) ||
            code.contains(query) ||
            symbol.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(15.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey,
                ),
                Text(
                  LocaleKeys.chooseCurrency.tr(),
                  style: AppTextStyles.font18BlackBold,
                ),
                SizedBox(width: 40.w), // Balance the close icon
              ],
            ),
            SizedBox(height: 20.h),

            // Search
            CustomTextField(
              controller: _searchController,
              hintText: LocaleKeys.searchCurrency.tr(),
              prefixIcon: Icons.search,
            ),
            SizedBox(height: 20.h),

            // List
            Expanded(
              child: ListView.separated(
                itemCount: _filteredCurrencies.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final currency = _filteredCurrencies[index];
                  final isSelected = _selectedCurrency == currency['code'];
                  return FadeInLeft(
                    duration: const Duration(milliseconds: 500),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCurrency = currency['code'];
                        });
                      },
                      borderRadius: BorderRadius.circular(10.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 8.w,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${currency['code']} - ${currency['name']}',
                                style: AppTextStyles.font16BlackMedium.copyWith(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              width: 21.w,
                              height: 21.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryLight
                                      : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 12.w,
                                        height: 12.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryLight,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),

            // Save Button
            SaveButton(
              onPressed: () {
                if (_selectedCurrency != null) {
                  widget.onSave(_selectedCurrency!);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
