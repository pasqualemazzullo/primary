import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/pet.dart';
import '../models/appointment.dart';
import '../models/location.dart';
import '../models/professional.dart';
import '../models/appointment_type_data.dart';
import '../models/notification_data.dart';
import '../appointment_pet_screen.dart';
import '../../../widgets/back_button.dart';
import '../../../theme/app_colors.dart';
import 'services/appointment_service.dart';
import 'widgets/appointment_details_card.dart';
import 'widgets/patient_card.dart';
import 'widgets/notes_card.dart';
import 'widgets/notification_card.dart';
import 'widgets/location_card.dart';
import 'widgets/professional_card.dart';
import 'widgets/delete_button.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final int petId;
  final int appointmentId;

  const AppointmentDetailsScreen({
    super.key,
    required this.petId,
    required this.appointmentId,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  bool _isLoading = true;
  Pet? _pet;
  Appointment? _appointment;
  late NotificationData _notificationData;
  Location? _location;
  Professional? _professional;

  late List<AppointmentTypeData> _appointmentTypes;

  @override
  void initState() {
    super.initState();

    _appointmentTypes = AppointmentTypeData.getDefaultTypes();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AppointmentService.loadAppointmentData(
        widget.petId,
        widget.appointmentId,
      );

      setState(() {
        _pet = result.$1;
        _appointment = result.$2;

        if (_appointment != null) {
          _notificationData = NotificationData.fromAppointment(_appointment!);

          _loadLocationAndProfessional();
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: Colors.red),
        );
      });
    }
  }

  Future<void> _loadLocationAndProfessional() async {
    if (_appointment == null || _pet == null) return;

    try {
      if (_appointment!.professionalId != null &&
          _pet!.professionalDetails != null &&
          _pet!.professionalDetails!.containsKey(
            _appointment!.professionalId.toString(),
          )) {
        final professionalData =
            _pet!.professionalDetails![_appointment!.professionalId.toString()];

        _professional = Professional.fromJson(professionalData);

        if (_professional!.location != null) {
          _location = Location(
            name: _professional!.location!['name'] ?? '',
            address: _professional!.location!['address'] ?? '',
          );
        }
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  Future<void> _deleteAppointment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AppointmentService.deleteAppointment(
        widget.petId,
        widget.appointmentId,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.orange,
            content: Row(
              children: [
                const Icon(LucideIcons.circleCheck, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  'Appuntamento eliminato con successo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );

        Navigator.of(context).pop(true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Errore durante l\'eliminazione dell\'appuntamento'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.orange),
                )
                : _pet == null || _appointment == null
                ? _buildErrorView()
                : _buildContent(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.triangleAlert, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Impossibile caricare i dati',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Torna indietro'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppointmentDetailsCard(
                  appointment: _appointment!,
                  appointmentTypes: _appointmentTypes,
                ),
                const SizedBox(height: 12),
                PatientCard(pet: _pet!),
                const SizedBox(height: 12),
                if (_appointment!.notes != null &&
                    _appointment!.notes!.isNotEmpty) ...[
                  NotesCard(notes: _appointment!.notes!),
                  const SizedBox(height: 12),
                ],
                if (_notificationData.enabled) ...[
                  NotificationCard(notificationData: _notificationData),
                  const SizedBox(height: 12),
                ],

                if (_location != null) ...[
                  LocationCard(location: _location!),
                  const SizedBox(height: 12),
                ],

                if (_professional != null) ...[
                  ProfessionalCard(professional: _professional!),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 12),
                DeleteButton(onDeleteConfirmed: _deleteAppointment),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButtonWidget(onPressed: () => Navigator.of(context).pop()),
          IconButton(
            icon: const Icon(
              LucideIcons.pencil,
              color: AppColors.orange,
              size: 28,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.orangeLight.withValues(alpha: 0.3),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(8),
            ),
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => AppointmentPetScreen(
                        petId: widget.petId,
                        appointmentId: widget.appointmentId,
                        isEditing: true,
                      ),
                ),
              );

              if (result == true) {
                _loadData();
              }
            },
          ),
        ],
      ),
    );
  }
}
