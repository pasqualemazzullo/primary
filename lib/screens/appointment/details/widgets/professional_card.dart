import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models/professional.dart';
import 'common_card.dart';
import 'custom_button.dart';
import '../../utils/url_launcher_utils.dart';
import '../../../../theme/app_colors.dart';

class ProfessionalCard extends StatelessWidget {
  final Professional professional;

  const ProfessionalCard({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      title: 'Professionista',
      icon: LucideIcons.userRound,
      content: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: _getProfileImage(),
                backgroundColor: AppColors.orangeLight,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      professional.specialty,
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
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  icon: LucideIcons.phone,
                  label: 'Chiama',
                  onPressed:
                      professional.contactInfo != null
                          ? () => UrlLauncherUtils.makePhoneCall(
                            professional.contactInfo!,
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  icon: LucideIcons.mail,
                  label: 'Email',
                  onPressed:
                      professional.email != null
                          ? () =>
                              UrlLauncherUtils.sendEmail(professional.email!)
                          : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (professional.imagePath != null &&
        File(professional.imagePath!).existsSync()) {
      return FileImage(File(professional.imagePath!));
    }

    return const AssetImage('assets/image_placeholder.png');
  }
}
