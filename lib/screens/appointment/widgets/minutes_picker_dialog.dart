import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class MinutesPickerDialog extends StatefulWidget {
  final int initialMinutes;
  final List<int> presetOptions;
  final Function(int) onConfirm;

  const MinutesPickerDialog({
    super.key,
    required this.initialMinutes,
    required this.presetOptions,
    required this.onConfirm,
  });

  @override
  State<MinutesPickerDialog> createState() => _MinutesPickerDialogState();
}

class _MinutesPickerDialogState extends State<MinutesPickerDialog> {
  late int selectedMinutes;

  @override
  void initState() {
    super.initState();
    selectedMinutes = widget.initialMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.orangeLight,
      title: const Text('Minuti prima'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    widget.presetOptions.map((minutes) {
                      final isSelected = minutes == selectedMinutes;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMinutes = minutes;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.orange : Colors.white,
                            border: Border.all(color: AppColors.orange),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$minutes min',
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : AppColors.orange,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Oppure inserisci un valore personalizzato:'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed:
                        selectedMinutes > 1
                            ? () => setState(() => selectedMinutes--)
                            : null,
                    color: AppColors.orange,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '$selectedMinutes',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed:
                        selectedMinutes < 120
                            ? () => setState(() => selectedMinutes++)
                            : null,
                    color: AppColors.orange,
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          child: const Text(
            'Annulla',
            style: TextStyle(color: AppColors.orange),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text(
            'Conferma',
            style: TextStyle(color: AppColors.orange),
          ),
          onPressed: () {
            widget.onConfirm(selectedMinutes);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
