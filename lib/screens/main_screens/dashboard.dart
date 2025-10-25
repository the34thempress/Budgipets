import 'package:budgipets/screens/main_screens/pet_management.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:budgipets/screens/main_screens/allowance.dart';
import 'package:budgipets/screens/main_screens/store.dart';
import 'package:budgipets/screens/setting_screens/settings_page.dart';
import 'package:budgipets/screens/main_screens/logs.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Example streak + missed days
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== Header =====
              Container(
                color: const Color(0xFF6B3E1D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello, Jarod!",
                          style: TextStyle(
                            fontFamily: "Modak",
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Balance:",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Quicksand",
                              fontSize: 16),
                        ),
                        Text(
                          "₱9,154.08",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Profile Picture
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                  ],
                ),
              ),

              // ===== Calendar =====
              Container(
                color: const Color(0xFF5C2E14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
        Icon(Icons.chevron_left, color: Colors.white, size: 28),
    rightChevronIcon:
        Icon(Icons.chevron_right, color: Colors.white, size: 28),
  ),
  daysOfWeekStyle: const DaysOfWeekStyle(
    weekdayStyle:
        TextStyle(color: Colors.white, fontFamily: "Questrial"),
    weekendStyle:
        TextStyle(color: Colors.white, fontFamily: "Questrial"),
  ),
  calendarStyle: const CalendarStyle(
    defaultTextStyle: TextStyle(color: Colors.white, fontFamily: "Questrial"),
    weekendTextStyle: TextStyle(color: Colors.white, fontFamily: "Questrial"),
    outsideTextStyle: TextStyle(color: Color(0xFFD9B896), fontFamily: "Questrial"),
    cellMargin: EdgeInsets.all(6),
    isTodayHighlighted: false, // we’ll handle today manually
    selectedDecoration: BoxDecoration(
      color: Color(0xFFFFD700), // Gold selection
      shape: BoxShape.circle,
    ),
    selectedTextStyle: TextStyle(
      color: Color(0xFF5C2E14),
      fontWeight: FontWeight.bold,
      fontFamily: "Questrial",
    ),
  ),
  calendarBuilders: CalendarBuilders(
    defaultBuilder: (context, day, focusedDay) {
      final isStreak = _streakDays.any((d) => isSameDay(d, day));
      final isMissed = _missedDays.any((d) => isSameDay(d, day));
      final isToday = isSameDay(day, DateTime.now());
      final isSelected = isSameDay(day, _selectedDay);

      if (isSelected) {
        // gold highlight handled by calendarStyle
        return null;
      }

      Color? bgColor;
      BoxBorder? border;
      TextStyle textStyle = const TextStyle(
        color: Colors.white,
        fontFamily: "Questrial",
      );

      if (isStreak) {
        bgColor = const Color(0xFFF4D6C1); // streak peach
        textStyle = const TextStyle(
          color: Color(0xFF5C2E14),
          fontWeight: FontWeight.bold,
          fontFamily: "Questrial",
        );
      } else if (isMissed) {
        bgColor = const Color(0xFFD7B59B); // muted light brown
        textStyle = const TextStyle(
          color: Colors.white,
          fontFamily: "Questrial",
        );
      } else if (isToday) {
        border = Border.all(color: Color(0xFFFFD9A0), width: 3);
      }

      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
        alignment: Alignment.center,
        child: Text(
          "${day.day}",
          style: textStyle,
        ),
      );
    },
  ),
),
              ),

              // ===== Streak + Pet Section =====
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                color: const Color(0xFFF4D6C1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "34 DAYS",
                            style: TextStyle(
                              fontFamily: "PixelifySans-VariableFont_wght",
                              fontSize: 32,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "You’ve got a healthy streak and a healthy Budgipet!\nDon’t forget to log today’s expenses to keep up your streak!",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: "Quicksand",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/images/pet.png",
                      height: 90,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== Bottom Navigation =====
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF6B3E1D),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.orange,
        currentIndex: 0,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }

           if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetManagementPage()),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogEntryPage()),
            );
          }

           if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogsPage()),
            );
          }

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StorePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pet"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "Logs"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
        ],
      ),
    );
  }
}
