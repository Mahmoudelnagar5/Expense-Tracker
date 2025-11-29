import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../features/records/presentation/widgets/add_transaction_bottom_sheet.dart';

void showAddTransactionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: const AddTransactionBottomSheet(),
    ),
  );
}
