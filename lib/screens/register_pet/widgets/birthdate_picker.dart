import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import '../../../providers/register_pet_provider.dart';
import '../utils/date_formatter.dart';

class BirthdatePicker extends StatelessWidget {
  const BirthdatePicker({super.key});

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

    if (pickedDate != null && context.mounted) {
      Provider.of<RegisterPetProvider>(context, listen: false).birthDate =
          pickedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<RegisterPetProvider>(context);

    return GestureDetector(
      onTap: () => _selectBirthDate(context),
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: TextEditingController(
              text: DateFormatter.formatDate(petProvider.birthDate),
            ),
            readOnly: true,
            decoration: const InputDecoration(
              hintText: 'Seleziona la data',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
