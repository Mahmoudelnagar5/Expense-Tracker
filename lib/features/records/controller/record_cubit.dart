import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helper/database/sqlite_helper.dart';
import '../../../core/helper/enums/date_filter_type.dart';
import '../../../core/helper/enums/record_status.dart';
import 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  final SQLiteHelper _dbHelper;

  RecordCubit({SQLiteHelper? dbHelper})
    : _dbHelper = dbHelper ?? SQLiteHelper(),
      super(RecordState(selectedDate: DateTime.now()));

  Future<void> loadTransactions() async {
    // Prevent duplicate loading
    if (state.status == RecordStatus.loading) return;
    
    emit(state.copyWith(status: RecordStatus.loading));

    try {
      final dateRange = _calculateDateRange();
      final startDate = dateRange['startDate']!;
      final endDate = dateRange['endDate']!;

      // Run database queries in parallel for better performance
      final results = await Future.wait([
        _dbHelper.getTransactionsByDateRange(startDate, endDate),
        _dbHelper.getTotalIncome(startDate, endDate),
        _dbHelper.getTotalExpenses(startDate, endDate),
      ]);

      final transactions = results[0] as List<dynamic>;
      final income = results[1] as double;
      final expense = results[2] as double;

      emit(
        state.copyWith(
          transactions: transactions.cast(),
          totalIncome: income,
          totalExpense: expense,
          status: RecordStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecordStatus.failure,
          errorMessage: 'حدث خطأ أثناء تحميل البيانات',
        ),
      );
    }
  }

  Map<String, DateTime> _calculateDateRange() {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (state.filterType) {
      case DateFilterType.day:
        startDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          state.selectedDate.day,
        );
        endDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          state.selectedDate.day,
          23,
          59,
          59,
        );
        break;
      case DateFilterType.month:
        startDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          1,
        );
        if (state.selectedDate.year == now.year &&
            state.selectedDate.month == now.month) {
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        } else {
          endDate = DateTime(
            state.selectedDate.year,
            state.selectedDate.month + 1,
            0,
            23,
            59,
            59,
          );
        }
        break;
      case DateFilterType.year:
        startDate = DateTime(state.selectedDate.year, 1, 1);
        if (state.selectedDate.year == now.year) {
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        } else {
          endDate = DateTime(state.selectedDate.year, 12, 31, 23, 59, 59);
        }
        break;
    }

    return {'startDate': startDate, 'endDate': endDate};
  }

  void goToPreviousDate() {
    DateTime newDate;
    switch (state.filterType) {
      case DateFilterType.day:
        newDate = state.selectedDate.subtract(const Duration(days: 1));
        break;
      case DateFilterType.month:
        newDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month - 1,
        );
        break;
      case DateFilterType.year:
        newDate = DateTime(state.selectedDate.year - 1);
        break;
    }
    emit(state.copyWith(selectedDate: newDate));
    loadTransactions();
  }

  void goToNextDate() {
    DateTime newDate;
    switch (state.filterType) {
      case DateFilterType.day:
        newDate = state.selectedDate.add(const Duration(days: 1));
        break;
      case DateFilterType.month:
        newDate = DateTime(
          state.selectedDate.year,
          state.selectedDate.month + 1,
        );
        break;
      case DateFilterType.year:
        newDate = DateTime(state.selectedDate.year + 1);
        break;
    }
    emit(state.copyWith(selectedDate: newDate));
    loadTransactions();
  }

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    loadTransactions();
  }

  void setFilterType(DateFilterType filterType) {
    emit(state.copyWith(filterType: filterType, selectedDate: DateTime.now()));
    loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _dbHelper.deleteTransaction(id);
      await loadTransactions();
    } catch (e) {
      emit(
        state.copyWith(
          status: RecordStatus.failure,
          errorMessage: 'حدث خطأ أثناء حذف المعاملة',
        ),
      );
    }
  }

  void refreshTransactions() {
    loadTransactions();
  }
}
