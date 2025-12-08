// lib/pages/settings/delete_account.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isDeleting = false;

  final Color darkBrown = const Color(0xFF5C2E14);
  final Color lightBrown = const Color(0xFFF4D6C1);

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // Show a confirmation dialog (simple AlertDialog consistent with ChangePasswordPage)
  Future<bool?> _confirmDeletionDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
          'This will permanently delete your account and all associated data. '
          'This action cannot be undone. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Core flow: re-check password? (optional). Here we follow your request:
  // call the delete_user RPC (server-side function) then sign out.
  Future<void> _verifyAndDelete() async {
    final pw = _passwordController.text.trim();

    if (pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return;
    }

    final confirmed = await _confirmDeletionDialog();
    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('No authenticated user.');

      // Re-authenticate attempt using email+password to ensure password correctness.
      // This uses signInWithPassword — if your supabase version uses signIn, adapt accordingly.
      final email = user.email;
      if (email == null) throw Exception('User has no email.');

      // Re-authenticate to verify password — matches your earlier instruction to ensure correct password
      final signInRes = await _supabase.auth.signInWithPassword(
        email: email,
        password: pw,
      );

      // signInWithPassword returns a session when successful. If it fails, it throws / returns error.
      // If your client doesn't throw, check signInRes for errors.
      if (signInRes.user == null) {
        throw Exception('Password verification failed.');
      }

      // Call your Postgres function 'delete_user' (server-side). Do not call .execute()
      // so this works across common supabase_flutter / postgrest versions.
      await _supabase.rpc('delete_user');

      // Sign out locally
      await _supabase.auth.signOut();

      if (!mounted) return;

      // Show success feedback then navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted. Redirecting to login...')),
      );

      // Replace with your named route if different
      Navigator.pushReplacementNamed(context, '/login');
    } on AuthException catch (e) {
      // Supabase auth errors
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth error: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      // Show an error dialog to be more visible (consistent with prior pages)
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Deletion Failed'),
          content: Text('Failed to delete account. Error: $e'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      style: const TextStyle(
        fontFamily: 'Questrial',
        color: Color(0xFF5C2E14),
      ),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF6A3A0A), width: 2),
        ),
        labelText: "Enter Password",
        labelStyle: TextStyle(
          fontFamily: "Questrial",
          color: darkBrown,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: IconButton(
          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: darkBrown),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBrown,
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBrown),
        backgroundColor: darkBrown,
        elevation: 0,
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontFamily: 'Modak',
            fontSize: 28,
            color: Color(0xFFFDE6D0),
          ),
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
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Warning: Deleting your account is permanent and cannot be undone.',
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    color: darkBrown,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              _passwordField(),
              const SizedBox(height: 35),
              GestureDetector(
                onTap: _isDeleting ? null : _verifyAndDelete,
                child: Opacity(
                  opacity: _isDeleting ? 0.7 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A3A0A),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: _isDeleting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFDE6D0)),
                            )
                          : const Text(
                              'Delete Account',
                              style: TextStyle(
                                fontFamily: 'Questrial',
                                color: Color(0xFFFDE6D0),
                                fontSize: 18,
                              ),
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
}
