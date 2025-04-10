import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class GenderSelector extends StatelessWidget {
  final int? selectedGender;
  final ValueChanged<int> onGenderChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTabOption(context, 0, 'Maschio'),
        const SizedBox(width: 12),
        _buildTabOption(context, 1, 'Femmina'),
      ],
    );
  }

  Widget _buildTabOption(BuildContext context, int index, String label) {
    final isSelected = selectedGender == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onGenderChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orange : Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.orange : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
