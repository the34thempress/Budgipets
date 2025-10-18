import 'package:flutter/material.dart';

class LogEntryController {
  final TextEditingController noteController = TextEditingController();
  String selectedType = 'Expense';
  String selectedCategory = '';

//expenses tags category
  final List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Medical', 'color': Colors.red, 'icon': Icons.healing},
    {'name': 'Car', 'color': Colors.blue, 'icon': Icons.directions_car},
    {'name': 'Food', 'color': Colors.orange, 'icon': Icons.fastfood},
    {'name': 'Travel', 'color': Colors.purple, 'icon': Icons.flight_takeoff},
    {'name': 'Recreation', 'color': Colors.amber, 'icon': Icons.sports_esports},
    {'name': 'Pets', 'color': Colors.pink, 'icon': Icons.pets},
    {'name': 'Bills', 'color': Colors.green, 'icon': Icons.receipt_long},
    {'name': 'Other', 'color': Colors.brown, 'icon': Icons.category},
  ];

//income tags category
  final List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Salary', 'color': Colors.green, 'icon': Icons.attach_money},
    {'name': 'Loan', 'color': Colors.teal, 'icon': Icons.handshake},
    {'name': 'Sold Item', 'color': Colors.blue, 'icon': Icons.shopping_bag},
    {'name': 'Donation', 'color': Colors.purple, 'icon': Icons.volunteer_activism},
    {'name': 'Other', 'color': Colors.brown, 'icon': Icons.category},
  ];

  List<Map<String, dynamic>> getDisplayedCategories() {
    return selectedType == 'Expense' ? expenseCategories : incomeCategories;
  }
}
