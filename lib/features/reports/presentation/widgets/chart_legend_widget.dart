import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';

class ChartLegendWidget extends StatelessWidget {
  final Map<String, double> categoryData;

  const ChartLegendWidget({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(categoryData.length);
    final entries = categoryData.entries.toList();
    final total = categoryData.values.fold(0.0, (a, b) => a + b);

    return Container(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.categories.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          ...List.generate(entries.length, (i) {
            final percentage = (entries[i].value / total * 100);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: colors[i],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      entries[i].key,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    entries[i].value.toStringAsFixed(0),
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Color> _getColors(int count) {
    final baseColors = [
      const Color(0xFFFF6384),
      const Color(0xFF36A2EB),
      const Color(0xFFFFCE56),
      const Color(0xFF4BC0C0),
      const Color(0xFF9966FF),
      const Color(0xFFFF9F40),
      const Color(0xFFFF6384),
      const Color(0xFFC9CBCF),
    ];

    return List.generate(
      count,
      (index) => baseColors[index % baseColors.length],
    );
  }
}
