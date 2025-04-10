import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import 'form_field_container.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final Function()? onChanged;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldContainer(
      errorText: errorText,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.grey300),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onTap: () => _showDatePicker(context),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    DateTime initialDate;
    try {
      initialDate = DateFormat('dd-MM-yyyy').parse(controller.text);
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.orange,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.orange),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      controller.text = formattedDate;
      if (onChanged != null) {
        onChanged!();
      }
    }
  }
}
