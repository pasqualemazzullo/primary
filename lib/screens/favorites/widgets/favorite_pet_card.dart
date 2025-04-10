import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/app_colors.dart';

class FavoritePetCard extends StatelessWidget {
  final Map<String, dynamic> pet;
  final VoidCallback onRemoveFavorite;
  final VoidCallback onTap;

  const FavoritePetCard({
    super.key,
    required this.pet,
    required this.onRemoveFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300,
            offset: Offset(0, 0),
            blurRadius: 50,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        leading: _buildPetAvatar(),
        title: Text(
          pet['petName'] ?? 'Senza nome',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        subtitle: Text(
          pet['petBreed'] ?? 'Razza non specificata',
          style: const TextStyle(color: AppColors.grey600),
        ),
        trailing: _buildFavoriteButton(),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPetAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundImage:
          pet['petImagePath'] != null
              ? FileImage(File(pet['petImagePath']))
              : const AssetImage('assets/image_placeholder.png')
                  as ImageProvider,
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      icon: const Icon(LucideIcons.heart, color: Colors.white, size: 28),
      onPressed: onRemoveFavorite,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.orange,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.orange, width: 1),
        ),
      ),
    );
  }
}
