import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1), // peach background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "assets/images/logo.png", // adjust path as needed
                height: 160,
              ),
              const SizedBox(height: 20),

              // Title text
              const Text(
                "Enter Your Details!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Questrial",
                  fontSize: 20,
                  color: Color(0xFF4A2C1A), // dark brown
                ),
              ),
              const SizedBox(height: 40),

              // Username field
              _buildTextField(
                hintText: "Username",
                icon: Icons.person,
              ),
              const SizedBox(height: 20),

              // Email field
              _buildTextField(
                hintText: "Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 20),

              // Password field
              _buildTextField(
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Phone field
              _buildTextField(
                hintText: "Phone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),

              // Proceed button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A3B18), // brown button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Proceed",
                    style: TextStyle(
                      fontFamily: "Questrial",
                      fontSize: 18,
                      color: Colors.white,
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

  // Reusable text field widget
  static Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: "Questrial"),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: "Questrial",
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            icon,
            color: Color(0xFF4A2C1A), // dark brown icons
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
