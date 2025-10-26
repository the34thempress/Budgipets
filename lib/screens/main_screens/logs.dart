// lib/screens/main_screens/logs.dart
import 'package:flutter/material.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  // Colors
  Color get bgCream => const Color(0xFFF4DCC2);
  Color get brown => const Color(0xFF6A3E1C);

  TextStyle titleStyle(double size, {Color color = Colors.white}) =>
      TextStyle(fontFamily: 'Questrial', fontSize: size, fontWeight: FontWeight.bold, color: color);

  TextStyle bodyStyle(double size, {Color color = Colors.white}) =>
      TextStyle(fontFamily: 'Questrial', fontSize: size, color: color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      body: Column(
        children: [
          // ✅ All title + pet info moved inside header
          CommonHeader(
  goToDashboard: true, // ✅ Forces redirect to Dashboard
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Logs", style: TextStyle(fontFamily: 'Modak', fontSize: 50, color: Colors.white)),
            Text(
              "Here you’ll find all your logged\nexpenses and income!",
              style: bodyStyle(14),
            ),
          ],
        ),
      ),
      Image.asset(
        'assets/images/pet.png',
        width: 130,
        height: 130,
      )
    ],
  ),
),


          // ✅ Scrollable main content stays
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _logDate("July 14, 2025"),
                  _logCard(
                    icon: Icons.medical_services,
                    color: const Color(0xFF8E0F18),
                    amount: "-₱1820.00",
                    note: "Laboratory Tests, Doctor’s fees, and fare",
                  ),
                  const SizedBox(height: 10),
                  _logCard(
                    icon: Icons.receipt_long,
                    color: const Color(0xFF3B7F55),
                    amount: "-₱106.52",
                    note: "Water bill for my condo",
                  ),

                  const SizedBox(height: 18),
                  _logDate("July 13, 2025"),
                  _logCard(
                    icon: Icons.favorite,
                    color: const Color(0xFFD0538E),
                    amount: "-₱379.50",
                    note: "Dog food for irl chubi, 5kg",
                  ),
                  const SizedBox(height: 10),
                  _logCard(
                    icon: Icons.star_rate,
                    color: const Color(0xFFF6A12C),
                    amount: "-₱598.00",
                    note: "Superman movie date",
                  ),
                  const SizedBox(height: 10),
                  _logCard(
                    icon: Icons.more_horiz,
                    color: const Color(0xFF4F2A09),
                    amount: "-₱70.00",
                    note: "Plete back and forth home",
                  ),

                  const SizedBox(height: 18),
                  _logDate("July 12, 2025"),
                  _logCard(
                    icon: Icons.attach_money,
                    color: const Color(0xFFDB8F00),
                    amount: "+₱1900.00",
                    note: "Sold PL Zoro Card",
                  ),
                  const SizedBox(height: 10),
                  _logCard(
                    icon: Icons.directions_car,
                    color: const Color(0xFF18428C),
                    amount: "-₱150.00",
                    note: "Exterior car wash and shine",
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logDate(String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        date,
        style: const TextStyle(
          fontFamily: 'Questrial',
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _logCard({
    required IconData icon,
    required Color color,
    required String amount,
    required String note,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(amount, style: TextStyle(fontFamily: 'Questrial', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(note, style: TextStyle(fontFamily: 'Questrial', fontSize: 14, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
