import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PetUpdateService {
  static Future<bool> updatePet(Map<String, dynamic> updatedPetData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List petList = json.decode(jsonString);

        final index = petList.indexWhere(
          (pet) => pet['id'] == updatedPetData['id'],
        );

        if (index != -1) {
          petList[index] = updatedPetData;
          await file.writeAsString(json.encode(petList));
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
