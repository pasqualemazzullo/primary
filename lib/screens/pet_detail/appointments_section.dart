import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_colors.dart';
import 'data_manager.dart';
import '../appointment/details/appointment_detail_screen.dart';
import '../appointment/appointment_pet_screen.dart';
import '../appointment/models/appointment_type_data.dart';
import '../appointment/utils/date_formatter.dart';

mixin PetAppointmentsSection<T extends StatefulWidget>
    on State<T>, PetDataManager<T> {
  late List<AppointmentTypeData> _appointmentTypes;

  @override
  void initState() {
    super.initState();

    _appointmentTypes = AppointmentTypeData.getDefaultTypes();
  }

  IconData _getAppointmentTypeIcon(String appointmentType) {
    final typeMatch = _appointmentTypes.firstWhere(
      (type) => type.name.toLowerCase() == appointmentType.toLowerCase(),
      orElse: () => AppointmentTypeData("Altro", LucideIcons.calendar),
    );

    return typeMatch.icon;
  }

  Color _getAppointmentBackgroundColor(String appointmentType) {
    switch (appointmentType.toLowerCase()) {
      case 'controllo':
        return Colors.blue.shade100;
      case 'vaccino':
        return Colors.green.shade100;
      case 'toelettatura':
        return Colors.red.shade100;
      case 'medicinale':
        return Colors.purple.shade100;
      case 'bagno':
        return Colors.cyan.shade100;
      case 'pulci':
        return Colors.teal.shade100;
      case 'chirurgia':
        return Colors.indigo.shade100;
      case 'peso':
        return Colors.lightBlue.shade100;
      default:
        return Colors.amber.shade100;
    }
  }

  List<Widget> buildAppointmentsList() {
    if (petData?['appointments'] == null ||
        (petData?['appointments'] as List).isEmpty) {
      return [];
    }

    final List<dynamic> appointments = petData!['appointments'];

    final now = DateTime.now();
    final filteredAppointments =
        appointments.where((appointment) {
          final appointmentDate = DateTime.parse('${appointment['date']}');
          return appointmentDate.isAfter(now.subtract(const Duration(days: 1)));
        }).toList();

    filteredAppointments.sort((a, b) {
      final dateA = DateTime.parse('${a['date']}');
      final dateB = DateTime.parse('${b['date']}');
      return dateA.compareTo(dateB);
    });

    if (filteredAppointments.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.calendar, color: AppColors.grey600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nessun appuntamento futuro',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aggiungi un appuntamento per il tuo animale',
                      style: TextStyle(color: AppColors.grey600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    }

    final displayedAppointments = filteredAppointments.take(4).toList();

    return displayedAppointments.map((appointment) {
      final appointmentDate = DateTime.parse('${appointment['date']}');
      final formattedDate = DateFormatter.formatDate(
        appointmentDate,
      ).split(' ').take(3).join(' ');

      final String appointmentType = appointment['type'] ?? "Altro";
      final IconData appointmentIcon = _getAppointmentTypeIcon(appointmentType);
      final Color bgColor = _getAppointmentBackgroundColor(appointmentType);

      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AppointmentDetailsScreen(
                    petId: petId,
                    appointmentId: appointment['id'],
                  ),
            ),
          ).then((result) {
            if (result == true) {
              loadPetDetails();
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    appointmentIcon,
                    color: AppColors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "$formattedDate, ${appointment['time']}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (appointment['notes'] != null &&
                          appointment['notes'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            appointment['notes'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 153),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                if (appointment['notificationEnabled'] == true)
                  Icon(LucideIcons.bell, color: AppColors.orange, size: 18),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget buildAppointmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(LucideIcons.calendar, color: AppColors.orange, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Prossimi appuntamenti',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentPetScreen(),
                  ),
                ).then((_) {
                  loadPetDetails();
                });
              },
              icon: Icon(LucideIcons.plus, color: AppColors.orange, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.orangeLight.withValues(alpha: 0.3),
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildAppointmentsContent(),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAppointmentsContent() {
    if (petData?['appointments'] == null ||
        (petData?['appointments'] as List).isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.calendar, color: AppColors.grey600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nessun appuntamento futuro',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Aggiungi un appuntamento per il tuo animale',
                    style: TextStyle(color: AppColors.grey600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final List<dynamic> appointments = petData!['appointments'];

    final now = DateTime.now();
    final filteredAppointments =
        appointments.where((appointment) {
          final appointmentDate = DateTime.parse('${appointment['date']}');
          return appointmentDate.isAfter(now.subtract(const Duration(days: 1)));
        }).toList();

    filteredAppointments.sort((a, b) {
      final dateA = DateTime.parse('${a['date']}');
      final dateB = DateTime.parse('${b['date']}');
      return dateA.compareTo(dateB);
    });

    if (filteredAppointments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.calendar, color: AppColors.grey600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nessun appuntamento futuro',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Aggiungi un appuntamento per il tuo animale',
                    style: TextStyle(color: AppColors.grey600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final displayedAppointments = filteredAppointments.take(4).toList();

    return Column(
      children:
          displayedAppointments.map((appointment) {
            final appointmentDate = DateTime.parse('${appointment['date']}');
            final formattedDate = DateFormatter.formatDate(
              appointmentDate,
            ).split(' ').take(3).join(' ');

            final String appointmentType = appointment['type'] ?? "Altro";
            final IconData appointmentIcon = _getAppointmentTypeIcon(
              appointmentType,
            );
            final Color bgColor = _getAppointmentBackgroundColor(
              appointmentType,
            );

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AppointmentDetailsScreen(
                          petId: petId,
                          appointmentId: appointment['id'],
                        ),
                  ),
                ).then((result) {
                  if (result == true) {
                    loadPetDetails();
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          appointmentIcon,
                          color: AppColors.orange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointmentType,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "$formattedDate, ${appointment['time']}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (appointment['notes'] != null &&
                                appointment['notes'].toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  appointment['notes'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (appointment['notificationEnabled'] == true)
                        Icon(
                          LucideIcons.bell,
                          color: AppColors.orange,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
