import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/category_model.dart';
import '../../controller/record_cubit.dart';
import 'bottom_sheet_header.dart';
import 'category_tab_bar.dart';
import 'category_grid.dart';
import 'transaction_form_widget.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  final RecordCubit? recordCubit;

  const AddTransactionBottomSheet({super.key, this.recordCubit});

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  int? _selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      // Reset selected category when switching tabs
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedCategoryIndex = null;
        });
      }
    });

    // Setup animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int index, CategoryModel category) async {
    setState(() {
      _selectedCategoryIndex = index;
    });

    // Show transaction form
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFormWidget(
        category: category,
        recordCubit: widget.recordCubit,
      ),
    );

    // If transaction was added successfully, close this bottom sheet too
    if (result == true) {
      await _closeWithAnimation();
    }
  }

  Future<void> _closeWithAnimation() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: FadeInUp(
          duration: Duration(milliseconds: 700),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // color: Theme.of(context).cardTheme.color,
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              children: [
                BottomSheetHeader(onClose: _closeWithAnimation),
                CategoryTabBar(controller: _tabController),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      CategoryGrid(
                        categories: IncomeCategories.categories,
                        selectedIndex: _selectedCategoryIndex,
                        onCategorySelected: _onCategorySelected,
                      ),
                      CategoryGrid(
                        categories: ExpenseCategories.categories,
                        selectedIndex: _selectedCategoryIndex,
                        onCategorySelected: _onCategorySelected,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
