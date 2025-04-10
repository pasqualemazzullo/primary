import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SterilizedSelector extends StatelessWidget {
  final bool? isSelected;
  final ValueChanged<bool> onSelectionChanged;

  const SterilizedSelector({
    super.key,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildOption(context, true, 'Sì'),
        const SizedBox(width: 12),
        _buildOption(context, false, 'No'),
      ],
    );
  }

  Widget _buildOption(BuildContext context, bool value, String label) {
    final isOptionSelected = isSelected == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelectionChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isOptionSelected ? AppColors.orange : Colors.white,
            border: Border.all(
              color: isOptionSelected ? AppColors.orange : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isOptionSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
