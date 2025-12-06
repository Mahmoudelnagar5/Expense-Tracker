import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/functions/show_add_transaction_bottom_sheet.dart';
import '../../controller/record_cubit.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import '../../../reports/presentation/screens/reports_screen.dart';
import 'record_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  late RecordCubit _recordCubit;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _recordCubit = RecordCubit()..loadTransactions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _recordCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _recordCubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: HomeAppBar(),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [const RecordScreen(), const ReportsScreen()],
        ),
        bottomNavigationBar: BottomNavBarWidget(
          currentIndex: _currentIndex,
          onAddPressed: _handleAddTransaction,
          onItemTapped: _onItemTapped,
        ),
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

  void _handleAddTransaction() async {
    await showAddTransactionBottomSheet(context, recordCubit: _recordCubit);
  }
}
