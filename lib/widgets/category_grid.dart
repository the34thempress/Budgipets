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
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat['icon'], color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(cat['name'], style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
