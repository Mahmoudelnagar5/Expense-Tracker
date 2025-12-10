import 'package:flutter/material.dart';

enum CategoryType { income, expense }

class CategoryModel {
  final String name;
  final IconData icon;
  final CategoryType type;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.type,
  });
}

// Income Categories
class IncomeCategories {
  static const List<CategoryModel> categories = [
    CategoryModel(
      name: 'Bonus',
      icon: Icons.currency_bitcoin,
      type: CategoryType.income,
    ),
    CategoryModel(
      name: 'Investments',
      icon: Icons.account_balance_wallet_outlined,
      type: CategoryType.income,
    ),
    CategoryModel(
      name: 'Part-Time',
      icon: Icons.currency_rupee,
      type: CategoryType.income,
    ),
    CategoryModel(
      name: 'Salary',
      icon: Icons.credit_card,
      type: CategoryType.income,
    ),
    CategoryModel(
      name: 'Pocket Money',
      icon: Icons.wallet,
      type: CategoryType.income,
    ),
    CategoryModel(
      name: 'Lottery',
      icon: Icons.casino_outlined,
      type: CategoryType.income,
    ),
    CategoryModel(
      name: 'Other',
      icon: Icons.category_outlined,
      type: CategoryType.income,
    ),
  ];
}

// Expense Categories
class ExpenseCategories {
  static const List<CategoryModel> categories = [
    CategoryModel(
      name: 'Entertainment',
      icon: Icons.theater_comedy_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Phone',
      icon: Icons.phone_android,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Restaurants',
      icon: Icons.restaurant_menu,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Shopping',
      icon: Icons.shopping_cart_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Social',
      icon: Icons.group_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Sports',
      icon: Icons.sports_basketball,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Beauty',
      icon: Icons.face_retouching_natural,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Education',
      icon: Icons.school_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Groceries',
      icon: Icons.shopping_basket_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Car',
      icon: Icons.directions_car_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Clothing',
      icon: Icons.checkroom_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Transportation',
      icon: Icons.local_shipping_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Health',
      icon: Icons.medical_services_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Travel',
      icon: Icons.flight_takeoff,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Electronics',
      icon: Icons.devices_other,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Bills',
      icon: Icons.receipt_long,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Home',
      icon: Icons.home_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Housing',
      icon: Icons.house_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Repairs',
      icon: Icons.build_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(name: 'Pets', icon: Icons.pets, type: CategoryType.expense),
    CategoryModel(
      name: 'Snacks',
      icon: Icons.fastfood_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Gym',
      icon: Icons.fitness_center,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Donations',
      icon: Icons.water_drop_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Gifts',
      icon: Icons.card_giftcard,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Fuel',
      icon: Icons.local_gas_station,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Fruits',
      icon: Icons.apple,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Vegetable',
      icon: Icons.eco_outlined,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Kids',
      icon: Icons.child_care,
      type: CategoryType.expense,
    ),
    CategoryModel(
      name: 'Other',
      icon: Icons.category_outlined,
      type: CategoryType.expense,
    ),
  ];
}
