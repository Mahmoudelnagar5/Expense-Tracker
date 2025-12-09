import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker_ar/core/utils/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/database/sqlite_helper.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/income_expense_bar_chart.dart';
import '../widgets/trend_line_chart.dart' show TrendLineChart, ChartData;
import '../widgets/category_donut_chart.dart';
import '../widgets/chart_legend_widget.dart';

class ReportsScreen extends StatefulWidget {
  final ValueNotifier<bool>? refreshNotifier;

  const ReportsScreen({super.key, this.refreshNotifier});

  @override
  State<ReportsScreen> createState() => ReportsScreenState();
}

class ReportsScreenState extends State<ReportsScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final SQLiteHelper _dbHelper = SQLiteHelper();
  String _selectedChart = 'category_breakdown';

  Map<String, double> expenseCategoryData = {};
  Map<String, double> incomeCategoryData = {};
  List<double> monthlyIncome = [];
  List<double> monthlyExpense = [];
  List<String> monthLabels = [];
  List<ChartData> incomeChartData = [];
  List<ChartData> expenseChartData = [];

  bool isLoading = true;
  bool _hasBuiltCharts = false; // Track if charts have been built

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();

    // Listen to refresh notifier
    widget.refreshNotifier?.addListener(_handleRefresh);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload data when locale changes
    if (_hasBuiltCharts) {
      _loadData();
    }
  }

  void _handleRefresh() {
    if (mounted) {
      refreshData();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Reload data when app returns to foreground
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  @override
  void dispose() {
    widget.refreshNotifier?.removeListener(_handleRefresh);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Public method to refresh data - can be called externally
  void refreshData() {
    if (mounted && !isLoading) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    // Get data for current month
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    // Load expense category data
    final expenseData = await _dbHelper.getCategorySummary(
      startOfMonth,
      endOfMonth,
      'expense',
    );

    // Load income category data
    final incomeData = await _dbHelper.getCategorySummary(
      startOfMonth,
      endOfMonth,
      'income',
    );

    // Load monthly data for last 6 months
    List<double> incomes = [];
    List<double> expenses = [];
    List<String> labels = [];
    List<ChartData> incomeChart = [];
    List<ChartData> expenseChart = [];

    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthStart = DateTime(monthDate.year, monthDate.month, 1);
      final monthEnd = DateTime(
        monthDate.year,
        monthDate.month + 1,
        0,
        23,
        59,
        59,
      );

      final income = await _dbHelper.getTotalIncome(monthStart, monthEnd);
      final expense = await _dbHelper.getTotalExpenses(monthStart, monthEnd);

      incomes.add(income);
      expenses.add(expense);

      final monthLabel = DateFormat(
        'MMM',
        context.locale.languageCode,
      ).format(monthDate);
      labels.add(monthLabel);

      incomeChart.add(ChartData(monthLabel, income));
      expenseChart.add(ChartData(monthLabel, expense));
    }

    if (!mounted) return;

    setState(() {
      expenseCategoryData = expenseData;
      incomeCategoryData = incomeData;
      monthlyIncome = incomes;
      monthlyExpense = expenses;
      monthLabels = labels;
      incomeChartData = incomeChart;
      expenseChartData = expenseChart;
      isLoading = false;
      _hasBuiltCharts = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading && !_hasBuiltCharts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (expenseCategoryData.isEmpty && incomeCategoryData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 100.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20.h),
            Text(
              LocaleKeys.reportsScreen.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              LocaleKeys.noData.tr(),
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Dropdown Chart Selector
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: DropdownButton<String>(
            value: _selectedChart,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, size: 24.sp),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            items: [
              DropdownMenuItem(
                value: 'category_breakdown',
                child: Row(
                  children: [
                    Icon(
                      Icons.donut_small,
                      size: 18.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(LocaleKeys.categoryBreakdown.tr()),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'expense_pie',
                child: Row(
                  children: [
                    Icon(
                      Icons.pie_chart,
                      size: 18.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(LocaleKeys.expensePie.tr()),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'income_vs_expense',
                child: Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 18.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(LocaleKeys.incomeVsExpense.tr()),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'trend_line',
                child: Row(
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 18.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(LocaleKeys.trendLine.tr()),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedChart = value;
                });
              }
            },
          ),
        ),
        // Chart Display
        Expanded(
          child: IndexedStack(
            index: _getChartIndex(),
            children: [
              _buildCategoryBreakdownChart(),
              _buildExpensePieChart(),
              _buildIncomeVsExpenseChart(),
              _buildTrendLineChart(),
            ],
          ),
        ),
      ],
    );
  }

  int _getChartIndex() {
    switch (_selectedChart) {
      case 'category_breakdown':
        return 0;
      case 'expense_pie':
        return 1;
      case 'income_vs_expense':
        return 2;
      case 'trend_line':
        return 3;
      default:
        return 0;
    }
  }

  Widget _buildCategoryBreakdownChart() {
    return _buildChartSection(
      child: SingleChildScrollView(
        key: const ValueKey('category_breakdown_scroll'),
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            SizedBox(height: 16.h),
            if (expenseCategoryData.isNotEmpty) ...[
              SizedBox(
                height: 300.h,
                child: CategoryDonutChart(
                  categoryData: expenseCategoryData,
                  title: LocaleKeys.expenseCategories.tr(),
                  key: const ValueKey('expense_cat'),
                ),
              ),
              SizedBox(height: 24.h),
            ],
            if (incomeCategoryData.isNotEmpty) ...[
              SizedBox(
                height: 300.h,
                child: CategoryDonutChart(
                  categoryData: incomeCategoryData,
                  title: LocaleKeys.incomeCategories.tr(),
                  key: const ValueKey('income_cat'),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpensePieChart() {
    return _buildChartSection(
      child: SingleChildScrollView(
        key: const ValueKey('expense_pie_scroll'),
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.expenseDistribution.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 16.h),
            ExpensePieChart(
              key: const ValueKey('expense_pie'),
              categoryData: expenseCategoryData,
            ),
            SizedBox(height: 16.h),
            if (expenseCategoryData.isNotEmpty)
              ChartLegendWidget(categoryData: expenseCategoryData),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeVsExpenseChart() {
    return _buildChartSection(
      child: SingleChildScrollView(
        key: const ValueKey('income_expense_scroll'),
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              LocaleKeys.monthlyIncomeVsExpense.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 25.h),
            IncomeExpenseBarChart(
              key: const ValueKey('income_expense'),
              incomeData: monthlyIncome,
              expenseData: monthlyExpense,
              labels: monthLabels,
            ),
            SizedBox(height: 16.h),
            _buildLegendRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendLineChart() {
    return _buildChartSection(
      child: Column(
        key: const ValueKey('trend_line_column'),
        children: [
          SizedBox(height: 20.h),
          Text(
            LocaleKeys.trendAnalysis.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 25.h),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight > 0
                        ? constraints.maxHeight
                        : 400.h,
                    child: TrendLineChart(
                        key: const ValueKey('trend_line'),
                      incomeData: incomeChartData,
                      expenseData: expenseChartData,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildChartSection({required Widget child}) {
    return Container(padding: EdgeInsets.zero, child: child);
  }

  Widget _buildLegendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(LocaleKeys.income.tr(), Colors.green),
        SizedBox(width: 24.w),
        _buildLegendItem(LocaleKeys.expense.tr(), Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
