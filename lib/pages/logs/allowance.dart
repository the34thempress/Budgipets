import 'package:flutter/material.dart';
import 'package:budgipets/controllers/allowance_page_controller.dart';
import 'package:budgipets/widgets/category_grid.dart';
import 'package:budgipets/widgets/note_input.dart';
import 'package:budgipets/widgets/log_button.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budgipets/widgets/reward_popup.dart'; // Add this line

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

  Future<bool> _isFirstLogToday(SupabaseClient supabase, String userId) async {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  final logs = await supabase
      .from('spend_logs')
      .select('id')
      .eq('user_id', userId)
      .gte('occurred_at', startOfDay.toIso8601String())
      .lt('occurred_at', endOfDay.toIso8601String())
      .limit(1);

  return logs.isEmpty;
}

Future<int> _getCurrentStreak(SupabaseClient supabase, String userId) async {
  // Get all logs ordered by date
  final logs = await supabase
      .from('spend_logs')
      .select('occurred_at')
      .eq('user_id', userId)
      .order('occurred_at', ascending: false);

  if (logs.isEmpty) return 1; // First log ever

  int streak = 0;
  DateTime checkDate = DateTime.now();
  
  for (var i = 0; i < logs.length; i++) {
    final logDate = DateTime.parse(logs[i]['occurred_at'] as String);
    final logDay = DateTime(logDate.year, logDate.month, logDate.day);
    final checkDay = DateTime(checkDate.year, checkDate.month, checkDate.day);
    
    if (logDay == checkDay) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else if (logDay.isBefore(checkDay)) {
      // Check if we skipped a day
      final dayDiff = checkDay.difference(logDay).inDays;
      if (dayDiff > 1) break; // Streak broken
      streak++;
      checkDate = logDay.subtract(const Duration(days: 1));
    }
  }
  
  return streak > 0 ? streak : 1;
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

    final raw = controller.amountController.text.trim();
    final normalized = raw.replaceAll(',', '');
    final amount = double.tryParse(normalized);
    if (amount == null || amount <= 0) {
      throw Exception('Please enter a valid amount greater than 0.');
    }

    final kind = controller.selectedType;
    final isExpense = kind == 'Expense';
    
    // Check if this is the first log of the day BEFORE inserting
    final isFirstLog = await _isFirstLogToday(supabase, user.id);
    final currentStreak = isFirstLog ? await _getCurrentStreak(supabase, user.id) : 0;
    
    final category = controller.selectedCategory.isEmpty ? null : controller.selectedCategory;
    final note = controller.noteController.text.trim().isEmpty ? null : controller.noteController.text.trim();
    final label = (category ?? 'Uncategorized');

    await _ensureBudgetRowExists(supabase, user.id);

    final data = <String, dynamic>{
      'user_id': user.id,
      'label': label,
      'amount': amount,
      'occurred_at': DateTime.now().toIso8601String(),
    };

    final kindValue = controller.selectedType ?? 'Expense';
    data['kind'] = kindValue;

    if (category != null && category.isNotEmpty) {
      data['category'] = category;
    }
    if (note != null && note.isNotEmpty) {
      data['note'] = note;
    }

    await supabase.from('spend_logs').insert(data);

    final ms = _monthStart(DateTime.now());
    final monthStr = _msStr(ms);
    final budgetRow = await supabase
        .from('budgets')
        .select('balance')
        .eq('user_id', user.id)
        .eq('month_start', monthStr)
        .single();

    final currentBalance = (budgetRow['balance'] as num?) ?? 0;

    final delta = isExpense ? -amount : amount;
    final newBalance = (currentBalance as num) + delta;

    await supabase
        .from('budgets')
        .update({'balance': newBalance})
        .eq('user_id', user.id)
        .eq('month_start', monthStr);

    controller.amountController.clear();
    controller.noteController.clear();

    if (!mounted) return;

    // Show reward popup only on first log of the day
    if (isFirstLog) {
      if (isExpense) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ExpenseRewardPopup(
              streakDays: currentStreak,
              coinReward: 15,
              evolutionTokens: 50,
              amountDeducted: amount,
            );
          },
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return IncomeRewardPopup(
              streakDays: currentStreak,
              coinReward: 15,
              evolutionTokens: 50,
              amountAdded: amount,
            );
          },
        );
      }
    } else {
      // Show regular popup for subsequent logs
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color(0xFFF5E6D3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF6B4423), width: 3),
          ),
          title: const Text(
            'Success',
            style: TextStyle(
              fontFamily: 'Questrial',
              color: Color(0xFF6B4423),
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            isExpense
                ? "Logged expense and deducted ₱${amount.toStringAsFixed(2)}."
                : "Logged income and added ₱${amount.toStringAsFixed(2)}.",
            style: const TextStyle(
              fontFamily: 'Questrial',
              color: Color(0xFF6B4423),
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4423),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 16,
                ),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFF5E6D3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF6B4423), width: 3),
        ),
        title: const Text(
          'Error',
          style: TextStyle(
            fontFamily: 'Questrial',
            color: Color(0xFF6B4423),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          e.toString(),
          style: const TextStyle(
            fontFamily: 'Questrial',
            color: Color(0xFF6B4423),
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B4423),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Questrial',
                fontSize: 16,
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "What would you like to log?",
                            style: TextStyle(
                              fontFamily: "Modak",
                              fontSize: 30,
                              color: Colors.white,
                              height: 1.0, 
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                              fontFamily: "Questrial",
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
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/dog.png',
                      width: 130,
                      height: 130,
                    )
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
                        fontSize: 23,
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
                              fontFamily: "Questrial",
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: controller.amountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontFamily: "Questrial",
                                fontSize: 15,
                                color: Color(0xFF6B3E1D),
                              ),
                              textAlign: TextAlign.left,
                              decoration: const InputDecoration(
                                hintText: "Enter Amount",
                                hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontFamily: "Questrial",
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