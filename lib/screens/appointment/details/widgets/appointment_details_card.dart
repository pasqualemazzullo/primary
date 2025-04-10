import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models/appointment.dart';
import '../../models/appointment_type_data.dart';
import 'common_card.dart';
import 'icon_box.dart';
import '../../utils/date_formatter.dart';

class AppointmentDetailsCard extends StatelessWidget {
  final Appointment appointment;
  final List<AppointmentTypeData> appointmentTypes;

  const AppointmentDetailsCard({
    super.key,
    required this.appointment,
    required this.appointmentTypes,
  });

  IconData _getAppointmentTypeIcon(String appointmentType) {
    final typeMatch = appointmentTypes.firstWhere(
      (type) => type.name.toLowerCase() == appointmentType.toLowerCase(),
      orElse: () => AppointmentTypeData("Altro", LucideIcons.calendar),
    );

    return typeMatch.icon;
  }

  @override
  Widget build(BuildContext context) {
    final appointmentDate = DateTime.parse(appointment.date);

    final IconData appointmentIcon = _getAppointmentTypeIcon(appointment.type);

    return CommonCard(
      title: 'Dettagli appuntamento',
      icon: LucideIcons.calendar,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox(icon: appointmentIcon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatDate(appointmentDate),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(appointment.time, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
