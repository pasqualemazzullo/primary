import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models/pet.dart';
import 'common_card.dart';
import '../../../../theme/app_colors.dart';

class PatientCard extends StatelessWidget {
  final Pet pet;

  const PatientCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      title: 'Animale',
      icon: LucideIcons.pawPrint,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.orangeLight,
            child: _buildPetImage(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  pet.breed ?? 'Razza non specificata',
                  style: const TextStyle(
                    color: AppColors.grey600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetImage() {
    final petImagePath = pet.imagePath ?? '';

    if (petImagePath.isEmpty) {
      return Image.asset('assets/image_placeholder.png', fit: BoxFit.cover);
    }

    if (petImagePath.startsWith('/') || petImagePath.startsWith('file://')) {
      return ClipOval(
        child: Image.file(
          File(petImagePath),
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/image_placeholder.png',
              fit: BoxFit.cover,
            );
          },
        ),
      );
    } else {
      return Image.asset(
        petImagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/image_placeholder.png', fit: BoxFit.cover);
        },
      );
    }
  }
}
