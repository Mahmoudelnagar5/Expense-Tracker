import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helper/constants/app_constants.dart';
import '../../../../core/helper/database/cache_helper.dart';
import '../../../../core/helper/database/cache_helper_keks.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../settings/presentation/controller/settings_cubit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProfilePath = CacheHelper().getData(
      key: CacheHelperKeys.imageProfile,
    );
    File? imageFile;
    if (imageProfilePath != null && imageProfilePath is String) {
      imageFile = File(imageProfilePath);
    }
    final username = CacheHelper().getData(key: CacheHelperKeys.username);
    final currency = context.watch<SettingsCubit>().state.currency ?? 'USD';
    final currencySymbol = AppConstants.currencies.firstWhere(
      (c) => c['code'] == currency,
      orElse: () => {'symbol': ''},
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26.5.r,
                backgroundColor: AppColors.primaryBrand,
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile)
                      : null,
                  child: imageFile == null
                      ? Icon(Icons.person, size: 35.sp, color: Colors.grey[400])
                      : null,
                ),
              ),

              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      username ?? 'Username',
                      style: AppTextStyles.font16BlackBold.copyWith(
                        fontSize: 14.sp,
                        // color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '${LocaleKeys.currencySymbol.tr()} : ${currencySymbol['symbol']}',
                    style: AppTextStyles.font14LightGrayRegular.copyWith(
                      fontSize: 12.sp,
                      color: isDark
                          ? const Color(0xFFB8C5D6)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              context.push(AppRouter.settingsScreen);
            },
            icon: Icon(
              Icons.settings_outlined,
              size: 25.sp,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
