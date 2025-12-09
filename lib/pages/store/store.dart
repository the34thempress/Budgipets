import 'package:flutter/material.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  static const Color darkBrown = Color(0xFF582901);
  static const Color pageColor = Color(0xFFFDE6D0);

  final supabase = Supabase.instance.client;

  int coins = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('profiles')
        .select('coins')
        .eq('id', user.id)
        .single();

    setState(() {
      coins = response['coins'] ?? 0;
      _loading = false;
    });
  }

  Future<void> _updateCoins(int newCoins) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() {
      coins = newCoins;
    });

    await supabase
        .from('profiles')
        .update({'coins': newCoins})
        .eq('id', user.id);
  }

  final List<Map<String, dynamic>> storeItems = [
    {
      'name': 'Budgimeal',
      'description': 'Feed this to your pet to help it level up faster.',
      'price': 100,
      'image': 'assets/images/budgimeal.png',
    },
    {
      'name': 'Cool Glasses',
      'description': 'Maximize your pet\'s swag and aura with these stylish shades!',
      'price': 100,
      'image': 'assets/images/shades.png',
    },
    {
      'name': 'Bow',
      'description': 'The cutest little head accessory for the girlies!',
      'price': 100,
      'image': 'assets/images/bow.png',
    },
    {
      'name': 'Dexter\'s Tie',
      'description':
          'You may equip this to your pet. Nice tie, surely, one must follow a strict code for his dark passenger.',
      'price': 100,
      'image': 'assets/images/necktie.png',
    },
    {
      'name': 'Dog Egg',
      'description': 'When this egg hatches, get a random dog breed!',
      'price': 249,
      'image': 'assets/images/dog_egg.png',
    },
    {
      'name': 'Cat Egg',
      'description': 'When this egg hatches, get a random cat breed!',
      'price': 249,
      'image': 'assets/images/cat_egg.png',
    },
  ];

  void _showSuccessPurchaseDialog(String itemName, int quantity) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFF5E6D3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF6B4423), width: 3),
        ),
        title: const Text(
          'Purchase Successful!',
          style: TextStyle(
            fontFamily: 'Questrial',
            color: Color(0xFF6B4423),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          quantity > 1
              ? 'You purchased $quantity $itemName items!'
              : 'You purchased $itemName!',
          style: const TextStyle(
            fontFamily: 'Questrial',
            color: Color(0xFF6B4423),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B4423),
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  void _showConfirmDialog(Map<String, dynamic> item) {
    final bool isBudgimeal = item['name'] == 'Budgimeal';
    if (!isBudgimeal) return;

    int quantity = 1;
    bool isProcessing = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final int price = item['price'] as int;
            final int totalPrice = price * quantity;
            final bool canAfford = coins >= totalPrice;
            final bool disableControls = isProcessing;

            return AlertDialog(
              backgroundColor: const Color(0xFFF5E6D3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF6B4423), width: 3),
              ),
              title: Text(
                'Purchase ${item['name']}?',
                style: const TextStyle(
                  fontFamily: 'Questrial',
                  color: Color(0xFF6B4423),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Each Budgimeal costs 100 coins.\nChoose how many you want to buy.',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      color: Color(0xFF6B4423),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: disableControls
                            ? null
                            : () {
                                setState(() {
                                  if (quantity > 10) {
                                    quantity -= 10;
                                  } else {
                                    quantity = 1;
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4423),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(48, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: const Text('-10'),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B4423),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: disableControls
                            ? null
                            : () {
                                setState(() {
                                  quantity += 10;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4423),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(48, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: const Text('+10'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total: $totalPrice coins',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: canAfford ? const Color(0xFF6B4423) : Colors.red,
                    ),
                  ),
                  if (!canAfford && !isProcessing)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'You don\'t have enough coins.',
                        style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 13,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  if (isProcessing)
                    const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF6B4423),
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isProcessing ? null : () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF8B6443)),
                  ),
                ),
                ElevatedButton(
                  onPressed: (!canAfford || isProcessing)
                      ? null
                      : () async {
                          setState(() {
                            isProcessing = true;
                          });

                          final int totalPriceNow = price * quantity;
                          if (coins < totalPriceNow) {
                            setState(() {
                              isProcessing = false;
                            });
                            return;
                          }

                          final int newCoins = coins - totalPriceNow;
                          await _updateCoins(newCoins);

                          final prefs = await SharedPreferences.getInstance();
                          final currentMeals =
                              prefs.getInt('budgimeal_count') ?? 0;
                          await prefs.setInt(
                              'budgimeal_count', currentMeals + quantity);

                          if (!mounted) return;

                          Navigator.pop(context);
                          _showSuccessPurchaseDialog(item['name'], quantity);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4423),
                    foregroundColor: Colors.white,
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Confirm'),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            );
          },
        );
      },
    );
  }

  Widget _buildStoreItem(Map<String, dynamic> item) {
    final bool isBudgimeal = item['name'] == 'Budgimeal';

    return GestureDetector(
      onTap: isBudgimeal ? () => _showConfirmDialog(item) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: pageColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: darkBrown, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 242, 222, 202),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: darkBrown, width: 1.2),
              ),
              child: Image.asset(
                item['image'],
                width: 65,
                height: 65,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['description'],
                    style: const TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 13.5,
                      color: darkBrown,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            isBudgimeal
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: darkBrown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/coin.png',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item['price']}',
                          style: const TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text(
                    'SOLD',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: Column(
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Store',
                  style: TextStyle(
                    fontFamily: 'Modak',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/coin.png',
                        width: 26,
                        height: 26,
                      ),
                      const SizedBox(width: 4),
                      _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              '$coins',
                              style: const TextStyle(
                                fontFamily: 'Questrial',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final newCoins = coins + 1;
                    await _updateCoins(newCoins);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(52, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('+1'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (coins > 0) {
                      final newCoins = coins - 1;
                      await _updateCoins(newCoins);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(52, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('-1'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final newCoins = coins + 10;
                    await _updateCoins(newCoins);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(52, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('+10'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (coins >= 10) {
                      final newCoins = coins - 10;
                      await _updateCoins(newCoins);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(52, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('-10'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: storeItems.length,
              itemBuilder: (context, index) {
                return _buildStoreItem(storeItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
