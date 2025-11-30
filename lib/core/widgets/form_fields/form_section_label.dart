import 'package:flutter/material.dart';
import '../../utils/app_text_styles.dart';

/// Form section label widget
class FormSectionLabel extends StatelessWidget {
  final String label;

  const FormSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.font14LightGrayRegular.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
