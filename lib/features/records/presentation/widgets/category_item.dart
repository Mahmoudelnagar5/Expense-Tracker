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
                  ? Color(0xFF00BCD4).withValues(alpha: .16)
                  : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              category.icon,
              size: 28.sp,
              color: isSelected ? Color(0xFF00BCD4) : Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              category.name,
              style: AppTextStyles.font14LightGrayRegular.copyWith(
                fontSize: 12.sp,
                color: isSelected ? Color(0xFF00BCD4) : Colors.black87,
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
