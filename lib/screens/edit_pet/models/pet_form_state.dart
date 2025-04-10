import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PetFormState {
  final TextEditingController nameController;
  final TextEditingController imagePathController;
  final TextEditingController breedController;
  final TextEditingController colorController;
  final TextEditingController birthDateController;
  final TextEditingController microchipNumberController;
  final TextEditingController microchipDateController;
  final TextEditingController microchipProviderController;

  int? selectedGender;
  bool? isSterilized;
  bool hasMicrochip;

  bool formSubmitted = false;

  String? nameError;
  String? breedError;
  String? colorError;
  String? birthDateError;
  String? microchipProviderError;
  String? microchipNumberError;
  String? microchipDateError;

  PetFormState({required Map<String, dynamic> petData})
    : nameController = TextEditingController(text: petData['petName'] ?? ''),
      imagePathController = TextEditingController(
        text: petData['petImagePath'] ?? '',
      ),
      breedController = TextEditingController(text: petData['petBreed'] ?? ''),
      colorController = TextEditingController(text: petData['petColor'] ?? ''),
      birthDateController = TextEditingController(
        text: _formatDateString(petData['birthDate']),
      ),
      microchipProviderController = TextEditingController(
        text: petData['microchipProvider'] ?? '',
      ),
      microchipNumberController = TextEditingController(
        text: petData['microchipNumber'] ?? '',
      ),
      microchipDateController = TextEditingController(
        text: _formatDateString(petData['microchipDate']),
      ),
      selectedGender = _parseGender(petData['gender']),
      isSterilized = petData['isSterilized'] ?? false,
      hasMicrochip = petData['hasMicrochip'] ?? false;

  static String _formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  static int? _parseGender(dynamic gender) {
    if (gender is int) {
      return gender;
    } else if (gender is String) {
      return gender == 'Maschio' ? 0 : 1;
    }
    return 0;
  }

  bool validateAllFields() {
    formSubmitted = true;

    nameError =
        nameController.text.isEmpty
            ? 'Davvero il tuo animale non ha un nome?🤔'
            : null;

    breedError =
        breedController.text.isEmpty
            ? 'Davvero il tuo animale non ha una razza?🤔'
            : null;

    colorError =
        colorController.text.isEmpty
            ? 'Davvero il tuo animale non ha un colore?🤔'
            : null;

    birthDateError =
        birthDateController.text.isEmpty
            ? 'La data di nascita non può essere vuota'
            : null;

    if (hasMicrochip) {
      microchipProviderError =
          microchipProviderController.text.isEmpty
              ? 'Il fornitore del microchip non può essere vuoto'
              : null;

      microchipNumberError =
          microchipNumberController.text.isEmpty
              ? 'Il numero del microchip non può essere vuoto'
              : null;

      microchipDateError =
          microchipDateController.text.isEmpty
              ? 'La data di inserimento del microchip non può essere vuota'
              : null;
    } else {
      microchipProviderError = null;
      microchipNumberError = null;
      microchipDateError = null;
    }

    return isFormValid();
  }

  bool isFormValid() {
    bool basicFieldsValid =
        nameError == null &&
        breedError == null &&
        colorError == null &&
        birthDateError == null &&
        selectedGender != null &&
        isSterilized != null;

    bool microchipFieldsValid =
        !hasMicrochip ||
        (microchipProviderError == null &&
            microchipNumberError == null &&
            microchipDateError == null);

    return basicFieldsValid && microchipFieldsValid;
  }

  Map<String, dynamic> toJson(Map<String, dynamic> originalPetData) {
    String birthDateFormatted = '';
    try {
      DateTime parsedDate = DateFormat(
        'dd-MM-yyyy',
      ).parse(birthDateController.text);
      birthDateFormatted = parsedDate.toIso8601String().split('T').first;
    } catch (e) {
      birthDateFormatted = birthDateController.text;
    }

    String microchipDateFormatted = '';
    if (hasMicrochip && microchipDateController.text.isNotEmpty) {
      try {
        DateTime parsedDate = DateFormat(
          'dd-MM-yyyy',
        ).parse(microchipDateController.text);
        microchipDateFormatted = parsedDate.toIso8601String().split('T').first;
      } catch (e) {
        microchipDateFormatted = microchipDateController.text;
      }
    }

    final updatedPetData = {
      'id': originalPetData['id'],
      'petName': nameController.text,
      'petImagePath': imagePathController.text,
      'gender': selectedGender,
      'petBreed': breedController.text,
      'petColor': colorController.text,
      'birthDate': birthDateFormatted,
      'isFavorite': originalPetData['isFavorite'],
      'isSterilized': isSterilized,
      'hasMicrochip': hasMicrochip,
      'microchipProvider': hasMicrochip ? microchipProviderController.text : '',
      'microchipNumber': hasMicrochip ? microchipNumberController.text : '',
      'microchipDate': hasMicrochip ? microchipDateFormatted : '',
      'totalUsers': originalPetData['totalUsers'],
    };

    updatedPetData.addAll({
      for (var key in originalPetData.keys)
        if (!updatedPetData.containsKey(key)) key: originalPetData[key],
    });

    return updatedPetData;
  }

  void dispose() {
    nameController.dispose();
    imagePathController.dispose();
    breedController.dispose();
    colorController.dispose();
    birthDateController.dispose();
    microchipProviderController.dispose();
    microchipNumberController.dispose();
    microchipDateController.dispose();
  }
}
