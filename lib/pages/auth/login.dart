import 'package:flutter/material.dart';
import 'create_account.dart';
import 'forgot_password.dart';
import '../dashboard/dashboard.dart';
import '../../screens/tutorial_screens/tutorial.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      routes: {
        'forgot_password': (context) => ForgotPasswordPage(),
      },
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
  bool _passwordVisible = false;

  // ✅ Check if user has completed tutorial from Supabase database
  Future<bool> _hasCompletedTutorial(String userId) async {
    try {
      final supabase = Supabase.instance.client;
      
      // Query the users table for tutorial_completed status
      final response = await supabase
          .from('users')
          .select('tutorial_completed')
          .eq('id', userId)
          .single();
      
      // Return tutorial_completed value, default to false if null
      return response['tutorial_completed'] ?? false;
    } catch (e) {
      // If there's an error or user not found, assume tutorial not completed
      debugPrint('Error checking tutorial status: $e');
      return false;
    }
  }

  // Login function
  void _login() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        // Check if email is verified
        if (user.emailConfirmedAt == null) {
          await supabase.auth.signOut();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please verify your email before logging in."),
            ),
          );
          return;
        }

        // ✅ Check if user has completed tutorial from database
        final hasCompletedTutorial = await _hasCompletedTutorial(user.id);

        if (!mounted) return;

        if (hasCompletedTutorial) {
          // Go to dashboard if tutorial is completed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        } else {
          // Go to tutorial if not completed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TutorialScreen()),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "assets/images/logo.png",
                height: 200,
              ),
              const SizedBox(height: 20),

              // Instruction text
              const Text(
                "Enter Your Credentials\nto proceed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF4A2C1A),
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
                    hintText: "Email",
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

              // Password field with visibility toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xFF4A2C1A),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF4A2C1A),
                      ),
                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                    ),
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
                    backgroundColor: const Color(0xFF6A3B18),
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

              // Sign up link
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateAccountPage()),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A2C1A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Divider
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

              // Forgot Password link
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'forgot_password');
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A2C1A),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}