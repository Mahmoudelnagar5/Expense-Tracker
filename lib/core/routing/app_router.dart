import 'package:expense_tracker_ar/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/records/presentation/screens/main_screen.dart';
import '../../features/onboarding/presentation/screens/setup_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

abstract class AppRouter {
  static const String onBoardingScreen = '/';
  static const String setupScreen = '/setup';
  static const String homeScreen = '/home';
  static const String settingsScreen = '/settings';

  static final router = GoRouter(
    initialLocation: onBoardingScreen,
    routes: [
      GoRoute(
        path: onBoardingScreen,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const OnboardingScreen(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),

      GoRoute(
        path: setupScreen,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SetupScreen(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: homeScreen,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const MainScreen(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: settingsScreen,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SettingsScreen(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
    ],
  );
}

Widget _transitionsBuilder(context, animation, secondaryAnimation, child) {
  final tween = Tween(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));
  final offsetAnimation = animation.drive(tween);
  return SlideTransition(position: offsetAnimation, child: child);
}
