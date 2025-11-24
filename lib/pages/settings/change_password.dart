import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _oldPassVisible = false;
  bool _newPassVisible = false;
  bool _confirmPassVisible = false;

  final Color darkBrown = const Color(0xFF5C2E14);
  final Color lightBrown = const Color(0xFFF4D6C1);

  void _updatePassword() {
    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New passwords do not match!')),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBrown,
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBrown),
        backgroundColor: darkBrown,
        elevation: 0,
        title: Text(
          'Change Password',
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
                controller: _oldPassController,
                label: 'Old Password',
                visible: _oldPassVisible,
                onToggle: () => setState(() => _oldPassVisible = !_oldPassVisible),
              ),
              SizedBox(height: 20),

              _passwordField(
                controller: _newPassController,
                label: 'New Password',
                visible: _newPassVisible,
                onToggle: () => setState(() => _newPassVisible = !_newPassVisible),
              ),
              SizedBox(height: 20),

              _passwordField(
                controller: _confirmPassController,
                label: 'Confirm Password',
                visible: _confirmPassVisible,
                onToggle: () => setState(() => _confirmPassVisible = !_confirmPassVisible),
              ),

              SizedBox(height: 35),

              GestureDetector(
                onTap: _updatePassword,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF6A3A0A),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Update Password',
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
      style: TextStyle(fontFamily: 'Questrial', color: Color(0xFFFDE6D0)),
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
}
