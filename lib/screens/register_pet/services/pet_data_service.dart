import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../providers/register_pet_provider.dart';

class PetDataService {
  Future<void> savePetData(RegisterPetProvider petProvider) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pet_data.json');

    int newId = 1;

    try {
      List<dynamic> existingPets = await _getPetsFromFile(file);

      if (existingPets.isNotEmpty) {
        newId =
            existingPets
                .map<int>((pet) => pet['id'] as int)
                .reduce((value, element) => value > element ? value : element) +
            1;
      }

      final Map<String, dynamic> petData = {
        'id': newId,
        'petName': petProvider.petName,
        'gender': petProvider.gender,
        'birthDate': petProvider.birthDate.toIso8601String(),
        'category': petProvider.category,
        'petBreed': petProvider.petBreed,
        'petColor': petProvider.petColor,
        'isFavorite': false,
      };

      existingPets.add(petData);

      await file.writeAsString(jsonEncode(existingPets));
    } catch (e) {
      // Non succede niente.
    }
  }

  Future<List<dynamic>> _getPetsFromFile(File file) async {
    try {
      if (await file.exists()) {
        final String fileData = await file.readAsString();
        return jsonDecode(fileData);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
