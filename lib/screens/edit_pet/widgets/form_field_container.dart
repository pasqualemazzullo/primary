import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class FormFieldContainer extends StatelessWidget {
  final Widget child;
  final String? errorText;

  const FormFieldContainer({super.key, required this.child, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  errorText != null ? Colors.red.shade300 : AppColors.grey300,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 16),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
