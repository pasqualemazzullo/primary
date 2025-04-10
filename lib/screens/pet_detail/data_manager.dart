import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

mixin PetDataManager<T extends StatefulWidget> on State<T> {
  Map<String, dynamic>? _petData;
  bool _isLoading = true;
  String? _petImagePath;
  bool _isFavorite = false;
  late int petId;

  Map<String, dynamic>? get petData => _petData;
  bool get isLoading => _isLoading;
  String? get petImagePath => _petImagePath;
  bool get isFavorite => _isFavorite;

  Map<String, dynamic>? getProfessionalDetails(int professionalId) {
    if (_petData == null || _petData!['professionalDetails'] == null) {
      return null;
    }

    final professionalIdStr = professionalId.toString();

    final professionalDetails =
        _petData!['professionalDetails'] as Map<String, dynamic>;

    return professionalDetails[professionalIdStr];
  }

  Future<void> loadPetDetails() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final String fileData = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);

        final pet = jsonData.firstWhere(
          (pet) => pet['id'] == petId,
          orElse: () => null,
        );

        if (!mounted) return;

        setState(() {
          _petData = pet;
          _petImagePath = pet?['petImagePath'];
          _isFavorite = pet?['isFavorite'] ?? false;
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _petData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _petData = null;
        _isLoading = false;
      });
    }
  }

  Future<void> toggleFavorite() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final String fileData = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);

        final index = jsonData.indexWhere((pet) => pet['id'] == petId);

        if (index != -1) {
          jsonData[index]['isFavorite'] = !_isFavorite;

          setState(() {
            _petData = jsonData[index];
            _isFavorite = !_isFavorite;
          });

          await file.writeAsString(jsonEncode(jsonData));
        }
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  Future<void> saveImagePath(String path) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final String fileData = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);

        final index = jsonData.indexWhere((pet) => pet['id'] == petId);

        if (index != -1) {
          jsonData[index]['petImagePath'] = path;

          await file.writeAsString(jsonEncode(jsonData));

          if (!mounted) return;

          setState(() {
            _petData = jsonData[index];
            _petImagePath = path;
          });
        }
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  Future<void> deletePet(BuildContext contextArg) async {
    final BuildContext context = contextArg;

    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final String fileData = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);

        final filteredData =
            jsonData.where((pet) => pet['id'] != petId).toList();

        await file.writeAsString(jsonEncode(filteredData));

        if (_petImagePath != null) {
          final imageFile = File(_petImagePath!);
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        }

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (context.mounted) {
          Navigator.pop(context, true);
        }
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Errore durante l\'eliminazione dell\'animale'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String getGenderText(int? gender) {
    if (gender == 0) return 'Maschio';
    if (gender == 1) return 'Femmina';
    return 'Non specificato';
  }

  String? calculateAge(String? birthDateStr) {
    if (birthDateStr == null) return null;

    try {
      final birthDate = DateTime.parse(birthDateStr);
      final now = DateTime.now();

      var years = now.year - birthDate.year;

      if (years > 0) {
        return '$years Ann${years > 1 ? 'i' : 'o'}';
      } else {
        final months = now.month - birthDate.month;
        if (months > 0) {
          return '$months Mes${months > 1 ? 'i' : 'e'}';
        } else {
          final days = now.difference(birthDate).inDays;
          return '$days Giorn${days > 1 ? 'i' : 'o'}';
        }
      }
    } catch (e) {
      return null;
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';

    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
