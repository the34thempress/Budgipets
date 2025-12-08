import 'package:flutter/material.dart';

class BudgetProfileCard extends StatefulWidget {
  const BudgetProfileCard({Key? key}) : super(key: key);

  @override
  State<BudgetProfileCard> createState() => _BudgetProfileCardState();
}

class _BudgetProfileCardState extends State<BudgetProfileCard> {
  String _displayName = 'Jarod';
  String _profileImage = 'assets/images/user.png';

  final List<String> _availableImages = [
    'assets/images/user.png',
    'assets/images/user_2.png',
    'assets/images/user_3.png',
  ];

  void _showEditProfileDialog() {
    final TextEditingController nameController =
        TextEditingController(text: _displayName);
    String tempSelectedImage = _profileImage;

    const Color cream = Color(0xFFFDE6D0); // <<< CHANGED

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: cream, // <<< CHANGED
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <<< CHANGED
              ),
              title: const Text(
                'Edit Profile',
                style: TextStyle(fontFamily: 'Questrial'),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Display Name',
                        style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(fontFamily: 'Questrial'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Choose Profile Picture',
                        style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _availableImages.map((imagePath) {
                            final bool isSelected = tempSelectedImage == imagePath;

                            return GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  tempSelectedImage = imagePath;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 16),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF6A3E1C)
                                        : Colors.grey.shade300,
                                    width: isSelected ? 4 : 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontFamily: 'Questrial'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _displayName = nameController.text;
                      _profileImage = tempSelectedImage;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A3E1C),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brown = Color(0xFF6A3E1C);
    const Color darkBrown = Color(0xFF3D2817);
    const Color cream = Color(0xFFFDE6D0);

    return Center(
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: darkBrown,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                ),

                const SizedBox(height: 70),

                Text(
                  _displayName,
                  style: const TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 40,
                    color: darkBrown,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Budgeteer since December 8 2035',
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: darkBrown,
                  ),
                ),

                const SizedBox(height: 16),

// EMAIL FIELD (Label on top, value inside the valueBox)
// EMAIL FIELD (Label inside darker box, value inside lighter box)
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24),
  child: Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF4F2A09), // outer darker border
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email Address",
          style: TextStyle(
            fontFamily: 'Questrial',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFDE6D0), // dark brown for label
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF8A4A1F), // inner lighter brown
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Text(
            "jaroddodo@gmail.com",
            style: TextStyle(
              fontFamily: 'Questrial',
              fontSize: 16,
              color: Color(0xFFFDE6D0),
            ),
          ),
        ),
      ],
    ),
  ),
),



                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(child: Container(height: 2, color: darkBrown)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "STATS",
                          style: TextStyle(
                            fontFamily: 'Modak',
                            fontSize: 28,
                            color: Color.fromARGB(255, 40, 24, 13),
                          ),
                        ),
                      ),
                      Expanded(child: Container(height: 2, color: darkBrown)),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // STATS FIXED WITH PADDING
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 19), // <<< CHANGED
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStatItem("Pet’s Name", "Chubi"),
                              const SizedBox(height: 20),
                              _buildStatItem("Type of Budgipet", "Dog"),
                              const SizedBox(height: 20),
                              _buildStatItem("Goal Frequency", "Monthly"),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12), // <<< CHANGED
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStatItem("Pet’s Age", "Adult"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),

            // PROFILE IMAGE + EDIT
            Positioned(
              top: 65, // <<< CLOSER
              left: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF4F2A09), width: 4),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _profileImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 105, // <<< CLOSER
                    bottom: 5, // <<< CLOSER
                    child: GestureDetector(
                      onTap: _showEditProfileDialog,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cream,
                          border: Border.all(color: Color(0xFF4F2A09), width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Color(0xFF4F2A09),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: cream),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Questrial',
            fontSize: 14,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Questrial',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
