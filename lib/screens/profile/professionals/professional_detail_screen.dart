import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/back_button.dart';
import 'services/associated_professionals_service.dart';

class ProfessionalDetailScreen extends StatefulWidget {
  final int professionalId;

  const ProfessionalDetailScreen({super.key, required this.professionalId});

  @override
  State<ProfessionalDetailScreen> createState() =>
      _ProfessionalDetailScreenState();
}

class _ProfessionalDetailScreenState extends State<ProfessionalDetailScreen> {
  final AssociatedProfessionalsService _professionalsService =
      AssociatedProfessionalsService();
  Map<String, dynamic>? _professionalData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfessionalDetails();
  }

  Future<void> _loadProfessionalDetails() async {
    setState(() => _isLoading = true);

    try {
      final data = await _professionalsService.getProfessionalDetails(
        widget.professionalId,
      );

      if (!mounted) return;

      setState(() {
        _professionalData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _professionalData = null;
        _isLoading = false;
      });
      _showErrorSnackBar('Errore nel caricamento dei dati: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _launchPhone() async {
    try {
      final phoneNumber = _professionalData?['contactInfo'];
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        final Uri phoneUri = Uri.parse('tel:$phoneNumber');
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          _showErrorSnackBar('Impossibile avviare l\'app telefono');
        }
      } else {
        _showErrorSnackBar('Numero di telefono non disponibile');
      }
    } catch (e) {
      _showErrorSnackBar(
        'Errore nell\'avvio dell\'app telefono: ${e.toString()}',
      );
    }
  }

  Future<void> _launchEmail() async {
    try {
      final email = _professionalData?['email'];
      if (email != null && email.isNotEmpty) {
        final Uri emailUri = Uri.parse('mailto:$email');
        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        } else {
          _showErrorSnackBar('Impossibile avviare l\'app email');
        }
      } else {
        _showErrorSnackBar('Indirizzo email non disponibile');
      }
    } catch (e) {
      _showErrorSnackBar('Errore nell\'avvio dell\'app email: ${e.toString()}');
    }
  }

  Future<void> _openMaps() async {
    try {
      final locationData = _professionalData?['location'];
      if (locationData != null) {
        final String locationName = locationData['name'] ?? '';
        final String address = locationData['address'] ?? '';

        if (locationName.isNotEmpty || address.isNotEmpty) {
          String searchQuery;
          if (locationName.isNotEmpty && address.isNotEmpty) {
            searchQuery = '$locationName, $address';
          } else {
            searchQuery = locationName.isNotEmpty ? locationName : address;
          }

          final encodedQuery = Uri.encodeComponent(searchQuery);
          final Uri mapsUri = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$encodedQuery',
          );

          await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
        } else {
          _showErrorSnackBar('Informazioni sulla posizione non disponibili');
        }
      } else {
        _showErrorSnackBar('Informazioni sulla posizione non disponibili');
      }
    } catch (e) {
      _showErrorSnackBar('Errore nell\'apertura delle mappe: ${e.toString()}');
    }
  }

  Future<void> _navigateToEditScreen() async {
    if (_professionalData != null && mounted) {
      final result = await _professionalsService.navigateToProfessionalEdit(
        context,
        widget.professionalId,
      );

      if (result == true && mounted) {
        _loadProfessionalDetails();
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.orangeLight,
          title: const Text(
            'Sei sicuro di voler eliminare questo professionista?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text('L\'azione non può essere annullata.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Annulla',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Elimina',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      try {
        await _professionalsService.deleteProfessional(widget.professionalId);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Professionista eliminato con successo'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        _showErrorSnackBar('Errore durante l\'eliminazione: ${e.toString()}');
      }
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
                : _professionalData == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Impossibile caricare i dati del professionista',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfessionalDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                        ),
                        child: const Text('Riprova'),
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    children: [_buildHeader(), _buildProfessionalDetails()],
                  ),
                ),
      ),
    );
  }

  Widget _buildHeader() {
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
            onPressed: _navigateToEditScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalDetails() {
    if (_professionalData == null) return const SizedBox.shrink();

    final TextStyle boldText = const TextStyle(fontWeight: FontWeight.bold);
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(color: AppColors.grey300, width: 1),
    );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.orange,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    final String name = _professionalData!['name'] ?? 'Nome non disponibile';
    final String specialty =
        _professionalData!['specialty'] ?? 'Specialità non specificata';
    final Map<String, dynamic> location = _professionalData!['location'] ?? {};
    final String locationName =
        location['name'] ?? 'Nome struttura non disponibile';
    final String locationAddress =
        location['address'] ?? 'Indirizzo non disponibile';
    final String? imagePath = _professionalData!['imagePath'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            color: Colors.white,
            shape: cardShape,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.circleUser,
                        color: AppColors.orange,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Dettagli Professionista',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.orangeLight.withValues(
                            alpha: 0.3,
                          ),
                          backgroundImage:
                              imagePath != null && File(imagePath).existsSync()
                                  ? FileImage(File(imagePath))
                                  : null,
                          child:
                              imagePath == null || !File(imagePath).existsSync()
                                  ? const Icon(
                                    LucideIcons.user,
                                    size: 60,
                                    color: AppColors.orange,
                                  )
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          specialty,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  LucideIcons.phone,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: Text('Chiama', style: boldText),
                                style: buttonStyle,
                                onPressed:
                                    _professionalData!['contactInfo'] != null &&
                                            _professionalData!['contactInfo']
                                                .toString()
                                                .isNotEmpty
                                        ? _launchPhone
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  LucideIcons.mail,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: Text('Email', style: boldText),
                                style: buttonStyle,
                                onPressed:
                                    _professionalData!['email'] != null &&
                                            _professionalData!['email']
                                                .toString()
                                                .isNotEmpty
                                        ? _launchEmail
                                        : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: cardShape,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.building,
                        color: AppColors.orange,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Luogo di Esercizio',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.orangeLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.building,
                          color: AppColors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locationName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              locationAddress,
                              style: const TextStyle(color: AppColors.grey600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        LucideIcons.map,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text('Apri su Google Maps', style: boldText),
                      style: buttonStyle,
                      onPressed:
                          (locationAddress.isNotEmpty ||
                                  (location['coordinates'] != null &&
                                      location['coordinates']['lat'] != null))
                              ? _openMaps
                              : null,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(
                LucideIcons.trash2,
                size: 18,
                color: Colors.white,
              ),
              label: Text('Elimina professionista', style: boldText),
              style: buttonStyle.copyWith(
                backgroundColor: const WidgetStatePropertyAll(Colors.red),
              ),
              onPressed: _showDeleteConfirmationDialog,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
