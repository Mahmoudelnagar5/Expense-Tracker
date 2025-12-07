import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/utils/locale_keys.dart';
import 'package:expense_tracker_ar/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.obscureText = false,
    this.onIconPressed,
    this.onSaved,
    this.prefixIcon,
    this.suffixIcon,
    this.autofillHints,
    this.controller,
    this.validator,
    this.errorText,
  });
  final String? hintText;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onIconPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 500),
      child: TextFormField(
        controller: controller,
        autofillHints: autofillHints,
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.requiredField.tr();
              }
              return null;
            },
        onSaved: onSaved,
        obscureText: obscureText,
        onChanged: onChanged,
        style: AppTextStyles.font15BlackMedium,

        decoration: InputDecoration(
          errorText: errorText,
          errorMaxLines: 4,
          hintText: hintText,
          hintStyle: AppTextStyles.font14LightGrayRegular,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primaryLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primaryLight),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon != null
              ? IconButton(
                  onPressed: onIconPressed,
                  color: AppColors.primaryLight,
                  icon: Icon(prefixIcon, size: 18, color: Colors.blue),
                )
              : null,
        ),
      ),
    );
  }
}
