import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../data/models/onboarding_item.dart';
import '../../../../core/utils/app_text_styles.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Circle responsive
          Container(
            width: 180.w,
            height: 180.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Center(
              child: Container(
                width: 140.w,
                height: 140.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Center(
                  child: Icon(item.icon, size: 65.sp, color: Colors.white),
                ),
              ),
            ),
          ),

          SizedBox(height: 60.h),

          Text(
            item.title,
            style: AppTextStyles.font28WhiteBold,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20.h),
          Text(
            item.description,
            style: AppTextStyles.font20WhiteRegular.copyWith(
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
