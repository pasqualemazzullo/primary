import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/appointment.dart';

class AppointmentService {
  final Map<DateTime, List<Appointment>> _appointments = {};

  Map<DateTime, List<Appointment>> get appointments => _appointments;

  Set<DateTime> get eventDays => _appointments.keys.toSet();

  Future<void> loadAppointmentsFromJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pet_data.json');

      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        final List<dynamic> pets = jsonDecode(jsonString);

        final Map<DateTime, List<Appointment>> loadedAppointments = {};

        for (var pet in pets) {
          final List<dynamic> petAppointments = pet['appointments'] ?? [];

          for (var appointmentJson in petAppointments) {
            final String dateStr = appointmentJson['date'] ?? '';

            if (dateStr.isNotEmpty) {
              DateTime date = DateTime.parse(dateStr);
              DateTime normalizedDate = DateTime(
                date.year,
                date.month,
                date.day,
              );

              Appointment newAppointment = Appointment.fromJson(
                appointmentJson,
                pet,
              );

              if (loadedAppointments.containsKey(normalizedDate)) {
                loadedAppointments[normalizedDate]!.add(newAppointment);
              } else {
                loadedAppointments[normalizedDate] = [newAppointment];
              }
            }
          }
        }

        _appointments.clear();
        _appointments.addAll(loadedAppointments);

        return;
      } else {
        _appointments.clear();
        return;
      }
    } catch (e) {
      _appointments.clear();
      return;
    }
  }

  DateTime? findNextAppointmentDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? nextAppointment;

    for (var date in _appointments.keys) {
      if ((date.isAfter(today) || isSameDay(date, today)) &&
          (nextAppointment == null || date.isBefore(nextAppointment))) {
        nextAppointment = date;
      }
    }

    return nextAppointment;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Appointment> getAppointmentsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _appointments[normalizedDay] ?? [];
  }
}
