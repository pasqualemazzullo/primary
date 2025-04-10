import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../models/pet.dart';
import '../models/notification_type.dart';
import '../models/professional.dart';
import 'notification_service.dart';

class AppointmentManager {
  final NotificationService _notificationService = NotificationService();

  Future<List<Pet>> loadPets() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);

        return jsonList.map((item) => Pet.fromJson(item)).toList();
      } else {
        throw Exception('File dei dati pets non trovato');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Professional>> loadProfessionals() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final String fileData = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);

        Set<int> processedIds = {};
        List<Professional> professionals = [];

        for (var petData in jsonData) {
          if (petData['professionalDetails'] != null) {
            final Map<String, dynamic> professionalDetails =
                Map<String, dynamic>.from(petData['professionalDetails']);

            for (var entry in professionalDetails.entries) {
              final int professionalId = int.tryParse(entry.key) ?? 0;

              if (!processedIds.contains(professionalId)) {
                processedIds.add(professionalId);

                final professional = Professional.fromJson(entry.value);
                professionals.add(professional);
              }
            }
          }
        }

        return professionals;
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveAppointment({
    required List<Pet> selectedPets,
    required String? appointmentType,
    required DateTime appointmentDate,
    required TimeOfDay appointmentTime,
    String? notes,
    bool isNotificationEnabled = false,
    NotificationType notificationType = NotificationType.minutes,
    int? notificationDays,
    int? notificationHours,
    int? notificationMinutes,
    int? professionalId,

    bool isEditing = false,
    int? appointmentId,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (!await file.exists()) {
        await file.writeAsString('[]');
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsData = jsonDecode(jsonString);

      final String formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(appointmentDate);
      final String formattedTime =
          '${appointmentTime.hour}:${appointmentTime.minute.toString().padLeft(2, '0')}';

      final int currentAppointmentId =
          isEditing && appointmentId != null
              ? appointmentId
              : (DateTime.now().millisecondsSinceEpoch % 2000000000);

      final Map<String, dynamic> appointmentData = {
        'id': currentAppointmentId,
        'type': appointmentType,
        'date': formattedDate,
        'time': formattedTime,
        'professionalId': professionalId,
        'notes': notes ?? '',
        'notificationEnabled': isNotificationEnabled,
      };

      if (isNotificationEnabled) {
        if (notificationType == NotificationType.minutes) {
          appointmentData['notificationType'] = 'minutes';
          appointmentData['notificationMinutes'] = notificationMinutes ?? 30;
        } else {
          appointmentData['notificationType'] = 'daysAndHours';
          appointmentData['notificationDays'] = notificationDays ?? 1;
          appointmentData['notificationHours'] = notificationHours ?? 0;
        }
      }

      if (isEditing && appointmentId != null) {
        await _cancelAppointmentNotifications(appointmentId);

        bool appointmentUpdated = false;

        for (final pet in selectedPets) {
          final petIndex = petsData.indexWhere((p) => p['id'] == pet.id);

          if (petIndex != -1) {
            final appointments = List<dynamic>.from(
              petsData[petIndex]['appointments'] ?? [],
            );
            final appIndex = appointments.indexWhere(
              (a) => a['id'] == appointmentId,
            );

            if (appIndex != -1) {
              appointments[appIndex] = appointmentData;
              petsData[petIndex]['appointments'] = appointments;
              appointmentUpdated = true;
            }
          }
        }

        if (!appointmentUpdated) {
          for (final petData in petsData) {
            final appointments = List<dynamic>.from(
              petData['appointments'] ?? [],
            );
            final appIndex = appointments.indexWhere(
              (a) => a['id'] == appointmentId,
            );

            if (appIndex != -1) {
              appointments.removeAt(appIndex);
              petData['appointments'] = appointments;
            }
          }

          for (final pet in selectedPets) {
            final petIndex = petsData.indexWhere((p) => p['id'] == pet.id);

            if (petIndex != -1) {
              final appointments = List<dynamic>.from(
                petsData[petIndex]['appointments'] ?? [],
              );
              appointments.add(appointmentData);
              petsData[petIndex]['appointments'] = appointments;
            }
          }
        }
      } else {
        for (final pet in selectedPets) {
          final petIndex = petsData.indexWhere((p) => p['id'] == pet.id);

          if (petIndex != -1) {
            final appointments = List<dynamic>.from(
              petsData[petIndex]['appointments'] ?? [],
            );
            appointments.add(appointmentData);
            petsData[petIndex]['appointments'] = appointments;
          }
        }
      }

      await file.writeAsString(jsonEncode(petsData));

      if (isNotificationEnabled) {
        await _scheduleAppointmentNotifications(
          appointmentId: currentAppointmentId,
          selectedPets: selectedPets,
          appointmentType: appointmentType,
          appointmentDate: appointmentDate,
          appointmentTime: appointmentTime,
          notificationType: notificationType,
          notificationDays: notificationDays,
          notificationHours: notificationHours,
          notificationMinutes: notificationMinutes,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _scheduleAppointmentNotifications({
    required int appointmentId,
    required List<Pet> selectedPets,
    required String? appointmentType,
    required DateTime appointmentDate,
    required TimeOfDay appointmentTime,
    required NotificationType notificationType,
    int? notificationDays,
    int? notificationHours,
    int? notificationMinutes,
  }) async {
    try {
      final DateTime fullAppointmentDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        appointmentTime.hour,
        appointmentTime.minute,
      );

      for (final pet in selectedPets) {
        final int notificationId = appointmentId + (pet.id);

        final String title =
            'È l\'ora del ${appointmentType ?? 'Appuntamento'}';

        final String formattedTime =
            '${appointmentTime.hour.toString().padLeft(2, '0')}:${appointmentTime.minute.toString().padLeft(2, '0')}';
        final String body =
            'Ricordati di questo appuntamento per ${pet.name} il ${DateFormat('dd/MM/yyyy').format(appointmentDate)} alle $formattedTime';

        if (notificationType == NotificationType.minutes) {
          await _notificationService.scheduleAppointmentNotification(
            id: notificationId,
            title: title,
            body: body,
            appointmentDateTime: fullAppointmentDateTime,
            useMinuteNotification: true,
            minutes: notificationMinutes ?? 30,
            payload: 'appointment_${pet.id}_$appointmentId',
          );
        } else {
          await _notificationService.scheduleAppointmentNotification(
            id: notificationId,
            title: title,
            body: body,
            appointmentDateTime: fullAppointmentDateTime,
            useMinuteNotification: false,
            days: notificationDays ?? 1,
            hours: notificationHours ?? 0,
            payload: 'appointment_${pet.id}_$appointmentId',
          );
        }
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  Future<void> _cancelAppointmentNotifications(int appointmentId) async {
    try {
      final pets = await loadPets();

      for (final pet in pets) {
        final int notificationId = appointmentId + (pet.id);
        await _notificationService.cancelNotification(notificationId);
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  Future<Map<String, dynamic>?> loadAppointmentById({
    required int? petId,
    required int appointmentId,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (!await file.exists()) {
        throw Exception('File pet_data.json non trovato');
      }

      final jsonString = await file.readAsString();
      final List<dynamic> petsData = jsonDecode(jsonString);

      if (petId != null) {
        final petData = petsData.firstWhere(
          (pet) => pet['id'] == petId,
          orElse: () => null,
        );

        if (petData != null) {
          final appointmentData = (petData['appointments'] as List<dynamic>)
              .firstWhere(
                (appointment) => appointment['id'] == appointmentId,
                orElse: () => null,
              );

          return appointmentData != null
              ? Map<String, dynamic>.from(appointmentData)
              : null;
        }
      } else {
        for (final petData in petsData) {
          final appointments = petData['appointments'] as List<dynamic>? ?? [];

          for (final appointment in appointments) {
            if (appointment['id'] == appointmentId) {
              return Map<String, dynamic>.from(appointment);
            }
          }
        }
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
}
