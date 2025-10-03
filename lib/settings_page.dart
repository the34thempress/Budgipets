import 'package:flutter/material.dart';
import 'profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE6D0),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF6A3A0A),
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {},
                ),
                Row(
                  children: [
                    const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFDE6D0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      "assets/dog_placeholder.png", // placeholder dog image
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _settingsButton(context, "Change Email"),
          _settingsButton(context, "Change Password"),
          _settingsButton(context, "Change Profile Picture"),
          _settingsButton(context, "Music : ON"),
          _settingsButton(context, "Notifications : ON"),
        ],
      ),
    );
  }

  Widget _settingsButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A3A0A),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          if (label == "Change Profile Picture") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
