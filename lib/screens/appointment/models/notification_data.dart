import 'appointment.dart';

class NotificationData {
  final bool enabled;
  final Duration time;

  const NotificationData({required this.enabled, required this.time});

  factory NotificationData.fromAppointment(Appointment appointment) {
    final bool enabled = appointment.notificationEnabled;
    Duration time = Duration.zero;

    if (enabled) {
      final String? notificationType = appointment.notificationType;

      if (notificationType == 'minutes') {
        final int minutes = appointment.notificationMinutes ?? 30;
        time = Duration(minutes: minutes);
      } else if (notificationType == 'daysAndHours') {
        final int days = appointment.notificationDays ?? 0;
        final int hours = appointment.notificationHours ?? 0;
        time = Duration(days: days, hours: hours);
      }
    }

    return NotificationData(enabled: enabled, time: time);
  }

  String getNotificationText() {
    if (time == Duration.zero) return "Notifica attivata";

    final hours = time.inHours;
    final minutes = time.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return "Notifica $hours ore e $minutes minuti prima";
    } else if (hours > 0) {
      return "Notifica $hours ${hours == 1 ? 'ora' : 'ore'} prima";
    } else {
      return "Notifica $minutes ${minutes == 1 ? 'minuto' : 'minuti'} prima";
    }
  }
}
