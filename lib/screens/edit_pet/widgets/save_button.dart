import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SaveButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const SaveButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
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
              'Salva',
              style: TextStyle(
                color: isEnabled ? Colors.white : AppColors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
