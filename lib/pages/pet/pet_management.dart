import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../dashboard/dashboard.dart';

class PetManagementPage extends StatefulWidget {
  const PetManagementPage({super.key});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  // Define accessory positions for each pet type
  final Map<String, List<Map<String, dynamic>>> petAccessories = {
    'cat': [
      {
        'image': 'assets/images/shades.png',
        'top': 40.0,
        'left': 0.0,
        'width': 120.0,
      },
      {
        'image': 'assets/images/bow.png',
        'top': 20.0,
        'left': 0.0,
        'width': 80.0,
      },
      {
        'image': 'assets/images/necktie.png',
        'top': 80.0,
        'left': 0.0,
        'width': 60.0,
      },
    ],
    'dog': [
      {
        'image': 'assets/images/shades.png',
        'top': 35.0,
        'left': 15.0,
        'width': 90.0,
      },
      {
        'image': 'assets/images/bow.png',
        'top': 20.0,
        'left': 65.0,
        'width': 50.0,
      },
      {
        'image': 'assets/images/necktie.png',
        'top': 115.0,
        'left': 34.0,
        'width': 50.0,
      },
    ],
  };

  final List<Map<String, dynamic>> inventoryItems = [
    {'image': 'assets/images/coin.png', 'count': 175},
    {'image': 'assets/images/streakfreeze.png', 'count': 2},
  ];

  int wardrobeOffset = 0;
  int inventoryOffset = 0;
  Set<String> equippedItems = {};
  String currentPet = 'dog'; // Default pet type
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      // Load pet type (default to 'dog')
      currentPet = prefs.getString('pet_type') ?? 'dog';
      
      // Load equipped items
      final equippedList = prefs.getStringList('equipped_items') ?? [];
      equippedItems = Set<String>.from(equippedList);
      
      isLoading = false;
    });
  }

  Future<void> _savePetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_type', currentPet);
    await prefs.setStringList('equipped_items', equippedItems.toList());
  }

  List<dynamic> rotated(List<dynamic> list, int offset) {
    final n = list.length;
    if (n == 0) return [];
    return List<dynamic>.generate(n, (i) => list[(i + offset) % n]);
  }

  void _rotWardrobe(int delta) {
    setState(() {
      final items = petAccessories[currentPet]!;
      wardrobeOffset = (wardrobeOffset + delta) % items.length;
      if (wardrobeOffset < 0) wardrobeOffset += items.length;
    });
  }

  void _rotInventory(int delta) {
    setState(() {
      inventoryOffset = (inventoryOffset + delta) % inventoryItems.length;
      if (inventoryOffset < 0) inventoryOffset += inventoryItems.length;
    });
  }

  void _toggleEquipItem(String itemPath) {
    setState(() {
      if (equippedItems.contains(itemPath)) {
        equippedItems.remove(itemPath);
      } else {
        equippedItems.add(itemPath);
      }
      _savePetData(); // Save after each change
    });
  }

  void _changePetType(String petType) {
    setState(() {
      currentPet = petType;
      _savePetData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    const cream = Color(0xFFFDE6D0);
    const brown = Color(0xFF6A3A0A);
    const darkBrown = Color(0xFF5C2C0C);

    final wardrobeItems = petAccessories[currentPet]!;
    final rotatedWardrobe = rotated(wardrobeItems, wardrobeOffset).cast<Map<String, dynamic>>();
    final rotatedInventory = rotated(inventoryItems, inventoryOffset).cast<Map<String, dynamic>>();

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

                  // Pet type switcher
                  Positioned(
                    top: 14,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: brown,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: darkBrown, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _petTypeButton('cat', '🐱'),
                          const SizedBox(width: 8),
                          _petTypeButton('dog', '🐶'),
                        ],
                      ),
                    ),
                  ),

                  // Pet with equipped items overlay
                  Positioned(
                    bottom: 18,
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Base pet image
                          Image.asset(
                              'assets/images/dog.png',  // This will be cat.png or dog.png
                              width: 220,
                              fit: BoxFit.contain,
                            ),
                          // Overlay each equipped item with custom positioning
                          ...equippedItems.map((itemPath) {
                            // Find the item config for current pet
                            final itemConfig = wardrobeItems.firstWhere(
                              (item) => item['image'] == itemPath,
                              orElse: () => {},
                            );
                            
                            if (itemConfig.isEmpty) return const SizedBox.shrink();
                            
                            return Positioned(
                              top: itemConfig['top'] as double,
                              left: itemConfig['left'] as double,
                              child: Image.asset(
                                itemPath,
                                width: itemConfig['width'] as double,
                                fit: BoxFit.contain,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
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
                    // 🪞 Wardrobe — with tap to equip multiple items
                    _carouselCard(
                      title: 'Wardrobe',
                      height: 165,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < rotatedWardrobe.length; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () => _toggleEquipItem(rotatedWardrobe[i]['image'] as String),
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: equippedItems.contains(rotatedWardrobe[i]['image'])
                                          ? cream.withOpacity(0.3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: equippedItems.contains(rotatedWardrobe[i]['image'])
                                            ? cream
                                            : darkBrown.withOpacity(0.12),
                                        width: equippedItems.contains(rotatedWardrobe[i]['image']) ? 3 : 1,
                                      ),
                                    ),
                                    child: Image.asset(
                                      rotatedWardrobe[i]['image'] as String,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      onPrev: () => _rotWardrobe(-1),
                      onNext: () => _rotWardrobe(1),
                    ),

                    const SizedBox(height: 20),

                    // 🎒 Inventory
                    _carouselCard(
                      title: 'Inventory',
                      height: 165,
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
                                      padding: const EdgeInsets.all(5),
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
                                    Text(
                                      (rotatedInventory[i]['count']).toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Questrial',
                                        fontSize: 17,
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

  Widget _petTypeButton(String petType, String emoji) {
    const cream = Color(0xFFFDE6D0);
    const darkBrown = Color(0xFF5C2C0C);
    final isSelected = currentPet == petType;
    
    return GestureDetector(
      onTap: () => _changePetType(petType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? cream : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: darkBrown, width: 2) : null,
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 20),
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