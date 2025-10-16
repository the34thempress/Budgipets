import 'package:flutter/material.dart';
import 'dashboard.dart';

class LogEntryPage extends StatefulWidget {
  const LogEntryPage({super.key});

  @override
  State<LogEntryPage> createState() => _LogEntryPageState();
}

class _LogEntryPageState extends State<LogEntryPage> {
  String selectedType = 'Expense';
  String selectedCategory = '';
  final TextEditingController _noteController = TextEditingController();

//for categories color later
  // Expense categories
final List<Map<String, dynamic>> expenseCategories = [
  {'name': 'Medical', 'color': Colors.red.shade700, 'icon': Icons.healing},
  {'name': 'Car', 'color': Colors.blue.shade700, 'icon': Icons.directions_car},
  {'name': 'Food', 'color': Colors.orange.shade700, 'icon': Icons.fastfood},
  {'name': 'Travel', 'color': Colors.purple.shade700, 'icon': Icons.flight_takeoff},
  {'name': 'Recreation', 'color': Colors.amber.shade400, 'icon': Icons.sports_esports},
  {'name': 'Pets', 'color': Colors.pink.shade300, 'icon': Icons.pets},
  {'name': 'Bills', 'color': Colors.green.shade600, 'icon': Icons.receipt_long},
  {'name': 'Other', 'color': Colors.brown.shade700, 'icon': Icons.category},
];

// Income categories
final List<Map<String, dynamic>> incomeCategories = [
  {'name': 'Salary', 'color': Colors.green.shade700, 'icon': Icons.attach_money},
  {'name': 'Loan', 'color': Colors.teal.shade600, 'icon': Icons.handshake},
  {'name': 'Sold Item', 'color': Colors.blue.shade600, 'icon': Icons.shopping_bag},
  {'name': 'Donation', 'color': Colors.purple.shade600, 'icon': Icons.volunteer_activism},
  {'name': 'Other', 'color': Colors.brown.shade700, 'icon': Icons.category},
];


  @override
Widget build(BuildContext context) {
  final displayedCategories = selectedType == 'Expense'
      ? expenseCategories
      : incomeCategories;

  return Scaffold(
    backgroundColor: const Color(0xFFF4D6C1),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

// back button to dashboard.dart
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color(0xFF6B3E1D)),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                    );
                  },
                ),
                const SizedBox(height: 8),

// header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "What would you like to log?",
                      style: TextStyle(
                        fontFamily: "Modak",
                        fontSize: 20,
                        color: Color(0xFF6B3E1D),
                      ),
                    ),
                    Image.asset(
                      "assets/images/pet.png",
                      height: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

//Dropdown for expense/income
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B3E1D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    value: selectedType,
                    dropdownColor: const Color(0xFF6B3E1D),
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: ['Expense', 'Income']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(()
                      {
                      selectedType = value!;
                      selectedCategory = '';
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

//hard coded amount
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B3E1D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "₱349.00",
                    style: TextStyle(
                      fontFamily: "PixelifySans-VariableFont_wght",
                      fontSize: 28,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

//Different categories
              const Text(
                "Category",
                style: TextStyle(
                  fontFamily: "Modak",
                  fontSize: 18,
                  color: Color(0xFF6B3E1D),
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: displayedCategories.map((cat) {
                  final isSelected = selectedCategory == cat['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedCategory = cat['name']);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cat['color'].withOpacity(0.8)
                            : cat['color'],
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat['icon'], color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            cat['name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

                const SizedBox(height: 20),

//optional note
                const Text(
                  "Note",
                  style: TextStyle(
                    fontFamily: "Modak",
                    fontSize: 18,
                    color: Color(0xFF6B3E1D),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: "Optional",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

// the log button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B3E1D),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: const Text(
                            "Success",
                            style: TextStyle(
                              fontFamily: "Modak",
                              color: Color(0xFF6B3E1D),
                            ),
                          ),
                          content: const Text("Your log has been saved successfully."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DashboardPage()),
                                );
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Color(0xFF6B3E1D)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Log",
                      style: TextStyle(
                        fontFamily: "Modak",
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
