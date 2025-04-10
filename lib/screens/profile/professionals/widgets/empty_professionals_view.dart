import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../theme/app_colors.dart';

class EmptyProfessionalsView extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const EmptyProfessionalsView({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onAddPressed,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.all(20),
              shape: const CircleBorder(),
            ),
            child: const Icon(LucideIcons.plus, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 24),
          Text(
            'Nessun professionista associato',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Clicca sul + per aggiungere il tuo primo professionista.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}
