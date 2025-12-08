import 'package:flutter/material.dart';

class ChangeEmailPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  bool _passwordVisible = false;

  final Color darkBrown = const Color(0xFF5C2E14);
  final Color lightBrown = const Color(0xFFF4D6C1);

  // Replaced behavior: show informational popup when Update Email is pressed
  void _updateEmail() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: lightBrown,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Feature Unavailable',
            style: TextStyle(fontFamily: 'Modak', fontSize: 22, color: darkBrown),
          ),
          content: SingleChildScrollView(
            child: Text(
              // Slightly tightened punctuation; message retains your content.
              'This feature is currently unavailable. We are working on it right now. '
              'If you really need your email changed, please contact:\n\n'
              'c202301060@iacademy.edu.ph',
              style: TextStyle(fontFamily: 'Questrial', color: darkBrown),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(fontFamily: 'Questrial', color: darkBrown),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBrown,
      appBar: AppBar(
        backgroundColor: darkBrown,
        elevation: 0,
        iconTheme: IconThemeData(color: lightBrown), // Back button color matches background
        title: Text(
          'Change Email',
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
                'assets/images/dog.png',
                height: 200,
              ),
              SizedBox(height: 25),

              _passwordField(
                controller: _passwordController,
                label: 'Enter Password',
                visible: _passwordVisible,
                onToggle: () => setState(() => _passwordVisible = !_passwordVisible),
              ),
              SizedBox(height: 20),

              _emailField(
                controller: _newEmailController,
                label: 'New Email',
              ),
              SizedBox(height: 20),

              _emailField(
                controller: _confirmEmailController,
                label: 'Confirm Email',
              ),

              SizedBox(height: 35),

              GestureDetector(
                onTap: _updateEmail,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF5C2E14),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Update Email',
                      style: TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFFFDE6D0),
                        fontSize: 18,
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
      style: TextStyle(fontFamily: 'Questrial', color: Color(0xFF5C2E14)),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF5C2E14), width: 2),
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

  Widget _emailField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontFamily: 'Questrial', color: Color(0xFF5C2E14)),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF5C2E14), width: 2),
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
