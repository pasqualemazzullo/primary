import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/app_colors.dart';
import '../models/appointment.dart';
import 'appointment_card.dart';
import '../../appointment/details/appointment_detail_screen.dart';

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;
  final DateTime? selectedDay;
  final DateTime? nextAppointmentDate;
  final VoidCallback? onAppointmentChanged;

  const AppointmentList({
    super.key,
    required this.appointments,
    this.selectedDay,
    this.nextAppointmentDate,
    this.onAppointmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            height: 108,
            child: _buildAppointmentsContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.orange,
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.calendar, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            _getAppointmentsTitle(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsContent(BuildContext context) {
    if (appointments.isEmpty) {
      return _buildEmptyAppointmentCard();
    } else if (appointments.length == 1) {
      return _buildTappableAppointmentCard(
        context,
        appointments[0],
        isFullWidth: true,
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return _buildTappableAppointmentCard(
            context,
            appointments[index],
            isFullWidth: false,
          );
        },
      );
    }
  }

  Widget _buildTappableAppointmentCard(
    BuildContext context,
    Appointment appointment, {
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: () => _navigateToAppointmentDetails(context, appointment),
      child: AppointmentCard(
        appointment: appointment,
        isFullWidth: isFullWidth,
      ),
    );
  }

  void _navigateToAppointmentDetails(
    BuildContext context,
    Appointment appointment,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder:
                (context) => AppointmentDetailsScreen(
                  petId: appointment.petId,
                  appointmentId: appointment.id,
                ),
          ),
        )
        .then((result) {
          if (result == true && onAppointmentChanged != null) {
            onAppointmentChanged!();
          }
        });
  }

  Widget _buildEmptyAppointmentCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.orangeLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.calendarX,
                color: AppColors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Nessun appuntamento per questa data.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppointmentsTitle() {
    if (selectedDay != null) {
      return 'Appuntamenti del ${selectedDay?.day}/${selectedDay?.month}/${selectedDay?.year}';
    } else if (nextAppointmentDate != null) {
      return 'Prossimi appuntamenti: ${nextAppointmentDate?.day}/${nextAppointmentDate?.month}/${nextAppointmentDate?.year}';
    } else {
      return 'Nessun appuntamento futuro';
    }
  }
}
