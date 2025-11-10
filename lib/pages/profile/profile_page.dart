import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:budgipets/pages/dashboard/dashboard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _pickedImage;
  bool _passwordVisible = false;

  // Hardcoded values (as requested)
  final String _name = "Jarod";
  final String _email = "jaroddodo@gmail.com";
  final String _password = "myMadeUpPassword!";
  final String _mobile = "09814912820";

  Future<void> _pickFromGallery() async {
    // Request both storage and photos to cover Android versions
    await [
      Permission.photos,
      Permission.storage,
    ].request();

    final status = await Permission.photos.status;
    if (!status.isGranted && !await Permission.storage.isGranted) {
      // permission denied
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Questrial',
          color: Color(0xFF4F2A09),
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Field UI that matches screenshot: outer dark border, inner lighter fill
  Widget _valueBox(Widget child) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF4F2A09), // outer darker border
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(6), // border thickness effect
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF8A4A1F), // inner lighter brown
          borderRadius: BorderRadius.circular(6),
        ),
        child: child,
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        _valueBox(
          Row(
            children: [
              Expanded(
                child: Text(
                  isPassword
                      ? (_passwordVisible ? value : List.filled(value.length, '•').join())
                      : value,
                  style: const TextStyle(
                    fontFamily: 'Questrial',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              if (isPassword)
                GestureDetector(
                  onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                  child: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // page paddings & sizes tuned to match screenshot proportions
    return Scaffold(
      backgroundColor: const Color(0xFFF4DCC2), // cream background like screenshot
      body: Column(
        children: [
          // Keep CommonHeader unchanged but pass the child so it shows no text.
          // The CommonHeader's background is the dark brown; we place the avatar as child so it appears under the back button.
          CommonHeader(
            goToDashboard: true,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  // Add top spacing so avatar sits lower and overlaps cream
                  const SizedBox(height: 4),
                  // Avatar with small edit icon (bottom-right)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // White circular ring behind avatar to match screenshot
                      Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                      ),

                      // Avatar image (tappable)
                      Positioned(
                        child: GestureDetector(
                          onTap: _pickFromGallery,
                          child: CircleAvatar(
                            radius: 120,
                            backgroundColor: Colors.white,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!) as ImageProvider
                                : const AssetImage('assets/images/user.png'),
                          ),
                        ),
                      ),

          const SizedBox(height: 100),
                      // small edit icon at bottom-right of avatar
                      Positioned(
                        right: MediaQuery.of(context).size.width / 2 - 60,
                        bottom: 10,
                        child: GestureDetector(
                          onTap: _pickFromGallery,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F2A09),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Name (big centered)
          Text(
            _name,
            style: const TextStyle(
              fontFamily: 'Questrial',
              fontSize: 42,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Fields — left-aligned and spaced like screenshot
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Display Name", _name),
                  const SizedBox(height: 18),
                  _infoRow("Email Address", _email),
                  const SizedBox(height: 18),
                  _infoRow("Password", _password, isPassword: true),
                  const SizedBox(height: 18),
                  _infoRow("Mobile Number", _mobile),
                  const SizedBox(height: 30),

                  // Deactivate button centered
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F2A09),
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text(
                        "DEACTIVATE ACCOUNT",
                        style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
