import 'dart:io';
import 'package:flutter/material.dart';
import '../models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isFullWidth;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : 250,
      margin: isFullWidth ? EdgeInsets.zero : const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPetImage(),
            const SizedBox(width: 12),
            Expanded(child: _buildAppointmentDetails()),
          ],
        ),
      ),
    );
  }

  Widget _buildPetImage() {
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            appointment.petImagePath.isNotEmpty
                ? Image.file(
                  File(appointment.petImagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/image_placeholder.png',
                      fit: BoxFit.cover,
                    );
                  },
                )
                : Image.asset(
                  'assets/image_placeholder.png',
                  fit: BoxFit.cover,
                ),
      ),
    );
  }

  Widget _buildAppointmentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(appointment.petName, style: const TextStyle(fontSize: 14)),
        Text(
          appointment.appointmentType,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Ore: ${appointment.time}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}
