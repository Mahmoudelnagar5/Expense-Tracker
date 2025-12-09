import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';

class EmptyStateWidget extends StatefulWidget {
  final String? message;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    this.message,
    this.subtitle,
    this.icon,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon Container
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 180.w,
                    height: 180.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.primary.withOpacity(0.01),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Main Icon
                        Icon(
                          widget.icon ?? Icons.receipt_long_outlined,
                          size: 90.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                // Title
                Text(
                  widget.message ?? LocaleKeys.noRecordsYet.tr(),
                  style: AppTextStyles.font18BlackBold.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                // Subtitle
                Text(
                  widget.subtitle ?? LocaleKeys.startTrackingMessage.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.onActionPressed != null) ...[
                  SizedBox(height: 32.h),
                  // Action Button
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FilledButton.icon(
                      onPressed: widget.onActionPressed,
                      icon: Icon(Icons.add_circle_outline, size: 20.sp),
                      label: Text(
                        widget.actionLabel ??
                            LocaleKeys.addFirstTransaction.tr(),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
