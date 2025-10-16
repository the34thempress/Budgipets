import 'package:flutter/material.dart';
import 'create_account.dart'; // import your create_account page
import '../main_screens/dashboard.dart';     // import your dashboard page

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hardcoded credentials
  final String _validUsername = "admin";
  final String _validPassword = "12345";

  void _login() {
    if (_usernameController.text == _validUsername &&
        _passwordController.text == _validPassword) {
      // Navigate to dashboard if login successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

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
              const Text(
                "Enter Your Credentials\nto proceed",
                textAlign: TextAlign.center,
                style: TextStyle(
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
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
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
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
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
                    backgroundColor: const Color(0xFF6A3B18), // brown button
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                  ),
                  onPressed: _login,
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

              // Don't have account (Clickable)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateAccountPage()),
                  );
                },
                child: const Text(
                  "Don’t Have An Account?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A2C1A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OR divider
              const Row(
                children: [
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
