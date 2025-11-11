import 'package:budgipets/pages/pet/pet_management.dart';
import 'package:budgipets/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:budgipets/pages/logs/allowance.dart';
import 'package:budgipets/pages/store/store.dart';
import 'package:budgipets/pages/settings/settings_page.dart';
import 'package:budgipets/pages/logs/log_history.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budgipets/pages/dashboard/set_budget_dialog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  num? _balance;
  num? _goal;
  bool _loading = true;

  bool _editingAmount = false;
  bool _dialogOpen = false;

  RealtimeChannel? _budgetChannel;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<DateTime> _streakDays = [
    DateTime(2025, 10, 10),
    DateTime(2025, 10, 11),
    DateTime(2025, 10, 13),
    DateTime(2025, 10, 14),
  ];

  final List<DateTime> _missedDays = [
    DateTime(2025, 10, 8),
    DateTime(2025, 10, 9),
    DateTime(2025, 10, 12),
  ];

  @override
  void initState() {
    super.initState();
    _loadOrCreateBudget();
  }

  @override
  void dispose() {
    _budgetChannel?.unsubscribe();
    super.dispose();
  }

  //helpers
  DateTime _monthStart(DateTime dt) => DateTime(dt.year, dt.month, 1);

  Future<void> _loadOrCreateBudget() async {
    final supabase = Supabase.instance.client;
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _balance = 0;
          _goal = 0;
        });
        return;
      }

      debugPrint('Dashboard: userId=${user.id}');

      final ms = _monthStart(DateTime.now());
      final msStr =
          '${ms.year.toString().padLeft(4, '0')}-${ms.month.toString().padLeft(2, '0')}-01';

      final existing = await supabase
          .from('budgets')
          .select()
          .eq('user_id', user.id)
          .eq('month_start', msStr)
          .maybeSingle();

      if (!mounted) return;

      if (existing != null) {
        setState(() {
          _balance = (existing['balance'] as num?) ?? 0;
          _goal = (existing['goal'] as num?) ?? 0;
          _loading = false;
        });
      } else {
        final inserted = await supabase
            .from('budgets')
            .insert({
              'user_id': user.id,
              'month_start': msStr,
              'balance': 0,
              'goal': 0,
            })
            .select()
            .single();

        if (!mounted) return;
        setState(() {
          _balance = (inserted['balance'] as num?) ?? 0;
          _goal = (inserted['goal'] as num?) ?? 0;
          _loading = false;
        });
      }
    } catch (e, st) {
      debugPrint('Dashboard load error: $e\n$st');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _balance = 0;
        _goal = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load budget. Showing 0.')),
      );
    }
  }

  Future<num?> _promptNumber({
    required String title,
    required num initial,
  }) async {
    if (_dialogOpen) return null;
    if (!mounted) return null;

    _dialogOpen = true;
    final stable = context;
    final controller = TextEditingController(text: initial.toStringAsFixed(2));

    num? result;
    try {
      result = await showDialog<num>(
        context: stable,
        useRootNavigator: true,
        barrierDismissible: true,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(title, style: const TextStyle(fontFamily: "Modak")),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "e.g. 2000.00"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(stable, rootNavigator: true).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  final raw = controller.text.trim().replaceAll(',', '');
                  final v = double.tryParse(raw);
                  if (v == null || v < 0) return;
                  Navigator.of(stable, rootNavigator: true).pop(v);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('promptNumber dialog error: $e');
      result = null;
    } finally {
      _dialogOpen = false;
    }

    return result;
  }

  Future<void> _updateBudgetField(String field, num value) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final ms = _monthStart(DateTime.now());
    final msStr =
        '${ms.year.toString().padLeft(4, '0')}-${ms.month.toString().padLeft(2, '0')}-01';

    try {
      await supabase.from('budgets').upsert({
        'user_id': user.id,
        'month_start': msStr,
      }, onConflict: 'user_id,month_start');

      await supabase
          .from('budgets')
          .update({field: value})
          .eq('user_id', user.id)
          .eq('month_start', msStr);

      if (!mounted) return;
      setState(() {
        if (field == 'balance') _balance = value;
        if (field == 'goal') _goal = value;
      });
    } catch (e) {
      debugPrint('Update $field failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update $field')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFADEC6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Header
              Container(
                color: const Color(0xFF5C2E14),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Hello, Jarod!",
                      style: TextStyle(
                        fontFamily: "Modak",
                        fontSize: 45,
                        color: Color(0xFFFADEC6),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfilePage()),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () async {
                  if (_editingAmount || _dialogOpen) return;
                  if (!mounted) return;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LogEntryPage()),
                  );
                  if (!mounted) return;
                  await _loadOrCreateBudget();
                },

                child: Container(
                  color: const Color(0xFFFADEC6),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Balance:",
                        style: TextStyle(
                          fontFamily: "Questrial",
                          fontSize: 25,
                          color: Color(0xFF2C1400),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          if (_loading || _dialogOpen) return;
                          _editingAmount = true;
                          await showDialog(
                          context: context,
                          builder: (_) {
                            return SetBudgetDialog(
                              currentBudget: _balance ?? 0,
                              onSave: (newBudget, password) async {
                                final user = Supabase.instance.client.auth.currentUser;
                                if (user == null) throw Exception("Not logged in");

                                final result = await Supabase.instance.client.auth.signInWithPassword(
                                  email: user.email!,
                                  password: password,
                                );

                                if (result.session == null) {
                                  throw Exception("Invalid password");
                                }

                                await _updateBudgetField('balance', newBudget);
                              },
                            );
                          },
                        );

                          if (mounted) setState(() {});
                          _editingAmount = false;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            _loading
                                ? "…"
                                : "₱${(_balance ?? 0).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontFamily: "Questrial",
                              fontSize: 45,
                              color: Color(0xFF2C1400),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Calendar
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                color: const Color(0xFF5C2E14),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontFamily: "Modak",
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.white),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle:
                        TextStyle(color: Colors.white, fontFamily: "Questrial"),
                    weekendStyle:
                        TextStyle(color: Colors.white, fontFamily: "Questrial"),
                  ),
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle:
                        TextStyle(color: Colors.white, fontFamily: "Questrial"),
                    weekendTextStyle:
                        TextStyle(color: Colors.white, fontFamily: "Questrial"),
                    outsideTextStyle: TextStyle(
                        color: Color(0xFFD9B896), fontFamily: "Questrial"),
                    cellMargin: EdgeInsets.all(6),
                    isTodayHighlighted: false,
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFFFFD79B),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Color(0xFF5C2E14),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Questrial",
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) {
                      final isStreak =
                          _streakDays.any((d) => isSameDay(d, day));
                      final isMissed =
                          _missedDays.any((d) => isSameDay(d, day));
                      final isToday = isSameDay(day, DateTime.now());
                      final isSelected = isSameDay(day, _selectedDay);

                      if (isSelected) return null;

                      Color? bgColor;
                      BoxBorder? border;
                      TextStyle textStyle = const TextStyle(
                        color: Colors.white,
                        fontFamily: "Questrial",
                      );

                      if (isStreak) {
                        bgColor = const Color(0xFFF4D6C1);
                        textStyle = const TextStyle(
                          color: Color(0xFF5C2E14),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Questrial",
                        );
                      } else if (isMissed) {
                        bgColor = const Color(0xFFD7B59B);
                      } else if (isToday) {
                        border = Border.all(
                            color: const Color(0xFFFFE4B3), width: 3);
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                          border: border,
                        ),
                        alignment: Alignment.center,
                        child: Text("${day.day}", style: textStyle),
                      );
                    },
                  ),
                ),
              ),

              // Goal
              Container(
                color: const Color(0xFF8C501D),
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Column(
                  children: [
                    const Text(
                      "Current Goal:",
                      style: TextStyle(
                        color: Color(0xFFFADEC6),
                        fontFamily: "Questrial",
                        fontSize: 21,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        if (_loading || _dialogOpen) return;
                        _editingAmount = true;
                        final v = await _promptNumber(
                          title: "Set Goal",
                          initial: _goal ?? 0,
                        );
                        if (v != null) {
                          if (!mounted) { _editingAmount = false; return; }
                          await _updateBudgetField('goal', v);
                        }
                        if (mounted) setState(() {});
                        _editingAmount = false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          _loading
                              ? "…"
                              : "₱${(_goal ?? 0).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontFamily: "Questrial",
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFADEC6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Streak + Pet
              Container(
                color: const Color(0xFFFADEC6),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        Text(
                          "34",
                          style: TextStyle(
                            fontFamily: "PixelifySans",
                            fontSize: 80,
                            height: 1,
                            color: Color(0xFF4A2100),
                          ),
                        ),
                        Text(
                          "DAYS",
                          style: TextStyle(
                            fontFamily: "PixelifySans",
                            fontSize: 22,
                            color: Color(0xFF4A2100),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/images/pet.png",
                      height: 130,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      //Bottom nav
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF5C2E14),
        selectedItemColor: const Color(0xFFFADEC6),
        unselectedItemColor: const Color(0xFFFADEC6),
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        onTap: (index) async {
          if (!mounted || _dialogOpen) return;
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsPage()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PetManagementPage()));
          }
          
          else if (index == 2) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogEntryPage()),
            );
            if (!mounted) return;
            await _loadOrCreateBudget();
          }

          else if (index == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const LogsPage()));
          } else if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const StorePage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_rounded), label: "Log"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: "Store"),
        ],
      ),
    );
  }
}
