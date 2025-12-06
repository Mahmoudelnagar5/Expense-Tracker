import 'dart:convert';
import 'package:expense_tracker_ar/core/models/category_model.dart';

class TransactionModel {
  final int? id;
  final CategoryModel categoryModel;
  final DateTime dateTime;
  final num amount;
  final String? notes;
  final String paymentType;
  final List<String>? attachmentImages;

  TransactionModel({
    this.id,
    required this.categoryModel,
    required this.dateTime,
    required this.amount,
    this.notes,
    this.paymentType = 'Cash',
    this.attachmentImages,
  });

  // Convert TransactionModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryModel.name,
      'categoryType': categoryModel.type.toString().split('.').last,
      'dateTime': dateTime.toIso8601String(),
      'amount': amount,
      'notes': notes,
      'paymentType': paymentType,
      'attachmentImages': attachmentImages != null
          ? jsonEncode(attachmentImages)
          : null,
    };
  }

  // Create TransactionModel from Map
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    // Find the category from the predefined lists
    CategoryModel? category;
    final categoryType = map['categoryType'] == 'income'
        ? CategoryType.income
        : CategoryType.expense;

    final categoryName = map['categoryName'] as String;

    if (categoryType == CategoryType.income) {
      category = IncomeCategories.categories.firstWhere(
        (cat) => cat.name == categoryName,
        orElse: () => IncomeCategories.categories.first,
      );
    } else {
      category = ExpenseCategories.categories.firstWhere(
        (cat) => cat.name == categoryName,
        orElse: () => ExpenseCategories.categories.first,
      );
    }

    return TransactionModel(
      id: map['id'] as int?,
      categoryModel: category,
      dateTime: DateTime.parse(map['dateTime'] as String),
      amount: map['amount'] as num,
      notes: map['notes'] as String?,
      paymentType: map['paymentType'] as String? ?? 'Cash',
      attachmentImages: map['attachmentImages'] != null
          ? List<String>.from(jsonDecode(map['attachmentImages'] as String))
          : null,
    );
  }

  // Convert to JSON
  String toJson() => jsonEncode(toMap());

  // Create from JSON
  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  // CopyWith method for creating modified copies
  TransactionModel copyWith({
    int? id,
    CategoryModel? categoryModel,
    DateTime? dateTime,
    num? amount,
    String? notes,
    String? paymentType,
    List<String>? attachmentImages,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      categoryModel: categoryModel ?? this.categoryModel,
      dateTime: dateTime ?? this.dateTime,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      paymentType: paymentType ?? this.paymentType,
      attachmentImages: attachmentImages ?? this.attachmentImages,
    );
  }
}
