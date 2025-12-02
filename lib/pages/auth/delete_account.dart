import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();

  bool _passwordVisible = false;

  // Hardcoded values for verification
  final String _correctPassword = "myMadeUpPassword!";
  final String _correctPetName = "chubi";

  final Color darkBrown = const Color(0xFF5C2E14);
  final Color lightBrown = const Color(0xFFF4D6C1);

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: lightBrown,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 60,
                  color: darkBrown,
                ),
                const SizedBox(height: 16),
                Text(
                  'Delete Account?',
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: darkBrown,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you absolutely sure you want to delete your account? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 16,
                    color: darkBrown,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF8A4A1F),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Questrial',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF8A4A1F),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                fontFamily: 'Questrial',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

  void _deleteAccount() {
    // Verify password
    if (_passwordController.text.trim() != _correctPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect password!')),
      );
      return;
    }

    // Verify pet name
    if (_petNameController.text.trim().toLowerCase() != _correctPetName.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect pet name!')),
      );
      return;
    }

    // If both are correct, show confirmation dialog
    _showConfirmationDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBrown,
      appBar: AppBar(
        backgroundColor: darkBrown,
        elevation: 0,
        iconTheme: IconThemeData(color: lightBrown),
        title: Text(
          'Delete Account',
          style: TextStyle(fontFamily: 'Modak', fontSize: 28, color: Color(0xFFFDE6D0)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sad_dog.png',
                height: 200,
              ),
              SizedBox(height: 25),

              // Warning message
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFE5D9), Color(0xFFFFF0E6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFD4A373), width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: darkBrown.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFDAB9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.pets,
                        color: Color(0xFF8B4513),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'This action is permanent and cannot be undone!',
                        style: TextStyle(
                          fontFamily: 'Questrial',
                          color: Color(0xFF6A3A0A),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              _passwordField(
                controller: _passwordController,
                label: 'Enter Password',
                visible: _passwordVisible,
                onToggle: () => setState(() => _passwordVisible = !_passwordVisible),
              ),
              SizedBox(height: 20),

              _textField(
                controller: _petNameController,
                label: 'Enter Pet Name',
              ),

              SizedBox(height: 35),

              GestureDetector(
                onTap: _deleteAccount,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF6A3A0A),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontFamily: 'Questrial',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      style: TextStyle(fontFamily: 'Questrial', color: Color(0xFF6A3A0A)),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF6A3A0A), width: 2),
        ),
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Questrial', color: darkBrown),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off, color: darkBrown),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(fontFamily: 'Questrial', color: Color(0xFF6A3A0A)),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF6A3A0A), width: 2),
        ),
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Questrial', color: darkBrown),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}