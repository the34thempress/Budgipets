import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int coins = 175; // 💰 Hardcoded store currency

  // 🧺 Store items using your PNG icons
  final List<Map<String, dynamic>> storeItems = [
    {
      'name': 'Streak Freeze',
      'description':
          'Out for vacation? Or perhaps a digital break? Streak freeze allows you to freeze your current streak to save your pet’s life!',
      'price': 50,
      'image': 'assets/images/streak_freeze.png',
    },
    {
      'name': 'Cool Glasses',
      'description': 'You may equip this to your pet. “amazing”.',
      'price': 199,
      'image': 'assets/images/cool_glasses.png',
    },
    {
      'name': 'Ribbon',
      'description':
          'You may equip this to your pet. Your pet’s girliness is through the roof.',
      'price': 150,
      'image': 'assets/images/ribbon.png',
    },
    {
      'name': 'Dexter’s Tie',
      'description':
          'You may equip this to your pet. Nice tie, surely, one must follow a strict code for his dark passenger.',
      'price': 89,
      'image': 'assets/images/tie.png',
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
          title: Text('Purchase ${item['name']}?'),
          content: Text(
            canAfford
                ? 'This will cost ${item['price']} coins.'
                : 'You don’t have enough coins to buy this item.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
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
                      content: Text('You purchased ${item['name']}!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Confirm'),
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6E3CA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.brown.shade300, width: 1.5),
        ),
        child: Row(
          children: [
            // 🖼 Item Image (from assets)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                item['image'],
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            // 📝 Item name & description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
            // 💰 Price
            Column(
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.orange, size: 20),
                Text('${item['price']}'),
              ],
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
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: const Text(
          'STORE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 💰 Coin Display
          Container(
            color: Colors.brown[700],
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.monetization_on, color: Colors.yellow),
                const SizedBox(width: 6),
                Text(
                  '$coins',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
