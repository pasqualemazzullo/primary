import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class IconBox extends StatelessWidget {
  final IconData icon;

  const IconBox({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.orangeLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.orange, size: 24),
    );
  }
}
