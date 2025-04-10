import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_colors.dart';
import 'data_manager.dart';
import '../profile/professionals/professional_edit_screen.dart';
import '../profile/professionals/professional_detail_screen.dart';

mixin PetUIComponents<T extends StatefulWidget> on State<T>, PetDataManager<T> {
  Widget buildInfoBox(String title, String value, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 11, color: AppColors.grey600)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildMicrochipSection() {
    final hasMicrochip = petData?['hasMicrochip'] ?? false;

    if (!hasMicrochip) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        Row(
          children: [
            Icon(LucideIcons.microchip, color: AppColors.orange, size: 14),
            const SizedBox(width: 8),
            const Text(
              'Informazioni Microchip',
              style: TextStyle(fontSize: 14, color: AppColors.grey600),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildInfoBox(
              'Fornitore',
              petData?['microchipProvider'] ?? 'N/A',
              Colors.teal.shade100,
            ),
            const SizedBox(height: 10),
            buildInfoBox(
              'Numero',
              petData?['microchipNumber'] ?? 'N/A',
              Colors.purple.shade100,
            ),
            const SizedBox(height: 10),
            buildInfoBox(
              'Data Inserimento',
              formatDate(petData?['microchipDate']),
              Colors.indigo.shade100,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBasicInfoSection() {
    return Row(
      children: [
        Expanded(
          child: buildInfoBox(
            'Età',
            calculateAge(petData?['birthDate']) ?? '1 Anno',
            Colors.blue.shade100,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildInfoBox(
            'Sesso',
            getGenderText(petData?['gender']),
            Colors.green.shade100,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildInfoBox(
            'Razza',
            petData?['petBreed'] ?? 'Non specificata',
            Colors.red.shade100,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildInfoBox(
            'Sterilizzato',
            petData?['isSterilized'] == true ? '✓' : '✗',
            Colors.amber.shade100,
          ),
        ),
      ],
    );
  }

  Widget buildVeterinarianSection() {
    if (petData?['professionals'] == null ||
        (petData?['professionals'] as List).isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.stethoscope,
                    color: AppColors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Professionisti associati',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfessionalEditScreen(),
                    ),
                  ).then((result) {
                    if (result == true) {
                      loadPetDetails();
                    }
                  });
                },
                icon: Icon(LucideIcons.plus, color: AppColors.orange, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.orangeLight.withValues(alpha: 0.3),
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.stethoscope,
                  color: AppColors.grey600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nessun professionista associato',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Associa un professionista al tuo animale',
                        style: TextStyle(
                          color: AppColors.grey600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    }

    final List<dynamic> professionalIds = petData!['professionals'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.stethoscope,
                  color: AppColors.orange,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Professionisti associati',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfessionalEditScreen(),
                  ),
                ).then((result) {
                  if (result == true) {
                    loadPetDetails();
                  }
                });
              },
              icon: Icon(LucideIcons.plus, color: AppColors.orange, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.orangeLight.withValues(alpha: 0.3),
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Column(
          children:
              professionalIds.map<Widget>((professionalId) {
                final professional = getProfessionalDetails(professionalId);

                if (professional == null) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            LucideIcons.triangleAlert,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Professionista non trovato",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final String name =
                    professional['name'] ?? 'Nome non disponibile';
                final String specialty =
                    professional['specialty'] ?? 'Specialità non specificata';

                Color bgColor;
                switch (specialty.toLowerCase()) {
                  case 'veterinario':
                    bgColor = Colors.blue.shade100;
                    break;
                  case 'toelettatore':
                    bgColor = Colors.green.shade100;
                    break;
                  case 'pet sitter':
                    bgColor = Colors.purple.shade100;
                    break;
                  default:
                    bgColor = Colors.amber.shade100;
                }

                IconData specialtyIcon;
                switch (specialty.toLowerCase()) {
                  case 'veterinario':
                    specialtyIcon = LucideIcons.stethoscope;
                    break;
                  case 'toelettatore':
                    specialtyIcon = LucideIcons.scissors;
                    break;
                  case 'pet sitter':
                    specialtyIcon = LucideIcons.house;
                    break;
                  default:
                    specialtyIcon = LucideIcons.userCheck;
                }

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProfessionalDetailScreen(
                              professionalId: professionalId,
                            ),
                      ),
                    ).then((result) {
                      if (result == true) {
                        loadPetDetails();
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              specialtyIcon,
                              color: AppColors.orange,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  specialty,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            color: AppColors.orange,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.mapPin, color: AppColors.orange, size: 14),
            const SizedBox(width: 8),
            Text(
              'Località',
              style: TextStyle(fontSize: 14, color: AppColors.grey600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Nessun GPS',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildPetNotFoundUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.triangleAlert, size: 48, color: AppColors.grey600),
          const SizedBox(height: 16),
          Text(
            'Animale non trovato',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Torna indietro'),
          ),
        ],
      ),
    );
  }
}
