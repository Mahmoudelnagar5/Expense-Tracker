import '../../../core/helper/enums/date_filter_type.dart';
import '../../../core/helper/enums/record_status.dart';
import '../../../core/models/transaction_model.dart';

class RecordState {
  final List<TransactionModel> transactions;
  final DateTime selectedDate;
  final DateFilterType filterType;
  final double totalIncome;
  final double totalExpense;
  final RecordStatus status;
  final String? errorMessage;

  const RecordState({
    this.transactions = const [],
    required this.selectedDate,
    this.filterType = DateFilterType.day,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.status = RecordStatus.initial,
    this.errorMessage,
  });

  double get totalBalance => totalIncome - totalExpense;

  bool get isLoading => status == RecordStatus.loading;

  RecordState copyWith({
    List<TransactionModel>? transactions,
    DateTime? selectedDate,
    DateFilterType? filterType,
    double? totalIncome,
    double? totalExpense,
    RecordStatus? status,
    String? errorMessage,
  }) {
    return RecordState(
      transactions: transactions ?? this.transactions,
      selectedDate: selectedDate ?? this.selectedDate,
      filterType: filterType ?? this.filterType,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
