import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _passwordVisible = false;

Future<void> showAccountPopup({
      required BuildContext context,
      required String title,
      required String message,
    }) {
      return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF5E6D3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFF6B4423), width: 3),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Questrial',
                color: Color(0xFF6B4423),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Questrial',
                color: Color(0xFF6B4423),
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    color: Color(0xFF8B6443),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }


  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      await showAccountPopup(
        context: context,
        title: 'Missing Information',
        message: 'Please fill in all fields',
);

      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (response.user != null) {
        await showAccountPopup(
            context: context,
            title: 'Success',
            message: 'Account created! Please verify your email before logging in.',
          );


        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      }
      else {
        await showAccountPopup(
          context: context,
          title: 'Sign-up Failed',
          message: 'Sign-up failed. Try again.',
        );

      }
    } catch (e) {
        await showAccountPopup(
          context: context,
          title: 'Error',
          message: e.toString(),
        );

    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF4A2C1A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),

                // Logo
                Image.asset("assets/images/logo.png", height: 200),
                const SizedBox(height: 10),

                const Text(
                  "Enter Your Details!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Questrial",
                    fontSize: 20,
                    color: Color(0xFF4A2C1A),
                  ),
                ),
                const SizedBox(height: 40),

                _buildTextField(
                  controller: _usernameController,
                  hintText: "Username",
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _emailController,
                  hintText: "Email",
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),

                _buildPasswordField(),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A3B18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signUp,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: !_passwordVisible,
        style: const TextStyle(fontFamily: "Questrial"),
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: const TextStyle(
            fontFamily: "Questrial",
            color: Colors.grey,
          ),
          prefixIcon: const Icon(Icons.lock, color: Color(0xFF4A2C1A)),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF4A2C1A),
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  static Widget _buildTextField({
    required TextEditingController controller,
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
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: "Questrial"),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: "Questrial",
            color: Colors.grey,
          ),
          prefixIcon: Icon(icon, color: Color(0xFF4A2C1A)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}