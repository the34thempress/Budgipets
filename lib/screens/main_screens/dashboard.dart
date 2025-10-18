import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:budgipets/screens/main_screens/allowance.dart';
import 'package:budgipets/screens/main_screens/store.dart';
import 'package:budgipets/screens/setting_screens/settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<DateTime> _streakDays = [
    DateTime(2025, 7, 6),
    DateTime(2025, 7, 7),
    DateTime(2025, 7, 9),
    DateTime(2025, 7, 10),
    DateTime(2025, 7, 14),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1), // peach
      body: SafeArea(
  child: SingleChildScrollView( // 👈 Added
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ===== Header =====
        Container(
          color: const Color(0xFF6B3E1D),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hello, Jarod!",
                style: TextStyle(
                  fontFamily: "Modak",
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text("Balance:",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
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
        ),

        // ===== Calendar =====
        Container(
          color: const Color(0xFF5C2E14),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontFamily: "Modak",
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white),
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              outsideTextStyle: TextStyle(color: Colors.grey),
            ),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (_streakDays.any((d) => isSameDay(d, day))) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),

        // ===== Streak + Pet =====
        Container(
          padding: const EdgeInsets.all(16),
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
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "assets/images/pet.png",
                height: 80,
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

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogEntryPage()),
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
