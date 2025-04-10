import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/app_colors.dart';
import '../../../screens/register_pet/screens/register_pet_1_screen.dart';

class EmptyPetsView extends StatelessWidget {
  const EmptyPetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterPet1Screen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.all(20),
              shape: const CircleBorder(),
            ),
            child: Icon(LucideIcons.plus, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 24),
          Text(
            'Qui le cucce sono tutte vuote!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Clicca sul + per aggiungere il tuo primo animale domestico.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}
