import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/functions/show_add_transaction_bottom_sheet.dart';
import '../../../../core/helper/enums/record_status.dart';
import '../../controller/record_cubit.dart';
import '../../controller/record_state.dart';
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
  int _currentIndex = 0;
  late RecordCubit _recordCubit;
  late PageController _pageController;
  final ValueNotifier<bool> _refreshReportsNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _recordCubit = RecordCubit()..loadTransactions();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshReportsNotifier.dispose();
    _recordCubit.close();
    super.dispose();
  }

  void _triggerRefresh() {
    if (mounted) {
      _refreshReportsNotifier.value = !_refreshReportsNotifier.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _recordCubit,
      child: BlocListener<RecordCubit, RecordState>(
        listener: (context, state) {
          debugPrint('RecordState changed: ${state.status}');
          // Auto-refresh reports when transactions change
          if (state.status == RecordStatus.success) {
            _triggerRefresh();
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: HomeAppBar(),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              const RecordScreen(),
              ReportsScreen(refreshNotifier: _refreshReportsNotifier),
            ],
          ),
          bottomNavigationBar: BottomNavBarWidget(
            currentIndex: _currentIndex,
            onAddPressed: _handleAddTransaction,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
