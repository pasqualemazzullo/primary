import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CategoriesHorizontalModel extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String?) onCategorySelected;

  const CategoriesHorizontalModel({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  CategoriesHorizontalModelState createState() =>
      CategoriesHorizontalModelState();
}

class CategoriesHorizontalModelState extends State<CategoriesHorizontalModel> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final List<Category> categoryObjects =
        widget.categories.map((data) {
          return Category(
            icon: data['icon'],
            label: data['label'],
            color: data['color'],
          );
        }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categoryObjects.map((category) {
              final bool isSelected = category.label == selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 22),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedCategory = null;
                      } else {
                        selectedCategory = category.label;
                      }
                    });
                    widget.onCategorySelected(selectedCategory);
                  },
                  child: _CategoryItem(
                    icon: category.icon,
                    label: category.label,
                    color: category.color,
                    isSelected: isSelected,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.orange : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(child: Icon(icon, size: 24)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.orange : AppColors.grey600,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class Category {
  final IconData icon;
  final String label;
  final Color color;

  Category({required this.icon, required this.label, required this.color});
}
