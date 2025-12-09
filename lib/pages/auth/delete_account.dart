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
  final String _correctPassword = "duckduckgoose1!";
  final String _correctPetName = "Chubi";

  final Color darkBrown = const Color(0xFF5C2E14);
  final Color lightBrown = const Color(0xFFF4D6C1);

  Future<void> showStyledPopup({
    required BuildContext context,
    required String title,
    required String message,
    Widget? customContent, // optional for custom buttons/content
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = (constraints.maxWidth * 0.9).clamp(0, 500.0) as double;

            return AlertDialog(
              backgroundColor: const Color(0xFFFDE6D0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF6B4423), width: 3),
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logo.png',
                      height: 70,
                    ),
                    const SizedBox(height: 15),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF6B4423),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Message
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF6B4423),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Custom content (buttons)
                    if (customContent != null) customContent,
                    if (customContent == null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4423),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontFamily: 'Questrial',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog() {
  showStyledPopup(
    context: context,
    title: 'Delete Account?',
    message: 'Are you absolutely sure you want to delete your account? This action cannot be undone.',
    customContent: Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B4423),
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
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // close popup
                  Navigator.pushReplacementNamed(context, '/login'); // delete account action
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B4423),
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
        const SizedBox(height: 10),
      ],
    ),
  );
}


  void _deleteAccount() {
      // Check if password is empty
      ScaffoldMessenger.of(context).clearSnackBars();
  if (_passwordController.text.trim().isEmpty) {
    showStyledPopup(
      context: context,
      title: 'Error',
      message: 'Password cannot be empty!',
    );
    return;
  }

  // Check if pet name is empty
  if (_petNameController.text.trim().isEmpty) {
    showStyledPopup(
      context: context,
      title: 'Error',
      message: 'Pet name cannot be empty!',
    );
    return;
  }

    // Verify password
    if (_passwordController.text.trim() != _correctPassword) {
      showStyledPopup(
        context: context,
        title: 'Error',
        message: 'Incorrect password!',
      );
      return;
    }

    // Verify pet name
    if (_petNameController.text.trim().toLowerCase() != _correctPetName.toLowerCase()) {
      showStyledPopup(
        context: context,
        title: 'Error',
        message: 'Incorrect pet name!',
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
          style: TextStyle(fontFamily: 'Modak', fontSize: 28, color: Colors.white),
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
