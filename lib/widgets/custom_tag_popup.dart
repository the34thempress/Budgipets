import 'package:flutter/material.dart';

class CustomTagPopup extends StatefulWidget {
  final Function(String name, Color color, IconData icon) onTagCreated;

  const CustomTagPopup({
    Key? key,
    required this.onTagCreated,
  }) : super(key: key);

  @override
  State<CustomTagPopup> createState() => _CustomTagPopupState();
}

class _CustomTagPopupState extends State<CustomTagPopup> {
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = const Color(0xFF582901);
  IconData _selectedIcon = Icons.category;

  final List<Color> _availableColors = [
    const Color(0xFF720607), // Red
    const Color(0xFF073598), // Blue
    const Color(0xFFC57000), // Orange
    const Color(0xFF390488), // Purple
    const Color(0xFFFEB65B), // Light Orange
    const Color(0xFFCD6082), // Pink
    const Color.fromARGB(255, 71, 166, 114), // Green
    const Color(0xFF582901), // Brown
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  final List<IconData> _availableIcons = [
    Icons.category,
    Icons.star,
    Icons.favorite,
    Icons.home,
    Icons.work,
    Icons.school,
    Icons.sports_soccer,
    Icons.restaurant,
    Icons.local_cafe,
    Icons.movie,
    Icons.music_note,
    Icons.beach_access,
    Icons.flight,
    Icons.directions_car,
    Icons.shopping_cart,
    Icons.computer,
    Icons.phone_android,
    Icons.laptop,
    Icons.watch,
    Icons.tv,
    Icons.gamepad,
    Icons.book,
    Icons.brush,
    Icons.camera,
    Icons.fitness_center,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E6D3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF6B4423), width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Create Custom Tag',
              style: TextStyle(
                fontFamily: 'Questrial',
                color: Color(0xFF6B4423),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Tag Name Input
            TextField(
              controller: _nameController,
              maxLength: 20,
              style: const TextStyle(
                fontFamily: 'Questrial',
                color: Color(0xFF6B4423),
              ),
              decoration: InputDecoration(
                labelText: 'Tag Name',
                labelStyle: const TextStyle(
                  fontFamily: 'Questrial',
                  color: Color(0xFF6B4423),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6B4423), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6B4423), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6B4423), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6B4423), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_selectedIcon, color: Colors.white, size: 30),
                  const SizedBox(width: 12),
                  Text(
                    _nameController.text.isEmpty ? 'Preview' : _nameController.text,
                    style: const TextStyle(
                      fontFamily: 'Questrial',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Color Picker
            const Text(
              'Choose Color',
              style: TextStyle(
                fontFamily: 'Questrial',
                color: Color(0xFF6B4423),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _availableColors.length,
                itemBuilder: (context, index) {
                  final color = _availableColors[index];
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF6B4423) : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Icon Picker
            const Text(
              'Choose Icon',
              style: TextStyle(
                fontFamily: 'Questrial',
                color: Color(0xFF6B4423),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 150),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF6B4423), width: 2),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _availableIcons[index];
                    final isSelected = icon == _selectedIcon;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? _selectedColor : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF6B4423) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? Colors.white : const Color(0xFF6B4423),
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      color: Color(0xFF8B6443),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a tag name'),
                          backgroundColor: Color(0xFF6B4423),
                        ),
                      );
                      return;
                    }
                    widget.onTagCreated(name, _selectedColor, _selectedIcon);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4423),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}