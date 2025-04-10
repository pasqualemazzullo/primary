import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../theme/app_colors.dart';

class ProfessionalCard extends StatelessWidget {
  final Map<String, dynamic> professional;
  final VoidCallback onRemoveAssociation;
  final VoidCallback onTap;

  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.onRemoveAssociation,
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
        leading: _buildProfessionalAvatar(),
        title: Text(
          professional['name'] ?? 'Senza nome',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        subtitle: Text(
          professional['specialty'] ?? 'Specialità non specificata',
          style: const TextStyle(color: AppColors.grey600),
        ),
        trailing: _buildNavigationButton(),
        onTap: onTap,
      ),
    );
  }

  Widget _buildProfessionalAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundImage:
          professional['imagePath'] != null
              ? FileImage(File(professional['imagePath']))
              : const AssetImage('assets/image_placeholder.png')
                  as ImageProvider,
    );
  }

  Widget _buildNavigationButton() {
    return IconButton(
      icon: const Icon(LucideIcons.arrowRight, color: Colors.white, size: 24),
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.orange,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.orange, width: 1),
        ),
      ),
    );
  }
}
