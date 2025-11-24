import 'package:flutter/material.dart';
import '../../data/models/onboarding_item.dart';
import '../../../../core/utils/app_text_styles.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Circle
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Center(
                  child: Icon(item.icon, size: 60, color: Colors.white),
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          Text(
            item.title,
            style: AppTextStyles.font28WhiteBold,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          Text(
            item.description,
            style: AppTextStyles.font20WhiteRegular.copyWith(
              color: Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
