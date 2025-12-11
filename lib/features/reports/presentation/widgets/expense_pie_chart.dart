import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';

class ExpensePieChart extends StatefulWidget {
  final Map<String, double> categoryData;

  const ExpensePieChart({super.key, required this.categoryData});

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryData.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.noDataAvailable.tr(),
          style: AppTextStyles.font16BlackMedium,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 40.r,
          sections: _buildSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = widget.categoryData.values.fold(0.0, (a, b) => a + b);
    final categories = widget.categoryData.entries.toList();
    final colors = _getColors(categories.length);

    return List.generate(categories.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.sp : 14.sp;
      final radius = isTouched ? 65.r : 55.r;
      final percentage = (categories[i].value / total * 100);

      return PieChartSectionData(
        color: colors[i],
        value: categories[i].value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
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
