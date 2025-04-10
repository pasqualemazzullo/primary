import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final Color backgroundColor;

  const CustomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
    this.backgroundColor = AppColors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          size: 18,
          color: onPressed == null ? Colors.grey : Colors.white,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: onPressed == null ? Colors.grey : Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              onPressed == null ? Colors.grey.shade200 : backgroundColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
