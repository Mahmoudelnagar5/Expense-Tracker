import 'package:flutter/material.dart';

import '../../../features/records/presentation/widgets/add_transaction_bottom_sheet.dart';

void showAddTransactionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddTransactionBottomSheet(),
  );
}
