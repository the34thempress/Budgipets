import 'package:flutter/material.dart';

void main() {
  runApp(const BudgiPetsApp());
}

class BudgiPetsApp extends StatelessWidget {
  const BudgiPetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudgiPets',
      theme: ThemeData(
        fontFamily: 'Questrial',
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                "assets/images/logo.png", // replace with your BudgiPets logo
                height: 200,
              ),
              const SizedBox(height: 20),

              // Instruction text
              Text(
                "Enter Your Credentials\nto proceed",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF4A2C1A), // dark brown
                ),
              ),
              const SizedBox(height: 40),

              // Username field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFF4A2C1A),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xFF4A2C1A),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sign In button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A3B18), // brown button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Don't have account
              const Text(
                "Don’t Have An Account?",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A2C1A),
                ),
              ),
              const SizedBox(height: 20),

              // OR divider
              Row(
                children: const [
                  Expanded(
                    child: Divider(color: Color(0xFF4A2C1A), thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4A2C1A),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Color(0xFF4A2C1A), thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Forgot password
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A2C1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
