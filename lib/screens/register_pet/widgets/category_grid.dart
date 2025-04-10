import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import '../../../providers/register_pet_provider.dart';
import '../../../widgets/categories_list.dart';

class CategoryGrid extends StatefulWidget {
  final Function(bool) onSelectionChanged;

  const CategoryGrid({super.key, required this.onSelectionChanged});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  int? _selectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 1.2,
      ),
      itemCount: animalCategories.length,
      itemBuilder: (context, index) {
        final category = animalCategories[index];
        final bool isSelected = _selectedCategoryIndex == index;

        return GestureDetector(
          onTap: () => _selectCategory(index, category['label']),
          child: _buildCategoryItem(category, isSelected),
        );
      },
    );
  }

  void _selectCategory(int index, String categoryLabel) {
    setState(() {
      _selectedCategoryIndex = _selectedCategoryIndex == index ? null : index;

      final bool isSelected = _selectedCategoryIndex != null;
      widget.onSelectionChanged(isSelected);

      if (isSelected) {
        Provider.of<RegisterPetProvider>(context, listen: false).category =
            categoryLabel;
      } else {
        Provider.of<RegisterPetProvider>(context, listen: false).category =
            null;
      }
    });
  }

  Widget _buildCategoryItem(Map<String, dynamic> category, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category['color'],
            border:
                isSelected
                    ? Border.all(color: AppColors.orange, width: 1.5)
                    : null,
          ),
          child: Icon(category['icon']),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            category['label'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.orange : AppColors.grey600,
            ),
          ),
        ),
      ],
    );
  }
}
