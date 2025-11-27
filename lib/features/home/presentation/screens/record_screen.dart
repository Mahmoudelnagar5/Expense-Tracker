import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/date_selector_widget.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/empty_state_widget.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  String currentDate = '25 نوفمبر، 2025';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date Selector
        DateSelectorWidget(
          dateText: currentDate,
          onPreviousDate: _handlePreviousDate,
          onNextDate: _handleNextDate,
          onFilterPressed: _handleFilterPressed,
        ),

        // Divider
        _buildDivider(),

        // Summary Card
        SummaryCardWidget(
          incomeAmount: '0',
          expenseAmount: '0',
          totalAmount: '0',
          currency: 'EE',
        ),

        // Divider
        _buildDivider(),

        // Empty State or Transaction List
        const Expanded(child: EmptyStateWidget(message: 'لا يوجد بيانات')),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 1.h, color: Colors.grey[300]);
  }

  void _handlePreviousDate() {
    // TODO: Implement date navigation
    setState(() {
      // Update date logic here
    });
  }

  void _handleNextDate() {
    // TODO: Implement date navigation
    setState(() {
      // Update date logic here
    });
  }

  void _handleFilterPressed() {
    // TODO: Implement filter functionality
  }
}
