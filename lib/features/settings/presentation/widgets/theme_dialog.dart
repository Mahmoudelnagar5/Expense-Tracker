import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
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

  final List<Map<String, dynamic>> _themes = [
    {'name': 'وضع الإضاءة', 'code': 'light', 'icon': Icons.light_mode},
    {'name': 'الوضع الليلي', 'code': 'dark', 'icon': Icons.dark_mode},
    {
      'name': 'تلقائي (حسب النظام)',
      'code': 'system',
      'icon': Icons.brightness_auto,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.initialValue ?? 'light';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(15.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.45,
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
                Text('مواضيع التطبيق', style: AppTextStyles.font18BlackBold),
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
                      Text(
                        theme['name'],
                        style: AppTextStyles.font16BlackMedium.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        theme['icon'],
                        color: _selectedTheme == theme['code']
                            ? AppColors.primaryBrand
                            : Colors.grey,
                        size: 22.sp,
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
                  widget.onSave(_selectedTheme!);
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
