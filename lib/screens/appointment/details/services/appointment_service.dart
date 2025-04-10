import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/appointment.dart';
import '../../models/pet.dart';
import '../../models/professional.dart';
import '../../models/location.dart';

class AppointmentService {
  static Future<(Pet?, Appointment?, Professional?, Location?)>
  loadAppointmentData(int petId, int appointmentId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (!await file.exists()) {
        throw Exception('File pet_data.json non trovato');
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsData = jsonDecode(jsonString);

      final petData = petsData.firstWhere(
        (pet) => pet['id'] == petId,
        orElse: () => null,
      );

      if (petData == null) {
        throw Exception('Pet con ID $petId non trovato');
      }

      final appointmentData = (petData['appointments'] as List<dynamic>)
          .firstWhere(
            (appointment) => appointment['id'] == appointmentId,
            orElse: () => null,
          );

      if (appointmentData == null) {
        throw Exception('Appuntamento con ID $appointmentId non trovato');
      }

      final pet = Pet.fromJson(petData);
      final appointment = Appointment.fromJson(appointmentData);

      Professional? professional;
      Location? location;

      if (appointment.professionalId != null &&
          petData['professionalDetails'] != null &&
          petData['professionalDetails'].containsKey(
            appointment.professionalId.toString(),
          )) {
        final professionalData =
            petData['professionalDetails'][appointment.professionalId
                .toString()];
        professional = Professional.fromJson(professionalData);

        if (professional.location != null) {
          location = Location(
            name: professional.location!['name'] ?? '',
            address: professional.location!['address'] ?? '',
          );
        }
      }

      return (pet, appointment, professional, location);
    } catch (e) {
      return (null, null, null, null);
    }
  }

  static Future<bool> deleteAppointment(int petId, int appointmentId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (!await file.exists()) {
        throw Exception('File pet_data.json non trovato');
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsData = jsonDecode(jsonString);

      final petIndex = petsData.indexWhere((pet) => pet['id'] == petId);

      if (petIndex == -1) {
        throw Exception('Pet con ID $petId non trovato');
      }

      final petData = petsData[petIndex];
      final appointments = List<dynamic>.from(petData['appointments'] ?? []);

      final appointmentIndex = appointments.indexWhere(
        (appointment) => appointment['id'] == appointmentId,
      );

      if (appointmentIndex == -1) {
        throw Exception('Appuntamento con ID $appointmentId non trovato');
      }

      appointments.removeAt(appointmentIndex);

      petData['appointments'] = appointments;
      petsData[petIndex] = petData;

      await file.writeAsString(jsonEncode(petsData));

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Professional?> getProfessionalById(int professionalId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (!await file.exists()) {
        throw Exception('File pet_data.json non trovato');
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsData = jsonDecode(jsonString);

      for (final petData in petsData) {
        if (petData['professionalDetails'] != null &&
            petData['professionalDetails'].containsKey(
              professionalId.toString(),
            )) {
          final professionalData =
              petData['professionalDetails'][professionalId.toString()];
          return Professional.fromJson(professionalData);
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Location?> getLocationByProfessionalId(
    int professionalId,
  ) async {
    try {
      final professional = await getProfessionalById(professionalId);

      if (professional != null && professional.location != null) {
        return Location(
          name: professional.location!['name'] ?? '',
          address: professional.location!['address'] ?? '',
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
