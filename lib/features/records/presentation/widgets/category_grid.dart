import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/category_model.dart';
import 'category_item.dart';

/// Grid view widget for displaying categories
class CategoryGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedIndex;
  final Function(int index, CategoryModel category)? onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.selectedIndex,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryItem(
          category: category,
          isSelected: selectedIndex == index,
          onTap: () => onCategorySelected?.call(index, category),
        );
      },
    );
  }
}
