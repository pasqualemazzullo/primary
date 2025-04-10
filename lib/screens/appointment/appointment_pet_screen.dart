import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../widgets/back_button.dart';
import '../../../theme/app_colors.dart';
import 'models/pet.dart';
import 'models/notification_type.dart';
import 'models/appointment_type_data.dart';
import 'models/professional.dart';
import 'services/appointment_manager.dart';
import 'widgets/appointment_type_dropdown.dart';
import 'widgets/pet_selection_dialog.dart';
import 'widgets/notification_type_selector.dart';
import 'widgets/number_selector_dialog.dart';
import 'widgets/minutes_picker_dialog.dart';
import 'widgets/save_button.dart';
import 'widgets/form_utils.dart';
import 'widgets/professional_selection_dialog.dart';

class AppointmentPetScreen extends StatefulWidget {
  final int? petId;
  final int? appointmentId;
  final bool isEditing;

  const AppointmentPetScreen({
    super.key,
    this.petId,
    this.appointmentId,
    this.isEditing = false,
  });

  @override
  State<AppointmentPetScreen> createState() => _AppointmentPetScreenState();
}

class _AppointmentPetScreenState extends State<AppointmentPetScreen> {
  final AppointmentManager _appointmentManager = AppointmentManager();

  DateTime? _appointmentDate;
  TimeOfDay? _appointmentTime;

  List<Pet> _selectedPets = [];
  List<Pet> _availablePets = [];

  String? _appointmentType;
  late List<AppointmentTypeData> _appointmentTypes;

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  String? _dateError;
  String? _timeError;
  String? _notesError;

  bool _isNotificationEnabled = false;
  NotificationType _notificationType = NotificationType.daysAndHours;

  bool _isLoading = false;

  Professional? _selectedProfessional;
  List<Professional> _availableProfessionals = [];

  @override
  void initState() {
    super.initState();

    _appointmentTypes = AppointmentTypeData.getDefaultTypes();

    _loadPets();

    _loadProfessionals();

    _daysController.text = '1';
    _minutesController.text = '30';

    if (widget.isEditing && widget.appointmentId != null) {
      _loadAppointmentData();
    }
  }

  Future<void> _loadProfessionals() async {
    try {
      final professionals = await _appointmentManager.loadProfessionals();

      setState(() {
        _availableProfessionals = professionals;
      });
    } catch (e) {
      _showErrorSnackBar(
        'Errore durante il caricamento dei professionisti: $e',
      );
    }
  }

  Future<void> _selectProfessional() async {
    final Professional? result = await showDialog<Professional>(
      context: context,
      builder:
          (context) => ProfessionalSelectionDialog(
            availableProfessionals: _availableProfessionals,
            selectedProfessional: _selectedProfessional,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedProfessional = result;
      });
    }
  }

  Future<void> _loadAppointmentData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appointmentData = await _appointmentManager.loadAppointmentById(
        petId: widget.petId,
        appointmentId: widget.appointmentId!,
      );

      if (appointmentData != null) {
        setState(() {
          _appointmentDate = DateTime.parse(appointmentData['date']);
          _dateController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(_appointmentDate!);

          final timeString = appointmentData['time'];
          final timeParts = timeString.split(':');
          if (timeParts.length == 2) {
            _appointmentTime = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );
            _timeController.text = _appointmentTime!.format(context);
          }

          _appointmentType = appointmentData['type'];

          if (appointmentData['notes'] != null) {
            _notesController.text = appointmentData['notes'];
          }

          _isNotificationEnabled =
              appointmentData['notificationEnabled'] ?? false;

          if (_isNotificationEnabled) {
            final notificationType =
                appointmentData['notificationType'] ?? 'minutes';

            _notificationType =
                notificationType == 'minutes'
                    ? NotificationType.minutes
                    : NotificationType.daysAndHours;

            if (_notificationType == NotificationType.minutes) {
              _minutesController.text =
                  (appointmentData['notificationMinutes'] ?? 30).toString();
            } else {
              _daysController.text =
                  (appointmentData['notificationDays'] ?? 1).toString();
              _hoursController.text =
                  (appointmentData['notificationHours'] ?? 0).toString();
            }
          }

          if (appointmentData['professionalId'] != null) {
            _selectedProfessional = _availableProfessionals.firstWhere(
              (p) => p.id == appointmentData['professionalId'],
            );
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar(
        'Errore durante il caricamento dei dati dell\'appuntamento: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _daysController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  Future<void> _loadPets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pets = await _appointmentManager.loadPets();

      setState(() {
        _availablePets = pets;

        if (widget.petId != null) {
          _selectedPets =
              _availablePets.where((pet) => pet.id == widget.petId).toList();
        }

        _isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar('Errore durante il caricamento degli animali: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.orange,
        content: Row(
          children: [
            const Icon(LucideIcons.circleCheck, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _appointmentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.orange,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.orange),
              ),
            ),
            child: child!,
          ),
    );

    if (picked != null) {
      setState(() {
        _appointmentDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
        _dateError = null;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _appointmentTime ?? TimeOfDay.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: AppColors.orange),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.orange),
              ),
            ),
            child: child!,
          ),
    );

    if (picked != null) {
      setState(() {
        _appointmentTime = picked;
        _timeController.text = picked.format(context);
        _timeError = null;
      });
    }
  }

  void _showDaysSelector() {
    final int initialDays = int.tryParse(_daysController.text) ?? 1;

    showDialog(
      context: context,
      builder:
          (context) => NumberSelectorDialog(
            title: 'Seleziona giorni prima',
            initialValue: initialDays,
            minValue: 1,
            maxValue: 30,
            onConfirm: (value) {
              _daysController.text = value.toString();
              setState(() {});
            },
          ),
    );
  }

  void _showMinutesSelector() {
    final List<int> minuteOptions = [5, 10, 15, 30, 45, 60];
    final int initialMinutes = int.tryParse(_minutesController.text) ?? 15;

    showDialog(
      context: context,
      builder:
          (context) => MinutesPickerDialog(
            initialMinutes: initialMinutes,
            presetOptions: minuteOptions,
            onConfirm: (value) {
              _minutesController.text = value.toString();
              setState(() {});
            },
          ),
    );
  }

  Future<void> _selectPets() async {
    final List<Pet>? result = await showDialog<List<Pet>>(
      context: context,
      builder:
          (context) => PetSelectionDialog(
            availablePets: _availablePets,
            selectedPets: _selectedPets,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedPets = result;
      });
    }
  }

  bool _isFormValid() {
    final bool basicInfoValid =
        _appointmentDate != null &&
        _appointmentTime != null &&
        _selectedPets.isNotEmpty &&
        _appointmentType != null;

    if (!_isNotificationEnabled) {
      return basicInfoValid;
    }

    if (_notificationType == NotificationType.daysAndHours) {
      return basicInfoValid &&
          (_daysController.text.isNotEmpty || _hoursController.text.isNotEmpty);
    } else {
      return basicInfoValid && _minutesController.text.isNotEmpty;
    }
  }

  Future<void> _saveAppointment() async {
    if (!_isFormValid()) {
      _showErrorSnackBar(
        'Completa tutti i campi obbligatori: animale, data, orario e tipo di appuntamento!',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _appointmentManager.saveAppointment(
        selectedPets: _selectedPets,
        appointmentType: _appointmentType,
        appointmentDate: _appointmentDate!,
        appointmentTime: _appointmentTime!,
        notes: _notesController.text,
        isNotificationEnabled: _isNotificationEnabled,
        notificationType: _notificationType,
        notificationDays: int.tryParse(_daysController.text),
        notificationHours: int.tryParse(_hoursController.text),
        notificationMinutes: int.tryParse(_minutesController.text),
        professionalId: _selectedProfessional?.id,

        isEditing: widget.isEditing,
        appointmentId: widget.appointmentId,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        _showSuccessSnackBar(
          widget.isEditing
              ? 'Appuntamento aggiornato con successo!'
              : 'Appuntamento salvato con successo!',
        );

        if (!mounted) return;
        Navigator.of(context).pop(true);
      } else {
        _showErrorSnackBar('Errore durante il salvataggio dell\'appuntamento.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorSnackBar(
        'Errore durante il salvataggio dell\'appuntamento: $e',
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
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BackButtonWidget(
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            "Dettagli dell'appuntamento",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),

                        FormUtils.buildFormField(
                          label: 'Per quale animale domestico?',
                          field: FormUtils.buildInputContainer(
                            child: InkWell(
                              onTap: _selectPets,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedPets.isEmpty
                                            ? 'Seleziona'
                                            : _selectedPets
                                                .map((pet) => pet.name)
                                                .join(', '),
                                        style: const TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        FormUtils.buildFormField(
                          label: 'Tipo di appuntamento',
                          field: FormUtils.buildInputContainer(
                            child: AppointmentTypeDropdown(
                              selectedType: _appointmentType,
                              types: _appointmentTypes,
                              onChanged: (value) {
                                setState(() {
                                  _appointmentType = value;
                                });
                              },
                            ),
                          ),
                        ),

                        FormUtils.buildFormField(
                          label: 'Data dell\'appuntamento',
                          field: FormUtils.buildInputContainer(
                            errorText: _dateError,
                            child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'gg-mm-aaaa',
                                hintStyle: TextStyle(color: AppColors.grey300),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onTap: _selectDate,
                            ),
                          ),
                          errorText: _dateError,
                        ),

                        FormUtils.buildFormField(
                          label: 'Orario dell\'appuntamento',
                          field: FormUtils.buildInputContainer(
                            errorText: _timeError,
                            child: TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'hh:mm',
                                hintStyle: TextStyle(color: AppColors.grey300),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onTap: _selectTime,
                            ),
                          ),
                          errorText: _timeError,
                        ),

                        FormUtils.buildFormField(
                          label: 'Professionista (facoltativo)',
                          field: FormUtils.buildInputContainer(
                            child: InkWell(
                              onTap: _selectProfessional,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedProfessional?.name ??
                                            'Seleziona un professionista',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              _selectedProfessional == null
                                                  ? AppColors.grey300
                                                  : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (_selectedProfessional != null)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedProfessional = null;
                                          });
                                        },
                                        child: const Icon(
                                          LucideIcons.x,
                                          size: 18,
                                          color: AppColors.grey600,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        FormUtils.buildFormField(
                          label: 'Note (facoltative)',
                          field: FormUtils.buildInputContainer(
                            errorText: _notesError,
                            child: TextFormField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                hintText: 'Aggiungi note...',
                                hintStyle: TextStyle(color: AppColors.grey300),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          errorText: _notesError,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Vuoi essere notificato?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch(
                              value: _isNotificationEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _isNotificationEnabled = value;
                                });
                              },
                              activeColor: AppColors.orange,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        if (_isNotificationEnabled) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quando vuoi essere notificato?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              NotificationTypeSelector(
                                selectedType: _notificationType,
                                onChanged: (type) {
                                  setState(() {
                                    _notificationType = type;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          if (_notificationType ==
                              NotificationType.daysAndHours) ...[
                            FormUtils.buildFormField(
                              label: 'Quanti giorni prima?',
                              field: FormUtils.buildInputContainer(
                                child: InkWell(
                                  onTap: _showDaysSelector,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _daysController.text.isEmpty
                                                ? 'Seleziona i giorni'
                                                : '${_daysController.text} giorni',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  _daysController.text.isEmpty
                                                      ? AppColors.grey300
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            FormUtils.buildFormField(
                              label: 'Quanti minuti prima?',
                              field: FormUtils.buildInputContainer(
                                child: InkWell(
                                  onTap: _showMinutesSelector,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _minutesController.text.isEmpty
                                                ? 'Seleziona i minuti'
                                                : '${_minutesController.text} minuti',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  _minutesController
                                                          .text
                                                          .isEmpty
                                                      ? AppColors.grey300
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],

                        SaveButton(
                          isEnabled: _isFormValid(),
                          onTap: _saveAppointment,
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
