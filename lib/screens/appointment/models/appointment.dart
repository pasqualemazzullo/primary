class Appointment {
  final int id;
  final String type;
  final String date;
  final String time;
  final int? professionalId;
  final String? notes;
  final bool notificationEnabled;
  final String? notificationType;
  final int? notificationDays;
  final int? notificationHours;
  final int? notificationMinutes;
  final int? locationId;

  const Appointment({
    required this.id,
    required this.type,
    required this.date,
    required this.time,
    this.professionalId,
    this.notes,
    this.notificationEnabled = false,
    this.notificationType,
    this.notificationDays,
    this.notificationHours,
    this.notificationMinutes,
    this.locationId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      type: json['type'],
      date: json['date'],
      time: json['time'],
      professionalId: json['professionalId'],
      notes: json['notes'],
      notificationEnabled: json['notificationEnabled'] ?? false,
      notificationType: json['notificationType'],
      notificationDays: json['notificationDays'],
      notificationHours: json['notificationHours'],
      notificationMinutes: json['notificationMinutes'],
      locationId: json['locationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date,
      'time': time,
      'professionalId': professionalId,
      'notes': notes,
      'notificationEnabled': notificationEnabled,
      'notificationType': notificationType,
      'notificationDays': notificationDays,
      'notificationHours': notificationHours,
      'notificationMinutes': notificationMinutes,
      'locationId': locationId,
    };
  }
}
