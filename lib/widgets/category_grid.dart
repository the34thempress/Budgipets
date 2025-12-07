import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final Function(String) onSelect;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  });

  // Helper method to create a darker shade of a color
  Color darkenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

//to make sure 2 tags per row
    final double itemWidth = (screenWidth - 60) / 2;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((cat) {
        final isSelected = selectedCategory == cat['name'];
        return GestureDetector(
          onTap: () => onSelect(cat['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: itemWidth,
            height: 55,
            decoration: BoxDecoration(
              color: isSelected ? cat['color'].withOpacity(0.8) : cat['color'],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: darkenColor(cat['color']),
                width: isSelected ? 4 : 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat['icon'], color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  cat['name'],
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontFamily: 'Questrial',
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}