import 'package:flutter/material.dart';

class CategoryScrollMenu extends StatefulWidget {
  const CategoryScrollMenu({super.key});

  @override
  State<CategoryScrollMenu> createState() => _CategoryScrollMenuState();
}

class _CategoryScrollMenuState extends State<CategoryScrollMenu> {
  final List<String> categories = [
    'All',
    'Self-Contain',
    'Apartments',
    'Hotel rooms',
    'Real E',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isLast = index == categories.length - 1;
          final isActive = selectedIndex == index;

          return Container(
            margin: isLast ? const EdgeInsets.only(right: 16) : null,
            decoration: BoxDecoration(
              color: isActive ? Colors.yellow : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
