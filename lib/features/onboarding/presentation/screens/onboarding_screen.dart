import 'package:expense_tracker_ar/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/clippers.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../data/models/onboarding_item.dart';
import '../widgets/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: "المصاريف",
      description: "احسبها صح ... كُن على علم بمصاريفك و مصادر دخلك",
      color: AppColors.onboardingGreen, // Light Green
      icon: Icons.account_balance_wallet,
      iconColor: Colors.green,
    ),
    OnboardingItem(
      title: "تسجيل المعاملات",
      description: "سجّل نفقاتك اليومية لتساعدك في إدارة أموالك بشكل أفضل",
      color: AppColors.onboardingPurple, // Purple
      icon: Icons.edit_note,
      iconColor: Colors.deepPurple,
    ),
    OnboardingItem(
      title: "إدارة الميزانية",
      description:
          "احصل على تنبيهات وإشعارات عند تجاوز ميزانيتك المحددة لتجنب الإنفاق الزائد",
      color: AppColors.onboardingBlue, // blue
      icon: Icons.notifications_active,
      iconColor: Colors.blue,
    ),
    OnboardingItem(
      title: "التحليل والمتابعة",
      description:
          "تتبع مصاريفك وحلل إنفاقك من خلال رسوم بيانية مفصلة لتتأكد من عدم الإسراف",
      color: AppColors.onboardingYellow, // yellow
      icon: Icons.analytics,
      iconColor: Colors.yellow,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Animation
          AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              int page = _pageController.hasClients
                  ? (_pageController.page?.floor() ?? 0)
                  : 0;
              double offset = _pageController.hasClients
                  ? ((_pageController.page ?? 0) - page)
                  : 0;

              return Stack(
                children: [
                  // Current Page Color (Base)
                  Container(color: _items[page % _items.length].color),

                  // Next Page Color (Overlay from bottom with circular reveal)
                  if (page + 1 < _items.length)
                    ClipPath(
                      clipper: CircularRevealClipper(offset),
                      child: Container(color: _items[page + 1].color),
                    ),
                ],
              );
            },
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: TextButton(
                      onPressed: () {
                        context.go(AppRouter.setupScreen);
                      },
                      child: Text("تخطي", style: AppTextStyles.font16WhiteBold),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _items.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPageContent(item: _items[index]);
                    },
                  ),
                ),

                // Bottom Section: Button and Indicators
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 40.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  child: Column(
                    children: [
                      // Action Button
                      SizedBox(
                        width: 150.w,
                        height: 50.h,
                        child: OutlinedButton(
                          onPressed: () {
                            if (_currentPage < _items.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              // Finish onboarding
                              context.go(AppRouter.setupScreen);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _currentPage == _items.length - 1
                                ? "ابدأ"
                                : "التالي",
                            style: AppTextStyles.font18WhiteBold,
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_items.length, (index) {
                          bool isActive = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            child: isActive
                                ? Icon(
                                    _items[index].icon,
                                    color: Colors.white,
                                    size: 24.sp,
                                  )
                                : Container(
                                    width: 12.w,
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
