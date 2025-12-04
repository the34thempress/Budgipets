import 'package:flutter/material.dart';

class LogEntryController {
  final TextEditingController noteController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  
  String selectedType = 'Expense';
  String selectedCategory = '';

//expenses tags category
  final List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Medical', 'color': Color(0xFF720607), 'icon': Icons.healing},
    {'name': 'Car', 'color': Color(0xFF073598), 'icon': Icons.directions_car},
    {'name': 'Food', 'color': Color(0xFFC57000), 'icon': Icons.fastfood},
    {'name': 'Travel', 'color': Color(0xFF390488), 'icon': Icons.flight_takeoff},
    {'name': 'Recreation', 'color': Color(0xFFFEB65B), 'icon': Icons.sports_esports},
    {'name': 'Pets', 'color': Color(0xFFCD6082), 'icon': Icons.pets},
    {'name': 'Bills', 'color': Color.fromARGB(255, 71, 166, 114), 'icon': Icons.receipt_long},
    {'name': 'Other', 'color': Color(0xFF582901), 'icon': Icons.category},
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
