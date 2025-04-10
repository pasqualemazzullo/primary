import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../screens/pet_detail/pet_detail_screen.dart';

class PetCardWidget extends StatelessWidget {
  final String? name;
  final String? breed;
  final String? age;
  final String? distance;
  final String? imageUrl;
  final int? gender;
  final int petId;

  const PetCardWidget({
    super.key,
    required this.petId,
    this.name,
    this.breed,
    this.age,
    this.distance,
    this.imageUrl,
    this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final String displayName = name?.isNotEmpty == true ? name! : 'Sconosciuto';
    final String displayBreed =
        breed?.isNotEmpty == true ? breed! : 'Sconosciuto';
    final String displayAge =
        age?.isNotEmpty == true ? age! : 'Età sconosciuta';
    final String displayDistance =
        distance?.isNotEmpty == true ? distance! : 'Nessun GPS';
    final String displayImage =
        imageUrl?.isNotEmpty == true
            ? imageUrl!
            : 'assets/image_placeholder.png';
    final int displayGender = gender ?? 2;

    Widget imageWidget;
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        !imageUrl!.startsWith('assets/')) {
      imageWidget = Image.file(
        File(imageUrl!),
        width: double.infinity,
        height: 230,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/image_placeholder.png',
            width: double.infinity,
            height: 230,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      imageWidget = Image.asset(
        displayImage,
        width: double.infinity,
        height: 230,
        fit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailScreen(petId: petId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: imageWidget,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayBreed,
                      style: TextStyle(
                        color: AppColors.grey600.withAlpha(153),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getGenderIcon(displayGender),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(LucideIcons.mapPin, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  displayDistance,
                  style: TextStyle(
                    color: AppColors.grey600.withAlpha(153),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  displayAge,
                  style: TextStyle(
                    color: AppColors.grey600.withAlpha(153),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getGenderIcon(int gender) {
    switch (gender) {
      case 0:
        return LucideIcons.mars;
      case 1:
        return LucideIcons.venus;
      default:
        return LucideIcons.circleHelp;
    }
  }
}
