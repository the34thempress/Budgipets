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

  void _updateEmail() {
    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your password!')),
      );
      return;
    }
    
    if (_newEmailController.text.trim() == _confirmEmailController.text.trim()) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Emails do not match!')),
      );
    }
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