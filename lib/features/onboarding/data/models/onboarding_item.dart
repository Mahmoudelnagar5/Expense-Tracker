import 'package:flutter/material.dart';

class OnboardingItem {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final Color iconColor;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.iconColor,
  });
}
