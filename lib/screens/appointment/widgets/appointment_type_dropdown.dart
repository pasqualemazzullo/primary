import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../models/appointment_type_data.dart';

class AppointmentTypeDropdown extends StatelessWidget {
  final String? selectedType;
  final List<AppointmentTypeData> types;
  final ValueChanged<String?> onChanged;

  const AppointmentTypeDropdown({
    super.key,
    required this.selectedType,
    required this.types,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedType,
        hint: const Text(
          'Seleziona un tipo',
          style: TextStyle(
            color: AppColors.grey300,
            fontFamily: 'Quicksand',
            fontSize: 16,
          ),
        ),
        isExpanded: true,
        dropdownColor: AppColors.orangeLight,
        items:
            types.map((type) {
              return DropdownMenuItem<String>(
                value: type.name,
                child: Row(
                  children: [
                    Icon(type.icon, color: AppColors.orange),
                    const SizedBox(width: 10),
                    Text(
                      type.name,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Quicksand',
          fontSize: 16,
        ),
      ),
    );
  }
}
