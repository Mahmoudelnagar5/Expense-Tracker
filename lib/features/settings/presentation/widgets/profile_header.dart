import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helper/functions/image_picker_dialog.dart';
import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';
import '../controller/settings_cubit.dart';
import '../controller/settings_state.dart';
import 'edit_username_dialog.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    showImagePickerDialog(
      context,
      onTapGallery: () async {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          if (context.mounted) {
            context.read<SettingsCubit>().updateProfileImage(File(image.path));
            ToastHelper.showSuccess(
              context,
              message: LocaleKeys.profilePictureUpdated.tr(),
            );
          }
        }
        if (context.mounted) Navigator.of(context).pop();
      },
      onTapCamera: () async {
        final XFile? image = await picker.pickImage(source: ImageSource.camera);

        if (image != null) {
          if (context.mounted) {
            context.read<SettingsCubit>().updateProfileImage(File(image.path));
            ToastHelper.showSuccess(
              context,
              message: LocaleKeys.profilePictureUpdated.tr(),
            );
          }
        }
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }

  void _editUsername(BuildContext context, String currentUsername) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<SettingsCubit>(),
        child: EditUsernameDialog(currentUsername: currentUsername),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final imageFile = state.imageFile;
        final username = state.username ?? LocaleKeys.user.tr();

        return FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Container(
            color: context.backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(context),
                  child: CircleAvatar(
                    radius: 35.5.r,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: CircleAvatar(
                      radius: 34.r,
                      backgroundColor: isDark
                          ? const Color(0xFF253342)
                          : Colors.grey[200],
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile)
                          : null,
                      child: imageFile == null
                          ? Icon(
                              Icons.person,
                              size: 35.sp,
                              color: isDark
                                  ? const Color(0xFF6B7A8F)
                                  : Colors.grey[400],
                            )
                          : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _editUsername(context, state.username ?? ''),
                  child: Row(
                    children: [
                      Text(
                        username,
                        style: AppTextStyles.font16BlackBold.copyWith(
                          fontSize: 16.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.edit,
                        size: 18.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
