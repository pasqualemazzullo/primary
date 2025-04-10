import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../pet_detail/pet_detail_screen.dart';

class FavoritesService {
  Future<List<Map<String, dynamic>>> loadFavoritePets() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final String fileData = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);

        final List<dynamic> favPets =
            jsonData.where((pet) => pet['isFavorite'] == true).toList();
        return List<Map<String, dynamic>>.from(favPets);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> removeFavorite(int petId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final String fileData = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);

        final index = jsonData.indexWhere((pet) => pet['id'] == petId);

        if (index != -1) {
          jsonData[index]['isFavorite'] = false;
          await file.writeAsString(jsonEncode(jsonData));
        }
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  Future<void> navigateToPetDetail(BuildContext context, int petId) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailScreen(petId: petId)),
    );
  }

  Future<bool> fileExists(String path) async {
    final file = File(path);
    return await file.exists();
  }
}
