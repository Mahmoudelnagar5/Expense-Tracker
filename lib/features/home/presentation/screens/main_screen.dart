import 'package:expense_tracker_ar/core/helper/functions/toast_helper.dart';
import 'package:expense_tracker_ar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import 'reports_screen.dart';
import 'record_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: HomeAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [ReportsScreen(), RecordScreen()],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _currentIndex,
        onAddPressed: _handleAddTransaction,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleAddTransaction() {
    // TODO: Navigate to add transaction screen
    ToastHelper.showSuccess(context, message: 'تم إضافة معاملة جديدة');
  }
}
