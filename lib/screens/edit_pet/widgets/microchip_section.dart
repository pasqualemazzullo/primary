import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import 'date_picker_field.dart';
import 'form_field_container.dart';

class MicrochipSection extends StatelessWidget {
  final bool hasMicrochip;
  final ValueChanged<bool> onMicrochipToggled;
  final TextEditingController providerController;
  final TextEditingController numberController;
  final TextEditingController dateController;
  final String? providerError;
  final String? numberError;
  final String? dateError;
  final VoidCallback onDateChanged;

  const MicrochipSection({
    super.key,
    required this.hasMicrochip,
    required this.onMicrochipToggled,
    required this.providerController,
    required this.numberController,
    required this.dateController,
    this.providerError,
    this.numberError,
    this.dateError,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Divider(color: AppColors.grey300, thickness: 1),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Microchip',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Switch(
              value: hasMicrochip,
              onChanged: onMicrochipToggled,
              activeColor: AppColors.orange,
            ),
          ],
        ),

        if (hasMicrochip) ...[
          const SizedBox(height: 16),
          _buildMicrochipFields(context),
        ],
      ],
    );
  }

  Widget _buildMicrochipFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fornitore microchip',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        FormFieldContainer(
          errorText: providerError,
          child: TextFormField(
            controller: providerController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Es. Animal id, Virbac...',
              hintStyle: TextStyle(color: AppColors.grey300),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Numero microchip',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        FormFieldContainer(
          errorText: numberError,
          child: TextFormField(
            controller: numberController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: '123456789012345',
              hintStyle: TextStyle(color: AppColors.grey300),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Data inserimento microchip',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        DatePickerField(
          controller: dateController,
          hintText: 'gg-mm-aaaa',
          errorText: dateError,
          onChanged: onDateChanged,
        ),
      ],
    );
  }
}
