import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class WelcomeDialogs {
  static void showDevelopmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.orangeLight,
          title: const Text(
            'Quasi pronto per i tuoi pelosetti!',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Stiamo perfezionando questa funzionalità per dare il meglio a te e ai tuoi amichetti.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Chiudi',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  WelcomeDialogs._();
}
