import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helper/database/cache_helper.dart';
import '../../../../core/helper/database/cache_helper_keks.dart';
import '../../../../core/helper/functions/image_picker_dialog.dart';
import '../../../../core/helper/functions/toast_helper.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _imageFile;
  String? _username;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final imageProfilePath = CacheHelper().getData(
      key: CacheHelperKeys.imageProfile,
    );
    if (imageProfilePath != null && imageProfilePath is String) {
      _imageFile = File(imageProfilePath);
    }
    _username = CacheHelper().getData(key: CacheHelperKeys.username);
    setState(() {});
  }

  Future<void> _pickImage() async {
    showImagePickerDialog(
      context,
      onTapGallery: () async {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          await _saveImage(image.path);
          ToastHelper.showSuccess(
            context,
            message: 'تم تحديث صورة الملف الشخصي',
          );
        }
        if (context.mounted) Navigator.of(context).pop();
      },
      onTapCamera: () async {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
        );

        if (image != null) {
          await _saveImage(image.path);
          ToastHelper.showSuccess(
            context,
            message: 'تم تحديث صورة الملف الشخصي',
          );
        }
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }

  Future<void> _saveImage(String path) async {
    await CacheHelper().saveData(
      key: CacheHelperKeys.imageProfile,
      value: path,
    );
    setState(() {
      _imageFile = File(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        // color: Theme.of(context).cardTheme.color,
        color: context.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 35.5.r,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: CircleAvatar(
                  radius: 34.r,
                  backgroundColor: isDark
                      ? const Color(0xFF253342)
                      : Colors.grey[200],
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : null,
                  child: _imageFile == null
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
            Text(
              _username ?? 'المستخدم',
              style: AppTextStyles.font16BlackBold.copyWith(
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
