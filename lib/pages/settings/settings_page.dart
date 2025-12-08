import 'package:flutter/material.dart';
import 'package:budgipets/controllers/audio_manager.dart';
import 'package:budgipets/pages/profile/profile_page.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:budgipets/pages/dashboard/dashboard.dart';
import 'package:budgipets/pages/auth/login.dart';
import 'package:budgipets/pages/settings/change_email.dart' hide Padding;
import 'package:budgipets/pages/settings/change_password.dart';
import 'package:budgipets/pages/settings/delete_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AudioService _audioManager = AudioService();

  late bool _musicOn;
  bool _notificationsOn = true;

  @override
  void initState() {
    super.initState();
    _musicOn = _audioManager.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1),
      body: Column(
        children: [
          CommonHeader(
            onBack: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Settings",
                  style: TextStyle(
                    fontFamily: "Modak",
                    fontSize: 40,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 30),

          _settingsButton(context, "Change Profile Picture"),

          _settingsButton(context, "Change Email"),
          _settingsButton(context, "Change Password"),

          const SizedBox(height: 8),

          _settingsToggleRow(
            label: "Music",
            value: _musicOn,
            onChanged: (val) async {
              await _audioManager.toggleMusic();
              setState(() {
                _musicOn = _audioManager.isPlaying;
              });
            },
          ),

          _settingsToggleRow(
            label: "Notifications",
            value: _notificationsOn,
            onChanged: (val) {
              setState(() {
                _notificationsOn = val;
              });
              //empty
            },
          ),

          const SizedBox(height: 8),

          _settingsButton(
          context,
          "Log out",
          onTap: () async {
            if (!mounted) return;

            setState(() {}); // optional: keep UI update consistent; remove if you don't want

            try {
              // sign out from Supabase
              await Supabase.instance.client.auth.signOut();
            } catch (e) {
              // show an error but still attempt to navigate to login
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sign out failed: $e')),
              );
            }

            // navigate to login and remove previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          },
        ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeleteAccountPage()),
                );
              },
              child: const Text(
                "Delete Account",
                style: TextStyle(
                  fontFamily: "Questrial",
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsButton(
    BuildContext context,
    String label, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C2E14),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (label == "Change Email") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChangeEmailPage()),
            );
          } else if (label == "Change Password") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChangePasswordPage()),
            );
          } else if (label == "Profile") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          } else if (onTap != null) {
            onTap();
          }
        },
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: "Questrial",
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _settingsToggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF5C2E14),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: "Questrial",
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }
}
