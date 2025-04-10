import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../professional_detail_screen.dart';
import '../professional_edit_screen.dart';

class AssociatedProfessionalsService {
  static const String petDataFileName = 'pet_data.json';

  Future<List<Map<String, dynamic>>> loadAllPets() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$petDataFileName');

      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> loadAssociatedProfessionals() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$petDataFileName');

      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsJson = jsonDecode(jsonString);

      final Map<int, Map<String, dynamic>> professionalsMap = {};

      for (var pet in petsJson) {
        final List<dynamic> professionals = pet['professionals'] ?? [];
        final Map<String, dynamic> professionalDetails =
            pet['professionalDetails'] ?? {};

        for (var professionalId in professionals) {
          if (professionalId is int) {
            final String profIdString = professionalId.toString();

            if (!professionalsMap.containsKey(professionalId) &&
                professionalDetails.containsKey(profIdString)) {
              final proDetails = professionalDetails[profIdString];

              if (proDetails is Map<String, dynamic>) {
                professionalsMap[professionalId] = Map<String, dynamic>.from(
                  proDetails,
                );
                professionalsMap[professionalId]!['associatedPets'] = [];
              } else {
                professionalsMap[professionalId] = {
                  'id': professionalId,
                  'name': 'Professionista $professionalId',
                  'specialty': 'Specialità non specificata',
                  'contactInfo': '',
                  'email': '',
                  'location': {
                    'name': '',
                    'address': '',
                    'coordinates': {'lat': 0.0, 'lng': 0.0},
                  },
                  'associatedPets': [],
                };
              }
            }

            if (professionalsMap.containsKey(professionalId)) {
              final petInfo = {'id': pet['id'], 'name': pet['petName']};

              if (!professionalsMap[professionalId]!['associatedPets'].contains(
                petInfo,
              )) {
                professionalsMap[professionalId]!['associatedPets'].add(
                  petInfo,
                );
              }
            }
          }
        }
      }

      final professionals = professionalsMap.values.toList();
      professionals.sort(
        (a, b) => (a['name'] ?? '').toString().compareTo(
          (b['name'] ?? '').toString(),
        ),
      );

      return professionals;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getProfessionalDetails(
    int professionalId,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$petDataFileName');

      if (!await file.exists()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsJson = jsonDecode(jsonString);

      Map<String, dynamic>? professionalData;
      List<int> associatedPetIds = [];

      for (var pet in petsJson) {
        final List<dynamic> professionals = pet['professionals'] ?? [];

        if (professionals.contains(professionalId)) {
          associatedPetIds.add(pet['id']);

          final professionalDetails = pet['professionalDetails'];
          if (professionalDetails != null &&
              professionalDetails['$professionalId'] != null) {
            professionalData = Map<String, dynamic>.from(
              professionalDetails['$professionalId'],
            );
            break;
          }
        }
      }

      if (professionalData != null) {
        professionalData['associatedPets'] = associatedPetIds;
        return professionalData;
      }

      if (associatedPetIds.isNotEmpty) {
        return {
          'id': professionalId,
          'name': 'Professionista $professionalId',
          'specialty': 'Specialità non specificata',
          'contactInfo': '',
          'email': '',
          'location': {
            'name': '',
            'address': '',
            'coordinates': {'lat': 0.0, 'lng': 0.0},
          },
          'associatedPets': associatedPetIds,
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> removeAssociation(int professionalId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$petDataFileName');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> petsJson = jsonDecode(jsonString);
        bool dataChanged = false;

        for (var pet in petsJson) {
          final List<dynamic> professionals = pet['professionals'] ?? [];

          if (professionals.contains(professionalId)) {
            professionals.remove(professionalId);
            pet['professionals'] = professionals;

            if (pet['professionalDetails'] != null &&
                pet['professionalDetails']['$professionalId'] != null) {
              pet['professionalDetails'].remove('$professionalId');
            }

            dataChanged = true;
          }
        }

        if (dataChanged) {
          await file.writeAsString(jsonEncode(petsJson));
        }
      }
    } catch (e) {
      throw Exception('Impossibile rimuovere l\'associazione: $e');
    }
  }

  Future<void> deleteProfessional(int professionalId) async {
    await removeAssociation(professionalId);
  }

  Future<dynamic> navigateToProfessionalDetail(
    BuildContext context,
    int professionalId,
  ) async {
    if (context.mounted) {
      return Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) =>
                  ProfessionalDetailScreen(professionalId: professionalId),
        ),
      );
    }
    return null;
  }

  Future<bool?> navigateToProfessionalEdit(
    BuildContext context,
    int? professionalId,
  ) async {
    if (context.mounted) {
      return Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder:
              (context) =>
                  ProfessionalEditScreen(professionalId: professionalId),
        ),
      );
    }
    return null;
  }

  Future<bool> addProfessional(Map<String, dynamic> professionalData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$petDataFileName');

      if (!await file.exists()) {
        return false;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsJson = jsonDecode(jsonString);
      bool dataChanged = false;

      final int professionalId = professionalData['id'];
      final List<dynamic> associatedPetIds =
          professionalData['associatedPets'] ?? [];

      for (var pet in petsJson) {
        final int petId = pet['id'];
        final List<dynamic> professionals = pet['professionals'] ?? [];
        final bool isSelected = associatedPetIds.contains(petId);

        if (pet['professionalDetails'] == null) {
          pet['professionalDetails'] = {};
        }

        if (isSelected) {
          if (!professionals.contains(professionalId)) {
            professionals.add(professionalId);
            pet['professionals'] = professionals;
            dataChanged = true;
          }

          pet['professionalDetails']['$professionalId'] = professionalData;
          dataChanged = true;
        } else if (professionals.contains(professionalId)) {
          professionals.remove(professionalId);
          pet['professionals'] = professionals;

          if (pet['professionalDetails']['$professionalId'] != null) {
            pet['professionalDetails'].remove('$professionalId');
          }

          dataChanged = true;
        }
      }

      if (dataChanged) {
        await file.writeAsString(jsonEncode(petsJson));
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfessional(
    int professionalId,
    Map<String, dynamic> professionalData,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$petDataFileName');

      if (!await file.exists()) {
        return false;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsJson = jsonDecode(jsonString);
      bool dataChanged = false;

      final List<dynamic> newAssociatedPetIds =
          professionalData['associatedPets'] ?? [];

      for (var pet in petsJson) {
        final int petId = pet['id'];
        final List<dynamic> professionals = pet['professionals'] ?? [];
        final bool shouldBeAssociated = newAssociatedPetIds.contains(petId);
        final bool isCurrentlyAssociated = professionals.contains(
          professionalId,
        );

        if (pet['professionalDetails'] == null) {
          pet['professionalDetails'] = {};
        }

        if (shouldBeAssociated) {
          if (!isCurrentlyAssociated) {
            professionals.add(professionalId);
            pet['professionals'] = professionals;
            dataChanged = true;
          }

          pet['professionalDetails']['$professionalId'] = professionalData;
          dataChanged = true;
        } else if (isCurrentlyAssociated) {
          professionals.remove(professionalId);
          pet['professionals'] = professionals;

          if (pet['professionalDetails']['$professionalId'] != null) {
            pet['professionalDetails'].remove('$professionalId');
          }

          dataChanged = true;
        }
      }

      if (dataChanged) {
        await file.writeAsString(jsonEncode(petsJson));
        return true;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
