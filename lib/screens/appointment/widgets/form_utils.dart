import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class FormUtils {
  static Widget buildFormField({
    required String label,
    required Widget field,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        field,
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 16),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget buildInputContainer({
    required Widget child,
    String? errorText,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: errorText != null ? Colors.red.shade300 : AppColors.grey300,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }
}
