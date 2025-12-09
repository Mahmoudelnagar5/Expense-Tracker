import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_text_styles.dart';

class IncomeExpenseBarChart extends StatelessWidget {
  final List<double> incomeData;
  final List<double> expenseData;
  final List<String> labels;

  const IncomeExpenseBarChart({
    super.key,
    required this.incomeData,
    required this.expenseData,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    if (incomeData.isEmpty || expenseData.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: AppTextStyles.font16BlackMedium,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxY(),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final label = labels[group.x.toInt()];
                  final value = rod.toY.toStringAsFixed(0);
                  return BarTooltipItem(
                    '$label\n$value',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= labels.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        labels[value.toInt()],
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                  reservedSize: 30.h,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Text(
                        _formatYAxisLabel(value),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    );
                    // }
                  },
                  reservedSize: 45.w,
                  interval: _getMaxY() / 4,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: _buildBarGroups(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _getMaxY() / 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _getMaxY() {
    final maxIncome = incomeData.isEmpty
        ? 0.0
        : incomeData.reduce((a, b) => a > b ? a : b);
    final maxExpense = expenseData.isEmpty
        ? 0.0
        : expenseData.reduce((a, b) => a > b ? a : b);
    final max = maxIncome > maxExpense ? maxIncome : maxExpense;
    return (max * 1.2).ceilToDouble();
  }

  String _formatYAxisLabel(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toInt().toString();
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(
      incomeData.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: incomeData[index],
            color: Colors.green,
            width: 12.w,
            borderRadius: BorderRadius.circular(4.r),
          ),
          BarChartRodData(
            toY: expenseData[index],
            color: Colors.red,
            width: 12.w,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ],
      ),
    );
  }
}
