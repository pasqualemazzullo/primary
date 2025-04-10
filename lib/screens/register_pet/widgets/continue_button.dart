import 'package:flutter/material.dart';
import '../../../providers/register_pet_provider.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinueButton({
    super.key,
    required this.onPressed,
    required bool isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<RegisterPetProvider>(context);
    final bool isEnabled =
        petProvider.petName.isNotEmpty && petProvider.gender != -1;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isEnabled ? AppColors.orange : AppColors.grey300,
          ),
          borderRadius: BorderRadius.circular(30),
          color: isEnabled ? AppColors.orange : AppColors.lightGrey,
        ),
        child: Center(
          child: Text(
            'Continua',
            style: TextStyle(
              color: isEnabled ? Colors.white : AppColors.orange,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
