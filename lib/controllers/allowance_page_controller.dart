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
    {'name': 'Recreation', 'color': Color.fromARGB(255, 239, 169, 84), 'icon': Icons.sports_esports},
    {'name': 'Pets', 'color': Color(0xFFCD6082), 'icon': Icons.pets},
    {'name': 'Bills', 'color': Color.fromARGB(255, 65, 152, 104), 'icon': Icons.receipt_long},
    {'name': 'Other', 'color': Color(0xFF582901), 'icon': Icons.category},
  ];

//income tags category
  final List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Salary', 'color': const Color.fromARGB(255, 67, 156, 70), 'icon': Icons.attach_money},
    {'name': 'Loan', 'color': const Color.fromARGB(255, 1, 123, 111), 'icon': Icons.handshake},
    {'name': 'Sold Item', 'color': const Color.fromARGB(255, 22, 105, 173), 'icon': Icons.shopping_bag},
    {'name': 'Donation', 'color': const Color.fromARGB(255, 121, 31, 137), 'icon': Icons.volunteer_activism},
    {'name': 'Other', 'color': const Color.fromARGB(255, 86, 59, 49), 'icon': Icons.category},
  ];

  List<Map<String, dynamic>> getDisplayedCategories() {
    return selectedType == 'Expense' ? expenseCategories : incomeCategories;
  }
}
