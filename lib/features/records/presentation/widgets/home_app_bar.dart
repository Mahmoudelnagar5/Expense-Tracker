import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/database/cache_helper.dart';
import '../../../../core/helper/database/cache_helper_keks.dart';
import '../../../../core/utils/app_text_styles.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProfilePath = CacheHelper().getData(
      key: CacheHelperKeys.imageProfile,
    );
    final imageFile = imageProfilePath != null && imageProfilePath is String
        ? File(imageProfilePath)
        : null;

    final username = CacheHelper().getData(key: CacheHelperKeys.username);
    final currency = CacheHelper().getData(key: CacheHelperKeys.currency);
    return AppBar(
      backgroundColor: Color(0xFF00BCD4),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: imageFile != null
                    ? FileImage(imageFile)
                    : null,
                child: imageFile == null
                    ? Icon(Icons.person, size: 60.sp, color: Colors.grey[400])
                    : null,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username ?? 'Username',
                    style: AppTextStyles.font16BlackBold.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'رمز العملة : ${currency.toString()}' ?? 'EGP',
                    style: AppTextStyles.font14LightGrayRegular.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined, size: 25.sp),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
