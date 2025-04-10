import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class NumberSelectorDialog extends StatefulWidget {
  final String title;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final Function(int) onConfirm;

  const NumberSelectorDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onConfirm,
  });

  @override
  State<NumberSelectorDialog> createState() => _NumberSelectorDialogState();
}

class _NumberSelectorDialogState extends State<NumberSelectorDialog> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.orangeLight,
      title: Text(widget.title),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed:
                        selectedValue > widget.minValue
                            ? () => setState(() => selectedValue--)
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
                      '$selectedValue',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed:
                        selectedValue < widget.maxValue
                            ? () => setState(() => selectedValue++)
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
            widget.onConfirm(selectedValue);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
