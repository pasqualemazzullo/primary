import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'custom_button.dart';
import '../../../../theme/app_colors.dart';

class DeleteButton extends StatelessWidget {
  final Function() onDeleteConfirmed;

  const DeleteButton({super.key, required this.onDeleteConfirmed});

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.orangeLight,
          title: const Text(
            'Sei sicuro di voler eliminare questo appuntamento?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text('L\'azione non può essere annullata.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Annulla',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Elimina',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      onDeleteConfirmed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        icon: LucideIcons.trash2,
        label: 'Elimina appuntamento',
        onPressed: () => _showDeleteConfirmationDialog(context),
        backgroundColor: Colors.red,
        fullWidth: true,
      ),
    );
  }
}
