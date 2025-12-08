import 'package:flutter/material.dart';
import 'package:budgipets/controllers/audio_manager.dart';
import 'package:budgipets/pages/profile/profile_page.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:budgipets/pages/dashboard/dashboard.dart';
import 'package:budgipets/pages/auth/login.dart';
import 'package:budgipets/pages/settings/change_email.dart' hide Padding;
import 'package:budgipets/pages/settings/change_password.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AudioService _audioManager = AudioService();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1),
      body: Column(
        children: [
          //header
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
                    color: Colors.white
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 30),

          _settingsButton(context, "Change Email"),
          _settingsButton(context, "Change Password"),
          _settingsButton(context, "Change Profile Picture"),

          _settingsButton(
            context,
            "Music : ${_audioManager.isPlaying ? "ON" : "OFF"}",
            onTap: () async {
              await _audioManager.toggleMusic();
              setState(() {});
            },
          ),

          _settingsButton(context, "Notifications : ON"),

          _settingsButton(
            context,
            "Log out",
            onTap: () async {
              // await Supabase.instance.client.auth.signOut(); LATERRRRRRR
              if (!mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
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
          } else if (label == "Change Profile Picture") {
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
}
