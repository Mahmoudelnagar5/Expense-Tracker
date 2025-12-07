import 'dart:io';
import 'package:expense_tracker_ar/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_colors.dart';
import '../../helper/functions/image_picker_dialog.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/locale_keys.dart';

/// Widget for displaying and managing multiple image attachments
class ImageAttachmentSection extends StatelessWidget {
  final List<String> images;
  final Function(String) onImageAdded;
  final Function(int) onImageRemoved;

  const ImageAttachmentSection({
    super.key,
    required this.images,
    required this.onImageAdded,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          ...images.asMap().entries.map((entry) {
            return _buildImageItem(entry.key, entry.value);
          }),

          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePicker(context),
      child: Container(
        width: 60.w,
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: context.themeColor(
              light: Colors.grey[300]!,
              dark: Colors.grey[700]!,
            ),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.primaryBrand,
              size: 28.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              LocaleKeys.add.tr(),
              style: AppTextStyles.font14LightGrayRegular.copyWith(
                fontSize: 12.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(int index, String imagePath) {
    return Container(
      width: 70.w,
      height: 70.w,
      margin: EdgeInsets.only(left: 8.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              File(imagePath),
              width: 70.w,
              height: 70.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey[400],
                    size: 24.sp,
                  ),
                );
              },
            ),
          ),
          // Remove button
          Positioned(
            top: 0.h,
            right: -5.w,
            child: GestureDetector(
              onTap: () => onImageRemoved(index),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.systemRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.close, color: Colors.white, size: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    showImagePickerDialog(
      context,
      onTapGallery: () async {
        Navigator.pop(context);
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          onImageAdded(image.path);
        }
      },
      onTapCamera: () async {
        Navigator.pop(context);
        final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
        if (image != null) {
          onImageAdded(image.path);
        }
      },
    );
  }
}
