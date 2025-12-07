import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/helper/functions/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../presentation/controller/settings_cubit.dart';

class EditUsernameDialog extends StatefulWidget {
  final String currentUsername;

  const EditUsernameDialog({super.key, required this.currentUsername});

  @override
  State<EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<EditUsernameDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentUsername);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveUsername() {
    final newUsername = _controller.text.trim();
    if (newUsername.isEmpty) {
      ToastHelper.showError(context, message: LocaleKeys.enterUsername.tr());
      return;
    }

    context.read<SettingsCubit>().updateUsername(newUsername);
    Navigator.of(context).pop();
    ToastHelper.showSuccess(context, message: LocaleKeys.usernameUpdated.tr());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocaleKeys.editUsername.tr(),
        style: AppTextStyles.font16BlackBold,
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(border: const OutlineInputBorder()),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.cancel.tr()),
        ),
        ElevatedButton(
          onPressed: _saveUsername,
          child: Text(LocaleKeys.save.tr()),
        ),
      ],
    );
  }
}
