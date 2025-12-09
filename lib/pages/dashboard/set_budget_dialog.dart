import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SetBudgetDialog extends StatefulWidget {
  final num currentBudget;
  final Future<void> Function(num newBudget, String password) onSave;

  const SetBudgetDialog({
    super.key,
    required this.currentBudget,
    required this.onSave,
  });

  @override
  State<SetBudgetDialog> createState() => _SetBudgetDialogState();
}

class _SetBudgetDialogState extends State<SetBudgetDialog> {
  final TextEditingController _newBudgetController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _saving = false;

  // 👁️ Password visibility toggle
  bool _passwordVisible = false;

  @override
  void dispose() {
    _newBudgetController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFE7D1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Error",
          style: TextStyle(
            fontFamily: "Questrial",
            color: Color(0xFF2C1400),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: "Questrial",
            color: Color(0xFF2C1400),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                fontFamily: "Questrial",
                color: Color(0xFF3D1E0A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF5C2E14),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Set Budget:",
                  style: TextStyle(
                    fontFamily: "Modak",
                    color: Color(0xFFFADEC6),
                    fontSize: 32,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Reminder: Budgipet helps you stay on track with your budget goals. "
                "You can freely adjust your budget anytime, but be honest. Resetting "
                "the already set budget will restart your streak and you won’t gain any EXP gain for the day.",
                style: TextStyle(
                  fontFamily: "Questrial",
                  color: Color(0xFFFADEC6),
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD7B3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 4),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Current Budget:",
                      style: TextStyle(
                        fontFamily: "Questrial",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1400),
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.currentBudget.toStringAsFixed(0),
                      style: const TextStyle(
                        fontFamily: "Questrial",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1400),
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "New Budget:",
                  style: TextStyle(
                    fontFamily: "Questrial",
                    color: Color(0xFFFADEC6),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _newBudgetController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFF2C1400)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFE7D1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Password:",
                  style: TextStyle(
                    fontFamily: "Questrial",
                    color: Color(0xFFFADEC6),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // 🔐 Password Field with Eye Toggle
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                style: const TextStyle(color: Color(0xFF2C1400)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFE7D1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF3D1E0A),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔘 Cancel + Done Buttons
Row(
  children: [
    // CANCEL BUTTON
    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7A5434),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Cancel",
          style: TextStyle(
            fontFamily: "Questrial",
            fontSize: 18,
            color: Color(0xFFFADEC6),
          ),
        ),
      ),
    ),

    const SizedBox(width: 12),

    // DONE BUTTON
    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D1E0A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: _saving
            ? null
            : () async {
                final newBudget =
                    num.tryParse(_newBudgetController.text.trim());
                final password = _passwordController.text.trim();

                if (newBudget == null || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill out all fields properly'),
                    ),
                  );
                  return;
                }

                setState(() => _saving = true);

                try {
                  await widget.onSave(newBudget, password);
                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) {
                    await _showErrorDialog(
                        "Incorrect password. Please try again.");
                  }
                } finally {
                  if (mounted) setState(() => _saving = false);
                }
              },
        child: Text(
          _saving ? "Saving..." : "Done",
          style: const TextStyle(
            fontFamily: "Questrial",
            fontSize: 18,
            color: Color(0xFFFADEC6),
          ),
        ),
      ),
    ),
  ],
)

            ],
          ),
        ),
      ),
    );
  }
}
