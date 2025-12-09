import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/dashboard.dart';

class PetManagementPage extends StatefulWidget {
  const PetManagementPage({super.key});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  // Only dog accessory positions
  final List<Map<String, dynamic>> petAccessories = [
    {
      'image': 'assets/images/shades.png',
      'top': 30.0,
      'left': 15.0,
      'width': 90.0,
    },
    {
      'image': 'assets/images/bow.png',
      'top': 15.0,
      'left': 65.0,
      'width': 50.0,
    },
    {
      'image': 'assets/images/necktie.png',
      'top': 115.0,
      'left': 40.0,
      'width': 50.0,
    },
  ];

  // Hardcoded inventory for now
  final List<Map<String, dynamic>> inventoryItems = [
    {'image': 'assets/images/coin.png', 'count': 175},
    {'image': 'assets/images/budgimeal.png', 'count': 50}, // 50 Budgimeal
  ];

  int wardrobeOffset = 0;
  int inventoryOffset = 0;
  Set<String> equippedItems = {};
  bool isLoading = true;

  // Pet stats
  int sickness = 0;

  /// Total number of times pet has been fed
  int totalFeeds = 0;

  /// Stage: 1, 2, 3
  int stage = 1;

  @override
  void initState() {
    super.initState();
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final equippedList = prefs.getStringList('equipped_items') ?? [];
      equippedItems = Set<String>.from(equippedList);
      isLoading = false;
    });
  }

  Future<void> _savePetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('equipped_items', equippedItems.toList());
  }

  List<dynamic> rotated(List<dynamic> list, int offset) {
    final n = list.length;
    if (n == 0) return [];
    return List<dynamic>.generate(n, (i) => list[(i + offset) % n]);
  }

  void _rotWardrobe(int delta) {
    setState(() {
      wardrobeOffset = (wardrobeOffset + delta) % petAccessories.length;
      if (wardrobeOffset < 0) wardrobeOffset += petAccessories.length;
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
      _savePetData();
    });
  }

  // Stage logic (based on TOTAL feeds):
  // Stage 1: totalFeeds < 5
  // Stage 2: 5 <= totalFeeds < 35   (5 + 30)
  // Stage 3: totalFeeds >= 35
  void _updateStageFromTotalFeeds() {
    if (totalFeeds >= 35) {
      stage = 3;
    } else if (totalFeeds >= 5) {
      stage = 2;
    } else {
      stage = 1;
    }
  }

  void _feedFromInventoryIndex(int rotatedIndex) {
    final n = inventoryItems.length;
    if (n == 0) return;

    // Map rotated index back to original index
    final originalIndex = (rotatedIndex + inventoryOffset) % n;
    final item = inventoryItems[originalIndex];

    if (item['image'] == 'assets/images/budgimeal.png' &&
        (item['count'] as int) > 0) {
      setState(() {
        item['count'] = (item['count'] as int) - 1;
        totalFeeds += 1;
        _updateStageFromTotalFeeds();
      });
    }
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
    const darkBrown = Color(0xFF5C2E14);

    final rotatedWardrobe =
        rotated(petAccessories, wardrobeOffset).cast<Map<String, dynamic>>();
    final rotatedInventory =
        rotated(inventoryItems, inventoryOffset).cast<Map<String, dynamic>>();

    // Level per stage (resets each stage visually)
    int displayLevel;
    if (stage == 1) {
      displayLevel = totalFeeds;
    } else if (stage == 2) {
      displayLevel = totalFeeds - 5;
      if (displayLevel < 0) displayLevel = 0;
    } else {
      // stage 3
      displayLevel = totalFeeds - 35;
      if (displayLevel < 0) displayLevel = 0;
    }

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top area with background + dog
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
                    ),
                  ),

                  // Back button
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
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: darkBrown,
                        ),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Dog with equipped items overlay
                  Positioned(
                    bottom: 18,
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/dog.png',
                            width: 220,
                            fit: BoxFit.contain,
                          ),
                          ...equippedItems.map((itemPath) {
                            final itemConfig = petAccessories.firstWhere(
                              (item) => item['image'] == itemPath,
                              orElse: () => {},
                            );
                            if (itemConfig.isEmpty) {
                              return const SizedBox.shrink();
                            }
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
                ],
              ),

              const SizedBox(height: 12),

              // Pet name
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
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
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Stage / Level / Sickness / Age – more visually appealing card, no big gap
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 26),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: darkBrown.withOpacity(0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stage + Level
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stage $stage',
                          style: const TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkBrown,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Level: $displayLevel',
                          style: const TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 13,
                            color: darkBrown,
                          ),
                        ),
                      ],
                    ),

                    // Sickness + Age (no large gap between them)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Sickness: $sickness',
                          style: const TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 13,
                            color: darkBrown,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Age: 34 days',
                          style: TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 13,
                            color: darkBrown,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () => _toggleEquipItem(
                                    rotatedWardrobe[i]['image'] as String,
                                  ),
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: equippedItems.contains(
                                              rotatedWardrobe[i]['image'])
                                          ? cream.withOpacity(0.3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: equippedItems.contains(
                                                rotatedWardrobe[i]['image'])
                                            ? cream
                                            : darkBrown.withOpacity(0.12),
                                        width: equippedItems.contains(
                                                rotatedWardrobe[i]['image'])
                                            ? 3
                                            : 1,
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

                    // Inventory card
                    _carouselCard(
                      title: 'Inventory',
                      height: 210,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < rotatedInventory.length; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 75,
                                      height: 75,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: darkBrown.withOpacity(0.12),
                                        ),
                                      ),
                                      child: Image.asset(
                                        rotatedInventory[i]['image'] as String,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (rotatedInventory[i]['count']).toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Questrial',
                                        fontSize: 17,
                                        color: Color(0xFFFDE6D0),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Feed button only for Budgimeal
                                    if (rotatedInventory[i]['image'] ==
                                        'assets/images/budgimeal.png')
                                      SizedBox(
                                        width: 80,
                                        height: 30,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFFDE6D0),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () =>
                                              _feedFromInventoryIndex(i),
                                          child: const Text(
                                            'Feed',
                                            style: TextStyle(
                                              fontFamily: 'Questrial',
                                              fontSize: 14,
                                              color: darkBrown,
                                            ),
                                          ),
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
