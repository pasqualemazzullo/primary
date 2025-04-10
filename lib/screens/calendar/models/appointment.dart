class Appointment {
  final int id;
  final int petId;
  final String appointmentType;
  final DateTime date;
  final String time;
  final String notes;
  final bool notificationEnabled;
  final String petName;
  final String petImagePath;
  final String petBreed;

  Appointment({
    required this.id,
    required this.petId,
    required this.appointmentType,
    required this.date,
    required this.time,
    required this.notes,
    required this.notificationEnabled,
    required this.petName,
    required this.petImagePath,
    this.petBreed = '',
  });

  factory Appointment.fromJson(
    Map<String, dynamic> appointmentJson,
    Map<String, dynamic> petJson,
  ) {
    return Appointment(
      id: appointmentJson['id'] ?? 0,
      petId: petJson['id'] ?? 0,
      appointmentType: appointmentJson['type'] ?? 'Altro',
      date: DateTime.parse(appointmentJson['date']),
      time: appointmentJson['time'] ?? '',
      notes: appointmentJson['notes'] ?? '',
      notificationEnabled: appointmentJson['notificationEnabled'] ?? false,
      petName: petJson['petName'] ?? 'Animale sconosciuto',
      petImagePath: petJson['petImagePath'] ?? '',
      petBreed: petJson['petBreed'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': appointmentType,
      'date': date.toIso8601String(),
      'time': time,
      'notes': notes,
      'notificationEnabled': notificationEnabled,
    };
  }
}
