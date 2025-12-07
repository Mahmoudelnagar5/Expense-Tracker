import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_text_styles.dart';

class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}

class TrendLineChart extends StatelessWidget {
  final List<ChartData> incomeData;
  final List<ChartData> expenseData;

  const TrendLineChart({
    super.key,
    required this.incomeData,
    required this.expenseData,
  });

  @override
  Widget build(BuildContext context) {
    if (incomeData.isEmpty && expenseData.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: AppTextStyles.font16BlackMedium,
        ),
      );
    }

    return SfCartesianChart(
      key: const ValueKey('trend_chart'),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: TextStyle(fontSize: 12.sp),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        animationDuration: 0,
        builder:
            (
              dynamic data,
              dynamic point,
              dynamic series,
              int pointIndex,
              int seriesIndex,
            ) {
              return Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '${(data as ChartData).label}: ${data.value.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              );
            },
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
          fontSize: 10.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(
          fontSize: 10.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        numberFormat: null,
      ),
      series: <CartesianSeries>[
        SplineSeries<ChartData, String>(
          name: 'Income',
          dataSource: incomeData,
          xValueMapper: (ChartData data, _) => data.label,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.green,
          animationDuration: 0,
          markerSettings: MarkerSettings(
            isVisible: true,
            height: 6.h,
            width: 6.w,
            borderColor: Colors.green,
          ),
          width: 2,
        ),
        SplineSeries<ChartData, String>(
          name: 'Expense',
          dataSource: expenseData,
          xValueMapper: (ChartData data, _) => data.label,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.red,
          animationDuration: 0,
          markerSettings: MarkerSettings(
            isVisible: true,
            height: 6.h,
            width: 6.w,
            borderColor: Colors.red,
          ),
          width: 2,
        ),
      ],
    );
  }
}
