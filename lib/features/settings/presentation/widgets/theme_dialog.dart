import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../onboarding/presentation/widgets/save_button.dart';

class ThemeDialog extends StatefulWidget {
  final String? initialValue;
  final Function(String) onSave;

  const ThemeDialog({super.key, this.initialValue, required this.onSave});

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  late String? _selectedTheme;

  late final List<Map<String, dynamic>> _themes;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.initialValue ?? 'light';
    _themes = [
      {
        'name': LocaleKeys.lightMode.tr(),
        'code': 'light',
        'icon': Icons.light_mode,
      },
      {
        'name': LocaleKeys.darkMode.tr(),
        'code': 'dark',
        'icon': Icons.dark_mode,
      },
      {
        'name': LocaleKeys.systemTheme.tr(),
        'code': 'system',
        'icon': Icons.brightness_auto,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(12.w),

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
                  LocaleKeys.appThemes.tr(),
                  style: AppTextStyles.font18BlackBold,
                ),
                SizedBox(width: 40.w),
              ],
            ),
            SizedBox(height: 20.h),

            // Theme options
            ..._themes.asMap().entries.map((entry) {
              final theme = entry.value;
              return FadeInLeft(
                duration: Duration(milliseconds: 400 + (entry.key * 100)),
                child: RadioListTile<String>(
                  value: theme['code'],
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value;
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
                          theme['name']!,
                          style: AppTextStyles.font16BlackMedium.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Flexible(
                        child: Icon(
                          theme['icon'],
                          color: _selectedTheme == theme['code']
                              ? AppColors.primaryBrand
                              : Colors.grey,
                          size: 22.sp,
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
            SaveButton(
              onPressed: () {
                if (_selectedTheme != null) {
                  Future.delayed(const Duration(milliseconds: 150), () {
                    widget.onSave(_selectedTheme!);
                  });
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
