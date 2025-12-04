import 'package:flutter/material.dart';

class ExpenseRewardPopup extends StatelessWidget {
  final int streakDays;
  final int coinReward;
  final int evolutionTokens;
  final double amountDeducted;

  const ExpenseRewardPopup({
    Key? key,
    required this.streakDays,
    required this.coinReward,
    required this.evolutionTokens,
    required this.amountDeducted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF5C3D2E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "Logged Successfully!" title
            const Text(
              'Logged\nSuccessfully!',
              style: TextStyle(
                fontSize: 43,
                color: Color(0xFFF5DEB3),
                fontFamily: 'Modak',
                height: 0.9,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Streak message
            Text(
              'You\'ve maintained a $streakDays day streak! Keep it up Budgeteer! Here\'s your daily reward!',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Questrial',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Deduction message
            Text(
              '₱${amountDeducted.toStringAsFixed(2)} has been deducted from your balance.',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFF5DEB3),
                fontFamily: 'Questrial',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            
            // Rewards row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Coin reward
                Image.asset(
                  'assets/images/coin.png',
                  width: 45,
                  height: 45,
                ),
                const SizedBox(width: 8),
                Text(
                  '$coinReward',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: 'Questrial',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 32),
                
                // Evolution token reward
                Image.asset(
                  'assets/images/evolution_token.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 8),
                Text(
                  '$evolutionTokens',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: 'Questrial',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),     
            // Close button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFFF5DEB3),
                  fontFamily: 'Questrial',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncomeRewardPopup extends StatelessWidget {
  final int streakDays;
  final int coinReward;
  final int evolutionTokens;
  final double amountAdded;

  const IncomeRewardPopup({
    Key? key,
    required this.streakDays,
    required this.coinReward,
    required this.evolutionTokens,
    required this.amountAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF5C3D2E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "Logged Successfully!" title
            const Text(
              'Logged\nSuccessfully!',
              style: TextStyle(
                fontSize: 43,
                color: Color(0xFFF5DEB3),
                fontFamily: 'Modak',
                height: 0.9,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Streak message
            Text(
              'You\'ve maintained a $streakDays day streak! Keep it up Budgeteer! Here\'s your daily reward!',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Questrial',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Addition message
            Text(
              '₱${amountAdded.toStringAsFixed(2)} has been added to your balance.',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFF5DEB3), // Light green color
                fontFamily: 'Questrial',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

           const SizedBox(height: 5),
           
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Coin reward
                Image.asset(
                  'assets/images/coin.png',
                  width: 45,
                  height: 45,
                ),
                const SizedBox(width: 8),
                Text(
                  '$coinReward',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: 'Questrial',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 32),
                
                // Evolution token reward
                Image.asset(
                  'assets/images/evolution_token.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 8),
                Text(
                  '$evolutionTokens',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: 'Questrial',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            // Close button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFFF5DEB3),
                  fontFamily: 'Questrial',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}