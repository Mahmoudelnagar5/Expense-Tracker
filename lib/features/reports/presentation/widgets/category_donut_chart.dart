import 'package:easy_localization/easy_localization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/locale_keys.dart';

class CategoryData {
  final String category;
  final double amount;
  final Color color;

  CategoryData(this.category, this.amount, this.color);
}

class CategoryDonutChart extends StatelessWidget {
  final Map<String, double> categoryData;
  final String title;

  const CategoryDonutChart({
    super.key,
    required this.categoryData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.noDataAvailable.tr(),
          style: AppTextStyles.font16BlackMedium,
        ),
      );
    }

    final chartData = _prepareChartData();

    return SfCircularChart(
      title: ChartTitle(
        text: title,
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: TextStyle(fontSize: 10.sp),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x: point.y',
        animationDuration: 0,
      ),
      series: <CircularSeries>[
        DoughnutSeries<CategoryData, String>(
          dataSource: chartData,
          xValueMapper: (CategoryData data, _) => data.category,
          yValueMapper: (CategoryData data, _) => data.amount,
          pointColorMapper: (CategoryData data, _) => data.color,
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
            builder:
                (
                  dynamic data,
                  dynamic point,
                  dynamic series,
                  int pointIndex,
                  int seriesIndex,
                ) {
                  final total = categoryData.values.fold(0.0, (a, b) => a + b);
                  final percentage =
                      ((data as CategoryData).amount / total * 100);
                  return Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
          ),
          innerRadius: '60%',
          explode: true,
          explodeOffset: '5%',
          explodeIndex: 0,
        ),
      ],
    );
  }

  List<CategoryData> _prepareChartData() {
    final colors = [
      const Color(0xFFFF6384),
      const Color(0xFF36A2EB),
      const Color(0xFFFFCE56),
      const Color(0xFF4BC0C0),
      const Color(0xFF9966FF),
      const Color(0xFFFF9F40),
      const Color(0xFFFF6384),
      const Color(0xFFC9CBCF),
    ];

    final entries = categoryData.entries.toList();
    return List.generate(
      entries.length,
      (i) => CategoryData(
        entries[i].key,
        entries[i].value,
        colors[i % colors.length],
      ),
    );
  }
}
