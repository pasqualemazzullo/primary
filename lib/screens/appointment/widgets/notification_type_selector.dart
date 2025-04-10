import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../models/notification_type.dart';

class NotificationTypeSelector extends StatelessWidget {
  final NotificationType selectedType;
  final ValueChanged<NotificationType> onChanged;

  const NotificationTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          RadioListTile<NotificationType>(
            title: const Text('Giorni/ore prima'),
            value: NotificationType.daysAndHours,
            groupValue: selectedType,
            activeColor: AppColors.orange,
            onChanged: (value) => onChanged(value!),
          ),
          const Divider(height: 1, color: AppColors.grey300),
          RadioListTile<NotificationType>(
            title: const Text('Minuti prima (stesso giorno)'),
            value: NotificationType.minutes,
            groupValue: selectedType,
            activeColor: AppColors.orange,
            onChanged: (value) => onChanged(value!),
          ),
        ],
      ),
    );
  }
}
