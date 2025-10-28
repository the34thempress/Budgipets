import 'package:budgipets/screens/main_screens/pet_management.dart';
import 'package:budgipets/screens/main_screens/profile_page.dart';
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
      backgroundColor: const Color(0xFFFADEC6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                color: const Color(0xFF5C2E14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello, Jarod!",
                      style: TextStyle(
                        fontFamily: "Modak",
                        fontSize: 45,
                        color: Color(0xFFFADEC6),
                      ),
                    ),
                    GestureDetector(
                     onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfilePage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                  )

                  ],
                ),
              ),

              // Balance
              Container(
                color: const Color(0xFFFADEC6),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Balance:",
                      style: TextStyle(
                        fontFamily: "Questrial",
                        fontSize: 25,
                        color: Color(0xFF2C1400),
                      ),
                    ),
                    Text(
                      "₱9,154.08",
                      style: TextStyle(
                        fontFamily: "Questrial",
                        fontSize: 60,
                        color: Color(0xFF2C1400),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
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
                    weekdayStyle: TextStyle(
                        color: Colors.white, fontFamily: "Questrial"),
                    weekendStyle: TextStyle(
                        color: Colors.white, fontFamily: "Questrial"),
                  ),
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(
                        color: Colors.white, fontFamily: "Questrial"),
                    weekendTextStyle: TextStyle(
                        color: Colors.white, fontFamily: "Questrial"),
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
                        border =
                            Border.all(color: const Color(0xFFFFE4B3), width: 3);
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
                  children: const [
                    Text(
                      "Current Goal:",
                      style: TextStyle(
                          color: Color(0xFFFADEC6),
                          fontFamily: "Questrial",
                          fontSize: 21),
                    ),
                    Text(
                      "₱2,000.00",
                      style: TextStyle(
                        fontFamily: "Questrial",
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFADEC6),
                      ),
                    ),
                  ],
                ),
              ),

              // Streak + Pet (stacked number + label, next to pet)
              Container(
                color: const Color(0xFFFADEC6),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        Text(
                          "34",
                          style: TextStyle(
                            fontFamily: "PixelifySans", // corrected name
                            fontSize: 80,
                            height: 1,
                            color: Color(0xFF4A2100),
                          ),
                        ),
                        Text(
                          "DAYS",
                          style: TextStyle(
                            fontFamily: "PixelifySans", // corrected name
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

      // Bottom Navigation Bar (ROUTING UNCHANGED)
bottomNavigationBar: BottomNavigationBar(
  backgroundColor: const Color(0xFF5C2E14), // Your final brown
  selectedItemColor: Color(0xFFFADEC6),
  unselectedItemColor: Color(0xFFFADEC6), 
  currentIndex: 2, // Keep your routing highlight logic intact
  type: BottomNavigationBarType.fixed,
  onTap: (index) {
    if (index == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => SettingsPage()));
    } else if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => PetManagementPage()));
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => LogEntryPage()));
    } else if (index == 3) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => LogsPage()));
    } else if (index == 4) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => StorePage()));
    }
  },
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
    BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pet"),
    BottomNavigationBarItem(icon: Icon(Icons.add_circle_rounded), label: "Streak"),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Logs"),
    BottomNavigationBarItem(icon: Icon(Icons.storefront), label: "Store"),
  ],
),
    );
  }
}
