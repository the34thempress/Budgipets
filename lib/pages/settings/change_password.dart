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

  // Keep original SnackBar behavior for errors / messages
  Future<void> _showSnack(String text) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _updatePassword() async {
    final oldPwd = _oldPassController.text.trim();
    final newPwd = _newPassController.text.trim();
    final confirmPwd = _confirmPassController.text.trim();

    if (oldPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      _showSnack('All fields are required!');
      return;
    }

    if (newPwd != confirmPwd) {
      _showSnack('New passwords do not match!');
      return;
    }

    if (newPwd.length < 6) {
      _showSnack('New password must be at least 6 characters!');
      return;
    }

    if (oldPwd == newPwd) {
      _showSnack('New password cannot be the same as the old password.');
      return;
    }

    final user = supabase.auth.currentUser;
    if (user == null || user.email == null) {
      _showSnack('Not signed in. Please log in again.');
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() => _processing = true);

    try {
      // Re-authenticate using old password
      await supabase.auth.signInWithPassword(
        email: user.email!,
        password: oldPwd,
      );

      // Send recovery OTP to email (we use OTP recovery flow similar to Code B)
      await supabase.auth.signInWithOtp(email: user.email!);

      setState(() => _processing = false);

      // Show OTP dialog (styled to match Code A's colors)
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _OtpDialog(
          email: user.email!,
          newPassword: newPwd,
          darkBrown: darkBrown,
          lightBrown: lightBrown,
        ),
      );
    } on AuthException catch (e) {
      setState(() => _processing = false);
      _showSnack(e.message ?? 'Authentication error.');
    } catch (e) {
      setState(() => _processing = false);
      _showSnack('Something went wrong. Please try again.');
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
                onTap: _processing ? null : _updatePassword,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF6A3A0A),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: _processing
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDE6D0)),
                            ),
                          )
                        : Text(
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
      style: TextStyle(fontFamily: 'Questrial', color: Color(0xFF5C2E14)),
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

/// OTP dialog implemented to visually match Code A (colors / button style)
class _OtpDialog extends StatefulWidget {
  final String email;
  final String newPassword;
  final Color darkBrown;
  final Color lightBrown;

  const _OtpDialog({
    required this.email,
    required this.newPassword,
    required this.darkBrown,
    required this.lightBrown,
  });

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
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
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

  Future<void> _resendCode() async {
    if (_resendCooldown > 0) return;
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithOtp(email: widget.email);
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A new code has been sent to your email.')));
      }
      _startCooldown();
    } on AuthException catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error sending code')));
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to resend code. Try again.')));
    }
  }

  Future<void> _confirm() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 4) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter the full code.')));
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated. Please sign in with your new password.')));
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } on AuthException catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Verification failed.')));
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to verify code or update password.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use AlertDialog but style components to match Code A colors and typography
    return AlertDialog(
      backgroundColor: widget.lightBrown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Enter Verification Code',
        style: TextStyle(fontFamily: 'Questrial', color: widget.darkBrown),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the 6-digit code sent to ${widget.email}',
              style: TextStyle(fontFamily: 'Questrial', color: widget.darkBrown),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: TextStyle(color: widget.darkBrown),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Verification code',
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (_resendCooldown == 0 && !_loading) ? _resendCode : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: (_resendCooldown == 0 && !_loading) ? Color(0xFF6A3A0A) : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _resendCooldown == 0 ? 'Resend Code' : 'Resend in ${_resendCooldown}s',
                          style: TextStyle(
                            color: Color(0xFFFDE6D0),
                            fontFamily: 'Questrial',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'CANCEL',
            style: TextStyle(color: widget.darkBrown),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6A3A0A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _loading ? null : _confirm,
          child: _loading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDE6D0)),
                  ),
                )
              : Text(
                  'CONFIRM',
                  style: TextStyle(color: Color(0xFFFDE6D0), fontFamily: 'Questrial'),
                ),
        ),
      ],
    );
  }
}
