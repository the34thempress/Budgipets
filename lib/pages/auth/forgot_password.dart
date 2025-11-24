import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _otpSent = false;
  bool _otpVerified = false;

  // Step 1: Send OTP to email
  void _sendOTP() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      
      // Send OTP via email
      await supabase.auth.signInWithOtp(
        email: email,
      );

      setState(() {
        _isLoading = false;
        _otpSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification code sent to your email!"),
          backgroundColor: Color(0xFF4A2C1A),
        ),
      );

    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    }
  }

  // Step 2: Verify OTP
  void _verifyOTP() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the verification code")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      
      // Verify OTP
      await supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );

      setState(() {
        _isLoading = false;
        _otpVerified = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Code verified! Now set your new password."),
          backgroundColor: Color(0xFF4A2C1A),
        ),
      );

    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid code. Please try again.")),
      );
    }
  }

  // Step 3: Update password
  void _updatePassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      
      // Update the user's password
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully!"),
          backgroundColor: Color(0xFF4A2C1A),
        ),
      );

      // Sign out and go back to login
      await supabase.auth.signOut();

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });

    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      
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
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF4A2C1A),
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 20),

              // Logo
              Image.asset(
                "assets/images/logo.png",
                height: 200,
              ),
              const SizedBox(height: 20),

              // Title changes based on step
              Text(
                _otpVerified 
                    ? "Create New Password"
                    : _otpSent 
                        ? "Verify Your Email"
                        : "Reset Your Password",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C1A),
                ),
              ),
              const SizedBox(height: 10),

              // Instructions change based on step
              Text(
                _otpVerified
                    ? "Enter your new password below"
                    : _otpSent
                        ? "We sent a verification code\nto your email"
                        : "Enter your email address and we'll\nsend you a verification code",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 16,
                  color: Color(0xFF4A2C1A),
                ),
              ),
              const SizedBox(height: 40),

              // Step 1: Email field (always visible)
              if (!_otpVerified)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextField(
                    controller: _emailController,
                    enabled: !_otpSent,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontFamily: 'Questrial'),
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(fontFamily: 'Questrial', color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFF4A2C1A),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              
              if (!_otpVerified) const SizedBox(height: 20),

              // Step 2: OTP field (shows after email is sent)
              if (_otpSent && !_otpVerified)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontFamily: 'Questrial'),
                    decoration: const InputDecoration(
                      hintText: "Verification Code",
                      hintStyle: TextStyle(fontFamily: 'Questrial', color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.verified_user,
                        color: Color(0xFF4A2C1A),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

              if (_otpSent && !_otpVerified) const SizedBox(height: 20),

              // Step 3: New password fields (shows after OTP verified)
              if (_otpVerified) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    style: const TextStyle(fontFamily: 'Questrial'),
                    decoration: const InputDecoration(
                      hintText: "New Password",
                      hintStyle: TextStyle(fontFamily: 'Questrial', color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xFF4A2C1A),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(fontFamily: 'Questrial'),
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(fontFamily: 'Questrial', color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF4A2C1A),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 10),

              // Action button (changes based on step)
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
                  onPressed: _isLoading 
                      ? null 
                      : (_otpVerified 
                          ? _updatePassword 
                          : (_otpSent ? _verifyOTP : _sendOTP)),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _otpVerified 
                              ? "Update Password" 
                              : (_otpSent ? "Verify Code" : "Send Code"),
                          style: const TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Resend code option (shows after OTP sent but not verified)
              if (_otpSent && !_otpVerified)
                GestureDetector(
                  onTap: _isLoading ? null : _sendOTP,
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 16,
                      color: Color(0xFF4A2C1A),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

              if (_otpSent && !_otpVerified) const SizedBox(height: 20),

              // Back to login link
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  "Back to Sign In",
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 16,
                    color: Color(0xFF4A2C1A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}