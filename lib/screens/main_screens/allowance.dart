import 'package:flutter/material.dart';
import 'package:budgipets/controllers/allowance_page_controller.dart';
import 'package:budgipets/widgets/category_grid.dart';
import 'package:budgipets/widgets/note_input.dart';
import 'package:budgipets/widgets/log_button.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogEntryPage extends StatefulWidget {
  const LogEntryPage({super.key});

  @override
  State<LogEntryPage> createState() => _LogEntryPageState();
}

class _LogEntryPageState extends State<LogEntryPage> {
  final controller = LogEntryController();
  bool _isSubmitting = false;

  DateTime _monthStart(DateTime dt) => DateTime(dt.year, dt.month, 1);
  String _msStr(DateTime ms) =>
      '${ms.year.toString().padLeft(4, '0')}-${ms.month.toString().padLeft(2, '0')}-01';

  Future<void> _ensureBudgetRowExists(SupabaseClient supabase, String userId) async {
    final ms = _monthStart(DateTime.now());
    final monthStr = _msStr(ms);
    await supabase.from('budgets').upsert(
      {'user_id': userId, 'month_start': monthStr},
      onConflict: 'user_id,month_start',
    );
  }

  Future<void> _submitLog() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('You are not signed in.');
      }

      // Parse amount
      final raw = controller.amountController.text.trim();
      final normalized = raw.replaceAll(',', '');
      final amount = double.tryParse(normalized);
      if (amount == null || amount <= 0) {
        throw Exception('Please enter a valid amount greater than 0.');
      }

      final kind = controller.selectedType; // 'Expense' | 'Income'
      final isExpense = kind == 'Expense';
      final category =
          controller.selectedCategory.isEmpty ? null : controller.selectedCategory;
      final note =
          controller.noteController.text.trim().isEmpty ? null : controller.noteController.text.trim();
      final label = (category ?? 'Uncategorized');

      // Ensure this month's budget row exists
      await _ensureBudgetRowExists(supabase, user.id);

      // INSERT into the correct table: public.spend_logs
      await supabase.from('spend_logs').insert({
        'user_id': user.id,
        'label': label,
        'amount': amount,
        'kind': kind,          // 'Expense' or 'Income'
        'category': category,  // nullable
        'note': note,          // nullable
        'occurred_at': DateTime.now().toIso8601String(),
      });

      // Read current balance for this month
      final ms = _monthStart(DateTime.now());
      final monthStr = _msStr(ms);
      final budgetRow = await supabase
          .from('budgets')
          .select('balance')
          .eq('user_id', user.id)
          .eq('month_start', monthStr)
          .single();

      final currentBalance = (budgetRow['balance'] as num?) ?? 0;

      // Apply delta: Expense -> deduct; Income -> add
      final delta = isExpense ? -amount : amount;
      final newBalance = (currentBalance as num) + delta;

      // Update balance
      await supabase
          .from('budgets')
          .update({'balance': newBalance})
          .eq('user_id', user.id)
          .eq('month_start', monthStr);

      // Clear inputs (keep type/category for speed)
      controller.amountController.clear();
      controller.noteController.clear();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Success",
            style: TextStyle(fontFamily: "Modak", color: Color(0xFF6B3E1D)),
          ),
          content: Text(
            isExpense
                ? "Logged expense and deducted ₱${amount.toStringAsFixed(2)}."
                : "Logged income and added ₱${amount.toStringAsFixed(2)}.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Color(0xFF6B3E1D))),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Error",
            style: TextStyle(fontFamily: "Modak", color: Color(0xFF6B3E1D)),
          ),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Color(0xFF6B3E1D))),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

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
                        const Text(
                          "What would you like to log?",
                          style: TextStyle(
                            fontFamily: "Modak",
                            fontSize: 25,
                            color: Color(0xFFFDE6D0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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

              // Main
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                hintText: "Enter Amount",
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

                    const Text(
                      "Tags",
                      style: TextStyle(
                        fontFamily: "Modak",
                        fontSize: 18,
                        color: Color(0xFF6B3E1D),
                      ),
                    ),
                    const SizedBox(height: 8),

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

                    NoteInput(controller: controller.noteController),
                    const SizedBox(height: 20),

                    Center(
                      child: LogButton(
                        // Always pass a non-null callback; guard inside
                        onPressed: () {
                          if (_isSubmitting) return;
                          _submitLog();
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
