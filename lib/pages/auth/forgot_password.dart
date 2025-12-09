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

  Future<void> showInfoPopup({
  required BuildContext context,
  required String title,
  required String message,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final dialogWidth = screenWidth - 40; // 20px padding each side

  return showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: dialogWidth,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6D3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6B4423), width: 3),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Questrial',
                    color: Color(0xFF6B4423),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Questrial',
                    color: Color(0xFF6B4423),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Full-width brown OKAY button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4423),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'OKAY',
                      style: TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFFFFE8C7),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


 // Step 1: Send OTP
void _sendOTP() async {
  final email = _emailController.text.trim();

  if (email.isEmpty) {
    await showInfoPopup(
      context: context,
      title: "Oops!",
      message: "Please enter your email",
    );
    return;
  }

  if (!email.contains('@') || !email.contains('.')) {
    await showInfoPopup(
      context: context,
      title: "Invalid Email",
      message: "Please enter a valid email",
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final supabase = Supabase.instance.client;
    await supabase.auth.signInWithOtp(email: email);

    setState(() {
      _isLoading = false;
      _otpSent = true;
    });

    await showInfoPopup(
      context: context,
      title: "Success!",
      message: "Verification code sent to your email!",
    );

  } catch (_) {
    setState(() => _isLoading = false);
    await showInfoPopup(
      context: context,
      title: "Error",
      message: "Failed to send OTP. Please try again.",
    );
  }
}

// Step 2: Verify OTP
void _verifyOTP() async {
  final email = _emailController.text.trim();
  final otp = _otpController.text.trim();

  if (otp.isEmpty) {
    await showInfoPopup(
      context: context,
      title: "OTP Empty",
      message: "OTP field cannot be empty. Please enter the code sent to your email.",
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final supabase = Supabase.instance.client;

    await supabase.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.email,
    );

    setState(() {
      _isLoading = false;
      _otpVerified = true;
    });

    await showInfoPopup(
      context: context,
      title: "Code Verified!",
      message: "Now set your new password.",
    );

  } catch (_) {
    setState(() => _isLoading = false);
    await showInfoPopup(
      context: context,
      title: "Error",
      message: "Failed to verify OTP. Please try again.",
    );
  }
}

// Step 3: Update password
void _updatePassword() async {
  final newPassword = _newPasswordController.text.trim();
  final confirmPassword = _confirmPasswordController.text.trim();

  if (newPassword.isEmpty || confirmPassword.isEmpty) {
    await showInfoPopup(
      context: context,
      title: "Password Empty",
      message: "Please fill in both password fields.",
    );
    return;
  }

  if (newPassword.length < 6) {
    await showInfoPopup(
      context: context,
      title: "Password Too Short",
      message: "Password must be at least 6 characters long.",
    );
    return;
  }

  if (newPassword != confirmPassword) {
    await showInfoPopup(
      context: context,
      title: "Password Mismatch",
      message: "Passwords do not match. Please try again.",
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final supabase = Supabase.instance.client;

    await supabase.auth.updateUser(UserAttributes(password: newPassword));

    setState(() => _isLoading = false);

    await showInfoPopup(
      context: context,
      title: "Password Updated!",
      message: "Your password has been successfully updated.",
    );

    // Sign out and go back to login
    await supabase.auth.signOut();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });

  } catch (_) {
    setState(() => _isLoading = false);
    await showInfoPopup(
      context: context,
      title: "Error",
      message: "Failed to update password. Please try again.",
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
              const SizedBox(height: 60),

              // Logo
              Image.asset(
                "assets/images/logo.png",
                height: 120,
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