// change_password_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

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

  bool _processing = false;

  SupabaseClient get supabase => Supabase.instance.client;

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // --- NEW STYLED POPUP FUNCTION ---
  Future<void> _showPopup(String title, String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = (constraints.maxWidth * 0.9).clamp(0, 500.0) as double;
            return AlertDialog(
              backgroundColor: const Color(0xFFFDE6D0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF6B4423), width: 3),
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', height: 70),
                    const SizedBox(height: 15),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF6B4423),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF6B4423),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4423),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updatePassword() async {
    final oldPwd = _oldPassController.text.trim();
    final newPwd = _newPassController.text.trim();
    final confirmPwd = _confirmPassController.text.trim();

    if (oldPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      await _showPopup("Error", "All fields are required!");
      return;
    }

    if (newPwd != confirmPwd) {
      await _showPopup("Error", "New passwords do not match!");
      return;
    }

    if (newPwd.length < 6) {
      await _showPopup("Error", "New password must be at least 6 characters!");
      return;
    }

    if (oldPwd == newPwd) {
      await _showPopup("Error", "New password cannot be the same as the old password.");
      return;
    }

    final user = supabase.auth.currentUser;
    if (user == null || user.email == null) {
      await _showPopup("Error", "Not signed in. Please log in again.");
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() => _processing = true);

    try {
      await supabase.auth.signInWithPassword(
        email: user.email!,
        password: oldPwd,
      );

      await supabase.auth.signInWithOtp(email: user.email!);

      setState(() => _processing = false);

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _OtpDialog(
          email: user.email!,
          newPassword: newPwd,
        ),
      );
    } on AuthException catch (e) {
      setState(() => _processing = false);
      await _showPopup("Authentication Error", e.message ?? "Authentication error.");
    } catch (e) {
      setState(() => _processing = false);
      await _showPopup("Error", "Something went wrong. Please try again.");
    }
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
              Image.asset('assets/images/dog.png', height: 200),
              const SizedBox(height: 25),
              _passwordField(
                controller: _oldPassController,
                label: 'Old Password',
                visible: _oldPassVisible,
                onToggle: () => setState(() => _oldPassVisible = !_oldPassVisible),
              ),
              const SizedBox(height: 20),
              _passwordField(
                controller: _newPassController,
                label: 'New Password',
                visible: _newPassVisible,
                onToggle: () => setState(() => _newPassVisible = !_newPassVisible),
              ),
              const SizedBox(height: 20),
              _passwordField(
                controller: _confirmPassController,
                label: 'Confirm Password',
                visible: _confirmPassVisible,
                onToggle: () => setState(() => _confirmPassVisible = !_confirmPassVisible),
              ),
              const SizedBox(height: 35),
              GestureDetector(
                onTap: _processing ? null : _updatePassword,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A3A0A),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: _processing
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDE6D0)),
                            ),
                          )
                        : const Text(
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
      style: const TextStyle(fontFamily: 'Questrial', color: Color(0xFF5C2E14)),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF6A3A0A), width: 2),
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

/// ----------------------------
/// OTP DIALOG
/// ----------------------------
class _OtpDialog extends StatefulWidget {
  final String email;
  final String newPassword;

  const _OtpDialog({required this.email, required this.newPassword});

  @override
  State<_OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<_OtpDialog> {
  final TextEditingController _otpController = TextEditingController();
  bool _loading = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _otpController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _resendCooldown = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          _cooldownTimer?.cancel();
          _resendCooldown = 0;
        }
      });
    });
  }

  Future<void> _showPopup(String title, String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = (constraints.maxWidth * 0.9).clamp(0, 500.0) as double;
            return AlertDialog(
              backgroundColor: const Color(0xFFFDE6D0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF6B4423), width: 3),
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', height: 70),
                    const SizedBox(height: 15),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF6B4423),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF6B4423),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4423),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _resendCode() async {
    if (_loading || _resendCooldown > 0) return;
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithOtp(email: widget.email);
      setState(() => _loading = false);
      await _showPopup("Info", "A new code has been sent to your email.");
      _startCooldown();
    } catch (_) {
      setState(() => _loading = false);
      await _showPopup("Error", "Failed to resend code.");
    }
  }

  Future<void> _confirm() async {
    final otp = _otpController.text.trim();
    if (otp.length < 4) {
      await _showPopup("Error", "Please enter the full code.");
      return;
    }
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.verifyOTP(
        token: otp,
        type: OtpType.recovery,
        email: widget.email,
      );
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: widget.newPassword),
      );
      setState(() => _loading = false);
      await _showPopup("Success", "Password updated. Please sign in again.");
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    } catch (_) {
      setState(() => _loading = false);
      await _showPopup("Error", "Verification failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = (constraints.maxWidth * 0.9).clamp(0, 500.0) as double;
        return AlertDialog(
          backgroundColor: const Color(0xFFFDE6D0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF6B4423), width: 3),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.png', height: 70),
                const SizedBox(height: 15),
                const Text(
                  "Email Verification",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    color: Color(0xFF6B4423),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Enter the 6-digit verification code sent to:\n${widget.email}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Questrial',
                    color: Color(0xFF6B4423),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6B4423),
                    fontSize: 20,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    hintText: "••••••",
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_resendCooldown == 0 && !_loading) ? _resendCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4423),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _resendCooldown == 0
                          ? "Resend Code"
                          : "Resend in ${_resendCooldown}s",
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4423),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Confirm",
                            style: TextStyle(
                              fontFamily: 'Questrial',
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                TextButton(
                  onPressed: _loading ? null : () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      color: Color(0xFF6B4423),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
