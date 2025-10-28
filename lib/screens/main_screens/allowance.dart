import 'package:flutter/material.dart';
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
                  Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    // Title text
    const Text(
      "What would you like to log?",
      style: TextStyle(
        fontFamily: "Modak",
        fontSize: 25,
        color: Color(0xFFFDE6D0),
      ),
    ),
    const SizedBox(height: 10),

    // Row with dropdown + pet
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Dropdown half width
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Container(
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
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6B3E1D)),
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
        ),

        // Pet image bigger
        Image.asset(
          "assets/images/pet.png",
          height: 80,
          fit: BoxFit.contain,
        ),
      ],
    ),
  ],
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

//amount text
                const SizedBox(height: 8),
                const Text(
                  "Amount",
                  style: TextStyle(
                    fontFamily: "Modak",
                    fontSize: 18,
                    color: Color(0xFF6B3E1D),
                  ),
                ),
                const SizedBox(height: 8),

//input amount
                  Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4D6C1),
                    border: Border.all(color: const Color(0xFF6B3E1D), width: 4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 72,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "₱",
                        style: TextStyle(
                          color: Color(0xFF6B3E1D),
                          fontSize: 20,
                          fontFamily: "PixelifySans-VariableFont_wght",
                        ),
                      ),
                      const SizedBox(width: 6),
//Editable input
                  Expanded(
                    child: TextField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontFamily: "PixelifySans-VariableFont_wght",
                        fontSize: 15,
                        color: Color(0xFF6B3E1D),
                      ),
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        hintText: "Enter Amount Spent",
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontFamily: "PixelifySans-VariableFont_wght",
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

//tags text
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

//note
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
