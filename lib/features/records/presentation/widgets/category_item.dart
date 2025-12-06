import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/utils/app_text_styles.dart';

/// Individual category item widget with icon and label
class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.category,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(.13)
                  : (isDark ? const Color(0xFF253342) : Colors.grey[200]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              category.icon,
              size: 28.sp,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : (isDark ? const Color(0xFFB8C5D6) : Colors.grey[700]),
            ),
          ),
          SizedBox(height: 8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              category.name,
              style: AppTextStyles.font14LightGrayRegular.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
