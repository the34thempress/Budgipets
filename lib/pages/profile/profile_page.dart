import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:budgipets/pages/dashboard/dashboard.dart';
import '../auth/delete_account.dart';
import 'package:budgipets/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _pickedImage;
  bool _passwordVisible = false;

  // Hardcoded values (as requested)
  String _name = "Jarod";
  final String _email = "jaroddodo@gmail.com";
  final String _password = "myMadeUpPassword!";

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

  void _showEditNameDialog() {
    final TextEditingController nameController = TextEditingController(text: _name);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFF4DCC2),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Display Name',
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4F2A09),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                    fontFamily: 'Questrial',
                    color: Color(0xFF4F2A09),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF4F2A09), width: 2),
                    ),
                    labelText: 'Display Name',
                    labelStyle: const TextStyle(
                      fontFamily: 'Questrial',
                      color: Color(0xFF4F2A09),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8A4A1F),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Questrial',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Save button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (nameController.text.trim().isNotEmpty) {
                            setState(() {
                              _name = nameController.text.trim();
                            });
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Name cannot be empty!')),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F2A09),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: 'Questrial',
                                color: Colors.white,
                                fontSize: 16,
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
        );
      },
    );
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

  Widget _infoRow(String label, String value, {bool isPassword = false, bool isEditable = false}) {
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
              if (isEditable)
                GestureDetector(
                  onTap: _showEditNameDialog,
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF4D6C1),
      body: Stack(
        children: [
          Column(
            children: [
              // Header with more height
              CommonHeader(
                goToDashboard: true,
                child: const SizedBox(height: 120), // Increased height for longer header
              ),
              
              // Content area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 140), // Space for the overlapping avatar
                      
                      // Name (big centered) - always under profile picture
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

                      const SizedBox(height: 10), // Space between name and fields

                      // Fields - always below the display name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow("Display Name", _name, isEditable: true),
                            const SizedBox(height: 18),
                            _infoRow("Email Address", _email),
                            const SizedBox(height: 18),
                            _infoRow("Password", _password, isPassword: true),
                            const SizedBox(height: 30),

                            // Deactivate button centered - styling unchanged
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.delete_account);
                          },
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Positioned avatar - bigger and overlaps more
          Positioned(
            top: 80, // Positioned to overlap from longer header
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // White circular ring behind avatar
                  Container(
                    width: 260, // Bigger ring
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                  ),

                  // Avatar image - bigger
                  GestureDetector(
                    onTap: _pickFromGallery,
                    child: CircleAvatar(
                      radius: 120, // Bigger avatar (240px diameter)
                      backgroundColor: Colors.white,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!) as ImageProvider
                          : const AssetImage('assets/images/user.png'),
                    ),
                  ),

                  // Edit icon at bottom-right of avatar
                  Positioned(
                    right: 10,
                    bottom: 5,
                    child: GestureDetector(
                      onTap: _pickFromGallery,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4F2A09),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}