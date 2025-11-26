import 'package:animate_do/animate_do.dart';
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(15.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
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
                Text('اختر اللغة', style: AppTextStyles.font18BlackBold),
                SizedBox(width: 40.w), // Balance the close icon
              ],
            ),
            SizedBox(height: 20.h),

            // List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: widget.languages.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final language = widget.languages[index];
                  final isSelected = _selectedLanguage == language['code'];
                  return FadeInLeft(
                    duration: const Duration(milliseconds: 500),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = language['code'];
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
                                '${language['flag']} ${language['name']}',
                                style: AppTextStyles.font16BlackMedium.copyWith(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.onboardingBlue
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
                                          color: AppColors.onboardingBlue,
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

            // Save Button
            SaveButton(
              onPressed: () {
                if (_selectedLanguage != null) {
                  widget.onSave(_selectedLanguage!);
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
