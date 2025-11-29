import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/category_model.dart';
import 'bottom_sheet_header.dart';
import 'category_tab_bar.dart';
import 'category_grid.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int index, CategoryModel category) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    // TODO: Handle category selection - could navigate to add transaction form
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          const BottomSheetHeader(),
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
    );
  }
}
