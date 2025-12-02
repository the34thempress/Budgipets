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

Future<double?> _promptNumber({
  required String title,
  required double initial,
}) async {
  final controller = TextEditingController(text: initial.toString());

  return showDialog<double>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Color(0xFFFDE6D0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF6A3E1C), // deep brown theme
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFF3E1D01), // darker brown border
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TITLE
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Questrial",
                  fontSize: 24,
                  color: Color(0xFFFFD79B),
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 16),

              // INPUT FIELD
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Questrial",
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter amount",
                  hintStyle: TextStyle(
                    color: Color(0xFF3E1D01),
                    fontFamily: "Questrial",
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFF3E1D01),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF3E1D01),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // BUTTON ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CANCEL BUTTON
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF3E1D01),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Questrial",
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  // CONFIRM BUTTON
                  GestureDetector(
                    onTap: () {
                      final value = double.tryParse(controller.text);
                      Navigator.pop(context, value);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD79B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Questrial",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update $field')),
      );
    }
  }

 Widget _buildTopBarEmptyWithAvatar() {
  return Container(
    color: const Color(0xFF6A3E1C),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 👤 AVATAR ON THE LEFT
        GestureDetector(
          onTap: () {
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
          child: const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/images/user.png"),
          ),
        ),

        // 🪙 COINS WITH CONTAINER ON THE RIGHT
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF3E1D01), width: 1),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/coin.png',
                width: 26,
                height: 26,
              ),
              const SizedBox(width: 4),
              Text(
                '175',
                style: const TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _buildSummaryTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: Center(
        child: Text(
          "Summary",
          style: const TextStyle(
            fontFamily: "Questrial",
            fontSize: 34,
            color: Color(0xFF4A2100),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceAndGoalRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (_editingAmount || _dialogOpen || _loading) return;
                _editingAmount = true;
                await showDialog(
                  context: context,
                  builder: (_) {
                    return SetBudgetDialog(
                      currentBudget: _balance ?? 0,
                      onSave: (newBudget, password) async {
                        final user = Supabase.instance.client.auth.currentUser;
                        if (user == null) throw Exception("Not logged in");
                        final result = await Supabase.instance.client.auth
                            .signInWithPassword(
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
                _editingAmount = false;
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF582901),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Balance:",
                        style: TextStyle(
                            color: Color(0xFFFFD79B),
                            fontFamily: "Questrial",
                            fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                      _loading ? "…" : "₱${(_balance ?? 0).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontFamily: "Questrial",
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 10,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  6,
                  (i) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Color(0xFF582901),
                          shape: BoxShape.circle,
                        ),
                      )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (_loading || _dialogOpen) return;
                _editingAmount = true;
                final v = await _promptNumber(
                  title: "Set Goal",
                  initial: 0.0,
                );
                if (v != null) {
                  if (!mounted) {
                    _editingAmount = false;
                    return;
                  }
                  await _updateBudgetField('goal', v);
                }
                _editingAmount = false;
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF582901),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Goal:",
                        style: TextStyle(
                            color: Color(0xFFFFD79B),
                            fontFamily: "Questrial",
                            fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                      _loading ? "…" : "₱${(_goal ?? 0).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontFamily: "Questrial",
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysAndPet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: const [
                          Text(
                            "34",
                            style: TextStyle(
                              fontFamily: "PixelifySans",
                              fontSize: 90,
                              height: 0.9,
                              color: Color(0xFF5C2E14),
                            ),
                          ),
                          Text(
                            "DAYS",
                            style: TextStyle(
                              fontFamily: "PixelifySans",
                              fontSize: 40,
                              color: Color(0xFF5C2E14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Image.asset(
                        "assets/images/dog.png",
                        height: 140,
                      ),
                    ],
                  ),
    );
  }

  Widget _buildCalendarCard() {
    const outsideColor = Color(0xFFD9B896);
    const dayTextColor = Color.fromARGB(255, 237, 221, 195);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3E1D01),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          children: [
            TableCalendar(
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
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: const TextStyle(
                    fontFamily: "Questrial",
                    fontSize: 21,
                    color: Color.fromARGB(255, 251, 237, 225),
                    fontWeight: FontWeight.w700),
                leftChevronIcon:
                    const Icon(Icons.chevron_left, color: Color(0xFFFADEC6)),
                rightChevronIcon:
                    const Icon(Icons.chevron_right, color: Color(0xFFFADEC6)),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    color: Color.fromARGB(255, 238, 208, 163),
                    fontFamily: "Questrial",
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
                weekendStyle: TextStyle(
                    color: Color(0xFFFFD79B),
                    fontFamily: "Questrial",
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(
                    color: Color.fromARGB(255, 247, 233, 210), fontFamily: "Questrial", fontSize: 13),
                weekendTextStyle: TextStyle(
                    color: Color.fromARGB(255, 220, 201, 171), fontFamily: "Questrial", fontSize: 13),
                outsideTextStyle:
                    TextStyle(color: outsideColor, fontFamily: "Questrial"),
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
                cellMargin: EdgeInsets.zero,
              ),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                  final idx = day.weekday % 7;
                  return Center(
                    child: Text(
                      labels[idx],
                      style: const TextStyle(
                        color: Color(0xFFFFD79B),
                        fontFamily: "Questrial",
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  final isStreak = _streakDays.any((d) => isSameDay(d, day));
                  final isMissed = _missedDays.any((d) => isSameDay(d, day));
                  final isToday = isSameDay(day, DateTime.now());
                  final isSelected = isSameDay(day, _selectedDay);
                  if (isSelected) return null;
                  Color? bgColor;
                  BoxBorder? border;
                  TextStyle textStyle = const TextStyle(
                      color: dayTextColor, fontFamily: "Questrial", fontSize: 13);
                  if (isStreak) {
                    bgColor = const Color(0xFFF4D6C1);
                    textStyle = const TextStyle(
                      color: Color(0xFF5C2E14),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Questrial",
                      fontSize: 13,
                    );
                  } else if (isMissed) {
                    bgColor = const Color(0xFFD7B59B);
                  } else if (isToday) {
                    border = Border.all(color: const Color(0xFFFFE4B3), width: 2);
                  }
                  return Center(
                    child: Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                        border: border,
                      ),
                      alignment: Alignment.center,
                      child: Text("${day.day}", style: textStyle),
                    ),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Text(
                      "${day.day}",
                      style: const TextStyle(
                        color: outsideColor,
                        fontFamily: "Questrial",
                        fontSize: 13,
                      ),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  if (isSameDay(day, _selectedDay)) return null;
                  return Center(
                    child: Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: const Color(0xFFFFE4B3), width: 2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text("${day.day}",
                          style: const TextStyle(
                              color: dayTextColor, fontFamily: "Questrial")),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bottomBarColor = Color(0xFF6A3E1C);
    const accentText = Color(0xFFFADEC6);
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopBarEmptyWithAvatar(),
              _buildSummaryTitle(),
              _buildDaysAndPet(),
              _buildBalanceAndGoalRow(),
              _buildCalendarCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: bottomBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      if (!mounted || _dialogOpen) return;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SettingsPage()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.settings, color: accentText),
                        SizedBox(height: 4),
                        Text("Settings",
                            style: TextStyle(
                                color: accentText,
                                fontFamily: "Questrial",
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!mounted || _dialogOpen) return;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const PetManagementPage()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.pets, color: accentText),
                        SizedBox(height: 4),
                        Text("Pet",
                            style: TextStyle(
                                color: accentText,
                                fontFamily: "Questrial",
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 96),
                  InkWell(
                    onTap: () {
                      if (!mounted || _dialogOpen) return;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const LogsPage()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.list_alt, color: accentText),
                        SizedBox(height: 4),
                        Text("History",
                            style: TextStyle(
                                color: accentText,
                                fontFamily: "Questrial",
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!mounted || _dialogOpen) return;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const StorePage()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.storefront, color: accentText),
                        SizedBox(height: 4),
                        Text("Store",
                            style: TextStyle(
                                color: accentText,
                                fontFamily: "Questrial",
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -18,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (!mounted || _dialogOpen) return;
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LogEntryPage()),
                    );
                    if (!mounted) return;
                    await _loadOrCreateBudget();
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: bottomBarColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF3F2411), width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, size: 32, color: accentText),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
