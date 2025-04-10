import 'package:flutter/material.dart';
import '../../../providers/register_pet_provider.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildGenderOption(context, 0, 'Maschio'),
        const SizedBox(width: 12),
        _buildGenderOption(context, 1, 'Femmina'),
      ],
    );
  }

  Widget _buildGenderOption(BuildContext context, int index, String label) {
    final isSelected =
        Provider.of<RegisterPetProvider>(context).gender == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<RegisterPetProvider>(context, listen: false).gender =
              index;
        },
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
