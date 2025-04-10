import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/back_button.dart';
import 'services/associated_professionals_service.dart';

class Pet {
  final int id;
  final String name;
  final String category;
  final String breed;
  final String? imagePath;
  final List<int> professionals;

  Pet({
    required this.id,
    required this.name,
    required this.category,
    required this.breed,
    this.imagePath,
    List<int>? professionals,
  }) : professionals = professionals ?? [];

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['petName'],
      category: json['category'] ?? '',
      breed: json['petBreed'] ?? '',
      imagePath: json['petImagePath'],
      professionals:
          json['professionals'] != null
              ? List<int>.from(json['professionals'])
              : [],
    );
  }

  @override
  String toString() => name;
}

class SaveButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onTap;

  const SaveButton({super.key, required this.isEnabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isEnabled ? AppColors.orange : AppColors.grey300,
            ),
            borderRadius: BorderRadius.circular(30),
            color: isEnabled ? AppColors.orange : AppColors.lightGrey,
          ),
          child: Center(
            child: Text(
              'Salva',
              style: TextStyle(
                color: isEnabled ? Colors.white : AppColors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfessionalEditScreen extends StatefulWidget {
  final int? professionalId;

  const ProfessionalEditScreen({super.key, this.professionalId});

  @override
  ProfessionalEditScreenState createState() => ProfessionalEditScreenState();
}

class ProfessionalEditScreenState extends State<ProfessionalEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactInfoController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _locationAddressController = TextEditingController();

  final List<String> _specialties = [
    'Toelettatore',
    'Pet Sitter',
    'Veterinario',
  ];
  String _selectedSpecialty = 'Veterinario';

  List<Pet> _allPets = [];
  List<Pet> _selectedPets = [];
  bool _isLoadingPets = false;

  final _professionalsService = AssociatedProfessionalsService();

  bool _isEditing = false;
  bool _isLoading = false;
  bool _isFormValid = false;
  Map<String, dynamic>? _professionalData;

  Map<String, String?> _errors = {
    'name': null,
    'specialty': null,
    'pets': null,
  };

  @override
  void initState() {
    super.initState();
    _isEditing = widget.professionalId != null;
    _initializeForm();

    _nameController.addListener(_validateFormOnChange);
  }

  Future<void> _initializeForm() async {
    await _loadPets();
    if (_isEditing) await _loadProfessionalData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactInfoController.dispose();
    _emailController.dispose();
    _locationNameController.dispose();
    _locationAddressController.dispose();
    super.dispose();
  }

  Future<void> _loadPets() async {
    setState(() {
      _isLoadingPets = true;
    });

    try {
      final petsData = await _professionalsService.loadAllPets();

      setState(() {
        _allPets = petsData.map((json) => Pet.fromJson(json)).toList();
        _isLoadingPets = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPets = false;
      });
      _showErrorSnackBar(
        'Errore nel caricamento degli animali: ${e.toString()}',
      );
    }
  }

  void _validateFormOnChange() {
    bool isValid = _checkFormValidity(updateUI: false);
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _loadProfessionalData() async {
    setState(() => _isLoading = true);

    try {
      final data = await _professionalsService.getProfessionalDetails(
        widget.professionalId!,
      );

      if (!mounted) return;

      setState(() {
        _professionalData = data;
        if (data != null) {
          _nameController.text = data['name'] ?? '';

          if (data['specialty'] != null &&
              _specialties.contains(data['specialty'])) {
            _selectedSpecialty = data['specialty'];
          }

          _contactInfoController.text = data['contactInfo'] ?? '';
          _emailController.text = data['email'] ?? '';
          _locationNameController.text = data['location']?['name'] ?? '';
          _locationAddressController.text = data['location']?['address'] ?? '';

          final List<int> associatedPetIds = List<int>.from(
            data['associatedPets'] ?? [],
          );
          _selectedPets =
              _allPets
                  .where((pet) => associatedPetIds.contains(pet.id))
                  .toList();
        }
        _isLoading = false;
      });

      _validateFormOnChange();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _professionalData = null;
        _isLoading = false;
      });
      _showErrorSnackBar('Errore nel caricamento dei dati: ${e.toString()}');
    }
  }

  Future<void> _saveProfessional() async {
    if (!_validateForm()) return;
    setState(() => _isLoading = true);

    try {
      final int professionalId =
          _isEditing
              ? widget.professionalId!
              : DateTime.now().millisecondsSinceEpoch;

      final professionalData = {
        'id': professionalId,
        'name': _nameController.text.trim(),
        'specialty': _selectedSpecialty,
        'contactInfo': _contactInfoController.text.trim(),
        'email': _emailController.text.trim(),
        'location': {
          'name': _locationNameController.text.trim(),
          'address': _locationAddressController.text.trim(),
        },
        'imagePath':
            _professionalData != null ? _professionalData!['imagePath'] : null,
        'associatedPets': _selectedPets.map((pet) => pet.id).toList(),
      };

      bool success;
      if (_isEditing) {
        success = await _professionalsService.updateProfessional(
          professionalId,
          professionalData,
        );
      } else {
        success = await _professionalsService.addProfessional(professionalData);
      }

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      } else {
        _showErrorSnackBar('Errore durante il salvataggio del professionista');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Errore durante il salvataggio: ${e.toString()}');
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  bool _checkFormValidity({bool updateUI = false}) {
    Map<String, String?> newErrors = {
      'name': null,
      'specialty': null,
      'pets': null,
    };

    if (_nameController.text.trim().isEmpty) {
      newErrors['name'] = 'Inserisci il nome completo';
    }

    if (_selectedPets.isEmpty) {
      newErrors['pets'] = 'Seleziona almeno un animale';
    }

    if (updateUI) {
      setState(() => _errors = newErrors);
    }

    return !newErrors.values.any((error) => error != null);
  }

  bool _validateForm() {
    return _checkFormValidity(updateUI: true);
  }

  void _togglePetSelection(Pet pet) {
    setState(() {
      if (_selectedPets.any((p) => p.id == pet.id)) {
        _selectedPets.removeWhere((p) => p.id == pet.id);
      } else {
        _selectedPets.add(pet);
      }
      _validateFormOnChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildForm(),
                      ),
                    ],
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
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImagePicker(),
          const SizedBox(height: 32),

          _buildFormField(
            label: 'Nome completo',
            errorText: _errors['name'],
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nome completo',
                border: InputBorder.none,
              ),
            ),
          ),

          _buildFormField(
            label: 'Specialità',
            errorText: _errors['specialty'],
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: AppColors.orangeLight,
                isExpanded: true,
                value: _selectedSpecialty,
                icon: const Icon(
                  LucideIcons.chevronDown,
                  color: AppColors.orange,
                ),
                items:
                    _specialties
                        .map(
                          (specialty) => DropdownMenuItem<String>(
                            value: specialty,
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.stethoscope,
                                  color: AppColors.orange,
                                ),
                                const SizedBox(width: 16),
                                Text(specialty),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedSpecialty = value);
                },
              ),
            ),
          ),

          _buildFormField(
            label: 'Numero di telefono',
            child: TextField(
              controller: _contactInfoController,
              decoration: const InputDecoration(
                hintText: 'Numero di telefono',
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.phone,
            ),
          ),

          _buildFormField(
            label: 'Email',
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),

          const SizedBox(height: 8),
          _buildSectionHeader('Luogo di Esercizio', LucideIcons.building),
          const SizedBox(height: 16),

          _buildFormField(
            label: 'Nome struttura',
            child: TextField(
              controller: _locationNameController,
              decoration: const InputDecoration(
                hintText: 'Nome struttura',
                border: InputBorder.none,
              ),
            ),
          ),

          _buildFormField(
            label: 'Indirizzo',
            child: TextField(
              controller: _locationAddressController,
              decoration: const InputDecoration(
                hintText: 'Indirizzo',
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Animali Associati', LucideIcons.pawPrint),
          const SizedBox(height: 16),

          _buildPetSelectionSection(),

          if (_errors['pets'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16),
              child: Text(
                _errors['pets']!,
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          const SizedBox(height: 32),

          SaveButton(isEnabled: _isFormValid, onTap: _saveProfessional),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPetSelectionSection() {
    if (_isLoadingPets) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: AppColors.orange),
        ),
      );
    }

    if (_allPets.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Nessun animale disponibile',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Seleziona gli animali associati',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              '${_selectedPets.length} selezionati',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Tocca per selezionare/deselezionare',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    _allPets.map((pet) {
                      final isSelected = _selectedPets.any(
                        (p) => p.id == pet.id,
                      );
                      return GestureDetector(
                        onTap: () => _togglePetSelection(pet),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.orange.withValues(alpha: 0.1)
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? AppColors.orange
                                      : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isSelected
                                          ? AppColors.orange
                                          : Colors.transparent,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.orange
                                            : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                ),
                                child:
                                    isSelected
                                        ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 8),

                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    pet.imagePath != null &&
                                            File(pet.imagePath!).existsSync()
                                        ? FileImage(File(pet.imagePath!))
                                        : null,
                                child:
                                    pet.imagePath == null ||
                                            !File(pet.imagePath!).existsSync()
                                        ? Icon(
                                          pet.category == 'Cani'
                                              ? LucideIcons.dog
                                              : pet.category == 'Gatti'
                                              ? LucideIcons.cat
                                              : LucideIcons.fish,
                                          size: 14,
                                          color: Colors.grey.shade500,
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 8),

                              Text(
                                pet.name,
                                style: TextStyle(
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedPets = [];
                          _validateFormOnChange();
                        });
                      },
                      child: Text(
                        'Deseleziona tutti',
                        style: TextStyle(color: AppColors.orange, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedPets = List.from(_allPets);
                          _validateFormOnChange();
                        });
                      },
                      child: Text(
                        'Seleziona tutti',
                        style: TextStyle(color: AppColors.orange, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  errorText != null ? Colors.red.shade300 : AppColors.grey300,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 16),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.orange, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.orangeLight.withValues(alpha: 0.3),
            backgroundImage:
                _professionalData?['imagePath'] != null
                    ? AssetImage(_professionalData!['imagePath'])
                    : null,
            child:
                _professionalData?['imagePath'] == null
                    ? const Icon(
                      LucideIcons.user,
                      size: 60,
                      color: AppColors.orange,
                    )
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    LucideIcons.camera,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
