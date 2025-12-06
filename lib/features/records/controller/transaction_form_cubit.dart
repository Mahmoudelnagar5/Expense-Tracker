import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helper/database/sqlite_helper.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/transaction_model.dart';
import 'transaction_form_state.dart';

class TransactionFormCubit extends Cubit<TransactionFormState> {
  final SQLiteHelper _dbHelper;

  TransactionFormCubit({
    required CategoryModel category,
    TransactionModel? transaction,
    SQLiteHelper? dbHelper,
  }) : _dbHelper = dbHelper ?? SQLiteHelper(),
       super(
         TransactionFormState(
           selectedDate: transaction?.dateTime ?? DateTime.now(),
           selectedPaymentType: transaction?.paymentType ?? 'Cash',
           amount: transaction?.amount.toStringAsFixed(0) ?? '',
           notes: transaction?.notes ?? '',
           attachmentImages: transaction?.attachmentImages ?? [],
           category: category,
           existingTransaction: transaction,
         ),
       );

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setPaymentType(String paymentType) {
    emit(state.copyWith(selectedPaymentType: paymentType));
  }

  void setAmount(String amount) {
    emit(state.copyWith(amount: amount));
  }

  void setNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  void addImage(String imagePath) {
    final updatedImages = List<String>.from(state.attachmentImages)
      ..add(imagePath);
    emit(state.copyWith(attachmentImages: updatedImages));
  }

  void removeImage(int index) {
    final updatedImages = List<String>.from(state.attachmentImages)
      ..removeAt(index);
    emit(state.copyWith(attachmentImages: updatedImages));
  }

  Future<bool> submitTransaction() async {
    // Validate amount
    if (state.amount.isEmpty) {
      emit(
        state.copyWith(
          status: TransactionFormStatus.failure,
          errorMessage: 'الرجاء إدخال المبلغ',
        ),
      );
      return false;
    }

    emit(state.copyWith(status: TransactionFormStatus.submitting));

    try {
      final transactionData = TransactionModel(
        id: state.existingTransaction?.id,
        categoryModel: state.category,
        dateTime: state.selectedDate,
        amount: double.parse(state.amount),
        notes: state.notes.isEmpty ? null : state.notes,
        paymentType: state.selectedPaymentType,
        attachmentImages: state.attachmentImages.isEmpty
            ? null
            : state.attachmentImages,
      );

      if (state.isEditMode) {
        await _dbHelper.updateTransaction(transactionData);
      } else {
        await _dbHelper.insertTransaction(transactionData);
      }

      emit(state.copyWith(status: TransactionFormStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionFormStatus.failure,
          errorMessage: state.isEditMode
              ? 'حدث خطأ أثناء التعديل'
              : 'حدث خطأ أثناء الحفظ',
        ),
      );
      return false;
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: TransactionFormStatus.initial));
  }
}
