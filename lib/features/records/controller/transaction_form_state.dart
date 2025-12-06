import '../../../core/models/category_model.dart';
import '../../../core/models/transaction_model.dart';

enum TransactionFormStatus { initial, submitting, success, failure }

class TransactionFormState {
  final DateTime selectedDate;
  final String selectedPaymentType;
  final String amount;
  final String notes;
  final List<String> attachmentImages;
  final TransactionFormStatus status;
  final String? errorMessage;
  final CategoryModel category;
  final TransactionModel? existingTransaction;

  const TransactionFormState({
    required this.selectedDate,
    this.selectedPaymentType = 'Cash',
    this.amount = '',
    this.notes = '',
    this.attachmentImages = const [],
    this.status = TransactionFormStatus.initial,
    this.errorMessage,
    required this.category,
    this.existingTransaction,
  });

  bool get isEditMode => existingTransaction != null;

  bool get isSubmitting => status == TransactionFormStatus.submitting;

  bool get isSuccess => status == TransactionFormStatus.success;

  TransactionFormState copyWith({
    DateTime? selectedDate,
    String? selectedPaymentType,
    String? amount,
    String? notes,
    List<String>? attachmentImages,
    TransactionFormStatus? status,
    String? errorMessage,
    CategoryModel? category,
    TransactionModel? existingTransaction,
  }) {
    return TransactionFormState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      attachmentImages: attachmentImages ?? this.attachmentImages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      category: category ?? this.category,
      existingTransaction: existingTransaction ?? this.existingTransaction,
    );
  }
}
