import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:budgipets/controllers/allowance_page_controller.dart';
import 'package:budgipets/widgets/category_grid.dart';
import 'package:budgipets/widgets/note_input.dart';
import 'package:budgipets/widgets/log_button.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';

class LogEntryPage extends StatefulWidget
{
  const LogEntryPage({super.key});

  @override
  State<LogEntryPage> createState() => _LogEntryPageState();
}

class _LogEntryPageState extends State<LogEntryPage>
{
  final controller = LogEntryController();

  @override
  Widget build(BuildContext context) {
    final categories = controller.getDisplayedCategories();

    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonHeader(
              goToDashboard: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "What would you like to log?",
                        style: TextStyle(
                          fontFamily: "Modak",
                          fontSize: 20,
                          color: Color(0xFFFDE6D0),
                        ),
                      ),
                      Image.asset("assets/images/pet.png", height: 60),
                    ],
                  ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE6D0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        value: controller.selectedType,
                        dropdownColor: const Color(0xFFFDE6D0),
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Color(0xFF6B3E1D)),
                        items: ['Expense', 'Income']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type,
                                    style: const TextStyle(
                                      color: Color(0xFF6B3E1D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            controller.selectedType = value!;
                            controller.selectedCategory = '';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

//Main
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const Text(
                      "Tags",
                      style: TextStyle(
                        fontFamily: "Modak",
                        fontSize: 18,
                        color: Color(0xFF6B3E1D),
                      ),
                    ),
                    const SizedBox(height: 8),

//tags/category
                    CategoryGrid(
                      categories: categories,
                      selectedCategory: controller.selectedCategory,
                      onSelect: (cat) {
                        setState(() => controller.selectedCategory = cat);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Note",
                      style: TextStyle(
                        fontFamily: "Modak",
                        fontSize: 18,
                        color: Color(0xFF6B3E1D),
                      ),
                    ),
                    const SizedBox(height: 8),

//calls the widget
                    NoteInput(controller: controller.noteController),
                    const SizedBox(height: 20),
                    Center(

//log button
//calls the wideget
                      child: LogButton(
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
                              content: const Text(
                                  "Your log has been saved successfully."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(color: Color(0xFF6B3E1D)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
