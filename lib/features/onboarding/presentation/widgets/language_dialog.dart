import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/utils/locale_keys.dart';
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:expense_tracker_ar/core/utils/font_weight_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import 'save_button.dart';

class LanguageDialog extends StatefulWidget {
  final List<Map<String, String>> languages;
  final String? initialValue;
  final Function(String) onSave;

  const LanguageDialog({
    super.key,
    required this.languages,
    this.initialValue,
    required this.onSave,
  });

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late String? _selectedLanguage;
  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(12.w),
        constraints: BoxConstraints(),
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    LocaleKeys.chooseLanguage.tr(),
                    style: AppTextStyles.font18BlackBold,
                  ),
                ),
                SizedBox(width: 40.w), // Balance the close icon
              ],
            ),
            SizedBox(height: 20.h),

            // Language options
            ...widget.languages.asMap().entries.map((entry) {
              final language = entry.value;
              return FadeInLeft(
                duration: Duration(milliseconds: 400 + (entry.key * 100)),
                child: RadioListTile<String>(
                  value: language['code']!,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  },
                  activeColor: AppColors.primaryBrand,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          language['name']!,
                          style: AppTextStyles.font16BlackMedium.copyWith(
                            fontWeight: FontWeightHelper.semiBold,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          language['flag']!,
                          style: AppTextStyles.font16BlackMedium.copyWith(
                            fontWeight: FontWeightHelper.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            }),

            SizedBox(height: 10.h),

            // Save Button
            Flexible(
              child: SaveButton(
                onPressed: () {
                  if (_selectedLanguage != null) {
                    widget.onSave(_selectedLanguage!);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
