import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models/location.dart';
import 'common_card.dart';
import 'icon_box.dart';
import 'custom_button.dart';
import '../../utils/url_launcher_utils.dart';
import '../../../../theme/app_colors.dart';

class LocationCard extends StatelessWidget {
  final Location location;

  const LocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      title: 'Luogo',
      icon: LucideIcons.mapPin,
      content: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBox(icon: LucideIcons.building),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      location.address,
                      style: const TextStyle(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            icon: LucideIcons.map,
            label: 'Apri su Google Maps',
            onPressed:
                () => UrlLauncherUtils.openMapsByAddress(
                  location.name,
                  location.address,
                ),
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}
