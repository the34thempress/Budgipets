import 'package:flutter/material.dart';
import 'package:budgipets/screens/main_screens/dashboard.dart';

class CommonHeader extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBack;
  final bool goToDashboard;

  const CommonHeader({
    super.key,
    required this.child,
    this.onBack,
    this.goToDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF6B3E1D),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (onBack != null) {
                onBack!();
              } else if (goToDashboard) {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
