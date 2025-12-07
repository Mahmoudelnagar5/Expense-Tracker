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
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin {
  final SQLiteHelper _dbHelper = SQLiteHelper();
  late TabController _tabController;
  int _currentTabIndex = 0;

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
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
    _loadData();

    // Listen to refresh notifier
    widget.refreshNotifier?.addListener(_handleRefresh);
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
    _tabController.dispose();
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

    for (int i = 11; i >= 0; i--) {
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

      final monthLabel = DateFormat('MMM').format(monthDate);
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
        TabBar(
          indicatorPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          labelPadding: EdgeInsets.symmetric(horizontal: 12.w),
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Category Breakdown'),
            Tab(text: 'Expense Pie'),
            Tab(text: 'Income vs Expense'),
            Tab(text: 'Trend Line'),
          ],
        ),
        Expanded(
          child: IndexedStack(
            index: _currentTabIndex,
            children: [
              // Tab 0: Category Pie Chart
              _buildChartSection(
                child: SingleChildScrollView(
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
                            title: 'Expense Categories',
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                      if (incomeCategoryData.isNotEmpty) ...[
                        SizedBox(
                          height: 300.h,
                          child: CategoryDonutChart(
                            categoryData: incomeCategoryData,
                            title: 'Income Categories',
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ],
                  ),
                ),
              ),

              // Tab 1: Expense Pie Chart (fl_chart)
              _buildChartSection(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        'Expense Distribution',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ExpensePieChart(categoryData: expenseCategoryData),
                      SizedBox(height: 16.h),
                      if (expenseCategoryData.isNotEmpty)
                        ChartLegendWidget(categoryData: expenseCategoryData),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
              // Tab 2: Income vs Expense Bar Chart (fl_chart)
              _buildChartSection(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        'Monthly Income vs Expense',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      IncomeExpenseBarChart(
                        incomeData: monthlyIncome,
                        expenseData: monthlyExpense,
                        labels: monthLabels,
                      ),
                      SizedBox(height: 16.h),
                      _buildLegendRow(),
                    ],
                  ),
                ),
              ),

              // Tab 3: Trend Line Chart (Syncfusion)
              _buildChartSection(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Trend Analysis',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: TrendLineChart(
                          incomeData: incomeChartData,
                          expenseData: expenseChartData,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection({required Widget child}) {
    return Container(padding: EdgeInsets.zero, child: child);
  }

  Widget _buildLegendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Income', Colors.green),
        SizedBox(width: 24.w),
        _buildLegendItem('Expense', Colors.red),
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
