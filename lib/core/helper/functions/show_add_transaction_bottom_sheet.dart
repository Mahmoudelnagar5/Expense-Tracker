import 'package:flutter/material.dart';

import '../../../features/records/controller/record_cubit.dart';
import '../../../features/records/presentation/widgets/add_transaction_bottom_sheet.dart';

Future<bool?> showAddTransactionBottomSheet(
  BuildContext context, {
  RecordCubit? recordCubit,
}) async {
  return await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AddTransactionBottomSheet(recordCubit: recordCubit),
  );
}
