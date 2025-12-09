import 'package:flutter/material.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      'name': 'Streak Freeze',
      'description': 'This item allows you to freeze your current streak to save your pet\'s life!',
      'price': 50,
      'image': 'assets/images/streakfreeze.png',
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

  void _showSuccessPurchaseDialog(String itemName) {
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
          'You purchased $itemName!',
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
    showDialog(
      context: context,
      builder: (context) {
        bool canAfford = coins >= item['price'];
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
          content: Text(
            canAfford
                ? 'This will cost ${item['price']} coins.'
                : 'You don\'t have enough coins to buy this item.',
            style: const TextStyle(
              fontFamily: 'Questrial',
              color: Color(0xFF6B4423),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            if (!canAfford)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4423),
                  foregroundColor: Colors.white,
                ),
                child: const Text('OK'),
              ),
            if (canAfford) ...[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF8B6443)),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final price = item['price'] as int;
                  final newCoins = coins - price;

                  await _updateCoins(newCoins);

                  if (!mounted) return;

                  Navigator.pop(context);
                  _showSuccessPurchaseDialog(item['name']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4423),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm'),
              ),
            ]
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  Widget _buildStoreItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _showConfirmDialog(item),
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
            // Image area
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

            // Name + description
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

            // Price
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/coin.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${item['price']}',
                    style: const TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

          // +1 / -1 buttons
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('+1 Coin'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (coins > 0) {
                      final newCoins = coins - 1;
                      await _updateCoins(newCoins);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('-1 Coin'),
                ),
              ],
            ),
          ),

          // Store list
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
