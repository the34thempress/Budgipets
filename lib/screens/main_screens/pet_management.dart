import 'package:flutter/material.dart';
import 'dashboard.dart';

class PetManagementPage extends StatefulWidget {
  const PetManagementPage({super.key});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final List<String> wardrobeItems = [
    'assets/images/shades.png',
    'assets/images/bow.png',
    'assets/images/necktie.png',
  ];

  final List<Map<String, dynamic>> inventoryItems = [
    {'image': 'assets/images/coin.png', 'count': 175},
    {'image': 'assets/images/streakfreeze.png', 'count': 2},
  ];

  int wardrobeOffset = 0;
  int inventoryOffset = 0;

  List<T> rotated<T>(List<T> list, int offset) {
    final n = list.length;
    if (n == 0) return [];
    return List<T>.generate(n, (i) => list[(i + offset) % n]);
  }

  void _rotWardrobe(int delta) {
    setState(() {
      wardrobeOffset = (wardrobeOffset + delta) % wardrobeItems.length;
      if (wardrobeOffset < 0) wardrobeOffset += wardrobeItems.length;
    });
  }

  void _rotInventory(int delta) {
    setState(() {
      inventoryOffset = (inventoryOffset + delta) % inventoryItems.length;
      if (inventoryOffset < 0) inventoryOffset += inventoryItems.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFFDE6D0);
    const brown = Color(0xFF6A3A0A);
    const darkBrown = Color(0xFF5C2C0C);

    final rotatedWardrobe = rotated<String>(wardrobeItems, wardrobeOffset);
    final rotatedInventory = rotated<Map<String, dynamic>>(inventoryItems, inventoryOffset);

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 340,
                    child: Image.asset(
                      'assets/images/pet_background.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),

                  // back button → dashboard
                  Positioned(
                    top: 14,
                    left: 12,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cream,
                        shape: BoxShape.circle,
                        border: Border.all(color: darkBrown, width: 2),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 18, color: darkBrown),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const DashboardPage()),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 18,
                    child: Image.asset(
                      'assets/images/pet.png',
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Positioned(
                    bottom: -40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
                      decoration: BoxDecoration(
                        color: brown,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            offset: const Offset(0, 6),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Chubi',
                        style: TextStyle(
                          fontFamily: 'Modak',
                          fontSize: 50,
                          color: Color(0xFFFDE6D0),
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 56),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: Text(
                  'Age: 34 days\nEXP: 3490\nEXP to next level: 0\nStatus: Healthy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 15,
                    color: darkBrown,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // 🪞 Wardrobe — bigger, scrollable, no overflow
                    _carouselCard(
                      title: 'Wardrobe',
                      height: 150, // made larger
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < rotatedWardrobe.length; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: darkBrown.withOpacity(0.12)),
                                  ),
                                  child: Image.asset(rotatedWardrobe[i], fit: BoxFit.contain),
                                ),
                              ),
                          ],
                        ),
                      ),
                      onPrev: () => _rotWardrobe(-1),
                      onNext: () => _rotWardrobe(1),
                    ),

                    const SizedBox(height: 20),

                    // 🎒 Inventory — bigger, scrollable, no overflow
                    _carouselCard(
                      title: 'Inventory',
                      height: 150, // made larger
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < rotatedInventory.length; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 75,
                                      height: 75,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: darkBrown.withOpacity(0.12)),
                                      ),
                                      child: Image.asset(
                                        rotatedInventory[i]['image'] as String,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      (rotatedInventory[i]['count']).toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Questrial',
                                        fontSize: 14,
                                        color: Color(0xFFFDE6D0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      onPrev: () => _rotInventory(-1),
                      onNext: () => _rotInventory(1),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carouselCard({
    required String title,
    required Widget child,
    required VoidCallback onPrev,
    required VoidCallback onNext,
    double height = 120,
  }) {
    const brown = Color(0xFF6A3A0A);
    const cream = Color(0xFFFDE6D0);
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: brown,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Modak',
              fontSize: 22,
              color: cream,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleArrow(onPrev, isLeft: true),
                Expanded(child: Center(child: child)),
                _circleArrow(onNext),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleArrow(VoidCallback onTap, {bool isLeft = false}) {
    const cream = Color(0xFFFDE6D0);
    const darkBrown = Color(0xFF5C2C0C);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: cream,
          shape: BoxShape.circle,
          border: Border.all(color: darkBrown, width: 2),
        ),
        child: Icon(
          isLeft ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
          size: 18,
          color: darkBrown,
        ),
      ),
    );
  }
}
