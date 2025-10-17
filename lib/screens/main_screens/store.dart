import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int coins = 175; // 💰 Hardcoded store currency

  final List<Map<String, dynamic>> storeItems = [
    {
      'name': 'Streak Freeze',
      'description':
          'Out for vacation? Or perhaps a digital break? Streak freeze allows you to freeze your current streak to save your pet’s life!',
      'price': 50,
      'image': 'assets/images/streakfreeze.png',
    },
    {
      'name': 'Cool Glasses',
      'description': 'You may equip this to your pet. “amazing”.',
      'price': 199,
      'image': 'assets/images/shades.png',
    },
    {
      'name': 'Bow',
      'description':
          'You may equip this to your pet. Your pet’s girliness is through the roof.',
      'price': 150,
      'image': 'assets/images/bow.png',
    },
    {
      'name': 'Dexter’s Tie',
      'description':
          'You may equip this to your pet. Nice tie, surely, one must follow a strict code for his dark passenger.',
      'price': 89,
      'image': 'assets/images/necktie.png',
    },
    {
      'name': 'Dog Egg',
      'description': 'When this egg hatches. Get a random dog breed!',
      'price': 249,
      'image': 'assets/images/dog_egg.png',
    },
    {
      'name': 'Cat Egg',
      'description': 'When this egg hatches. Get a random cat breed!',
      'price': 249,
      'image': 'assets/images/cat_egg.png',
    },
  ];

  void _showConfirmDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        bool canAfford = coins >= item['price'];
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Purchase ${item['name']}?',
            style: const TextStyle(fontFamily: 'Questrial'),
          ),
          content: Text(
            canAfford
                ? 'This will cost ${item['price']} coins.'
                : 'You don’t have enough coins to buy this item.',
            style: const TextStyle(fontFamily: 'Questrial'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'Questrial'),
              ),
            ),
            if (canAfford)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    coins -= (item['price'] as int);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'You purchased ${item['name']}!',
                        style: const TextStyle(fontFamily: 'Questrial'),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontFamily: 'Questrial'),
                ),
              ),
          ],
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
          color: const Color(0xFFF6E3CA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.brown.shade300, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              offset: const Offset(2, 4),
              blurRadius: 4,
            )
          ],
        ),
        child: Row(
          children: [
            // 🖼 Item Image
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                item['image'],
                width: 75,
                height: 75,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            // 📝 Item name & description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 18, // smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      fontFamily: 'Questrial',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['description'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.brown,
                      fontFamily: 'Questrial',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // 💰 Price inside a brown box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.brown[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/coin.png',
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${item['price']}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Questrial',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
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
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        centerTitle: true,
        title: const Text(
          'STORE',
          style: TextStyle(
            fontFamily: 'Modak',
            fontSize: 30, // a bit smaller than before
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // 💰 Coin Display (with rounded box)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.brown[500],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/coin.png',
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        '$coins',
                        style: const TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🛍 Store Items
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
