import 'package:flutter/material.dart';

import '../../../widgets/back_button.dart';
import 'models/pet_form_state.dart';
import 'services/pet_update_service.dart';
import 'widgets/form_field_container.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/gender_selector.dart';
import 'widgets/sterilized_selector.dart';
import 'widgets/microchip_section.dart';
import 'widgets/save_button.dart';

class EditPetScreen extends StatefulWidget {
  final Map<String, dynamic> petData;

  const EditPetScreen({super.key, required this.petData});

  @override
  EditPetScreenState createState() => EditPetScreenState();
}

class EditPetScreenState extends State<EditPetScreen> {
  late PetFormState _formState;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _formState = PetFormState(petData: widget.petData);

    _formState.nameController.addListener(_validateName);
    _formState.breedController.addListener(_validateBreed);
    _formState.colorController.addListener(_validateColor);
    _formState.birthDateController.addListener(_validateBirthDate);
    _formState.microchipProviderController.addListener(
      _validateMicrochipProvider,
    );
    _formState.microchipNumberController.addListener(_validateMicrochipNumber);
    _formState.microchipDateController.addListener(_validateMicrochipDate);
  }

  @override
  void dispose() {
    _formState.nameController.removeListener(_validateName);
    _formState.breedController.removeListener(_validateBreed);
    _formState.colorController.removeListener(_validateColor);
    _formState.birthDateController.removeListener(_validateBirthDate);
    _formState.microchipProviderController.removeListener(
      _validateMicrochipProvider,
    );
    _formState.microchipNumberController.removeListener(
      _validateMicrochipNumber,
    );
    _formState.microchipDateController.removeListener(_validateMicrochipDate);

    _formState.dispose();
    super.dispose();
  }

  void _validateName() {
    if (_formState.formSubmitted) {
      setState(() {
        _formState.nameError =
            _formState.nameController.text.isEmpty
                ? 'Davvero il tuo animale non ha un nome?🤔'
                : null;
      });
    }
  }

  void _validateBreed() {
    if (_formState.formSubmitted) {
      setState(() {
        _formState.breedError =
            _formState.breedController.text.isEmpty
                ? 'Davvero il tuo animale non ha una razza?🤔'
                : null;
      });
    }
  }

  void _validateColor() {
    if (_formState.formSubmitted) {
      setState(() {
        _formState.colorError =
            _formState.colorController.text.isEmpty
                ? 'Davvero il tuo animale non ha un colore?🤔'
                : null;
      });
    }
  }

  void _validateBirthDate() {
    if (_formState.formSubmitted) {
      setState(() {
        _formState.birthDateError =
            _formState.birthDateController.text.isEmpty
                ? 'La data di nascita non può essere vuota'
                : null;
      });
    }
  }

  void _validateMicrochipProvider() {
    if (_formState.formSubmitted && _formState.hasMicrochip) {
      setState(() {
        _formState.microchipProviderError =
            _formState.microchipProviderController.text.isEmpty
                ? 'Il fornitore del microchip non può essere vuoto'
                : null;
      });
    }
  }

  void _validateMicrochipNumber() {
    if (_formState.formSubmitted && _formState.hasMicrochip) {
      setState(() {
        _formState.microchipNumberError =
            _formState.microchipNumberController.text.isEmpty
                ? 'Il numero del microchip non può essere vuoto'
                : null;
      });
    }
  }

  void _validateMicrochipDate() {
    if (_formState.formSubmitted && _formState.hasMicrochip) {
      setState(() {
        _formState.microchipDateError =
            _formState.microchipDateController.text.isEmpty
                ? 'La data di inserimento del microchip non può essere vuota'
                : null;
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formState.validateAllFields()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedPetData = _formState.toJson(widget.petData);
        final success = await PetUpdateService.updatePet(updatedPetData);

        if (mounted) {
          Navigator.pop(context, success);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Errore durante il salvataggio: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Column(
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
                            "Dettagli dell'animale domestico",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nome del tuo animale',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FormFieldContainer(
                            errorText: _formState.nameError,
                            child: TextFormField(
                              controller: _formState.nameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Mr. Rocky',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Genere',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GenderSelector(
                            selectedGender: _formState.selectedGender,
                            onGenderChanged: (gender) {
                              setState(() {
                                _formState.selectedGender = gender;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Razza',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FormFieldContainer(
                            errorText: _formState.breedError,
                            child: TextFormField(
                              controller: _formState.breedController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Labrador',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Colore',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FormFieldContainer(
                            errorText: _formState.colorError,
                            child: TextFormField(
                              controller: _formState.colorController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Beige',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Data di nascita',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          DatePickerField(
                            controller: _formState.birthDateController,
                            hintText: 'gg-mm-aaaa',
                            errorText: _formState.birthDateError,
                            onChanged: _validateBirthDate,
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Sterilizzato',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SterilizedSelector(
                            isSelected: _formState.isSterilized,
                            onSelectionChanged: (value) {
                              setState(() {
                                _formState.isSterilized = value;
                              });
                            },
                          ),

                          MicrochipSection(
                            hasMicrochip: _formState.hasMicrochip,
                            onMicrochipToggled: (value) {
                              setState(() {
                                _formState.hasMicrochip = value;
                                if (!value) {
                                  _formState.microchipProviderError = null;
                                  _formState.microchipNumberError = null;
                                  _formState.microchipDateError = null;
                                } else if (_formState.formSubmitted) {
                                  _validateMicrochipProvider();
                                  _validateMicrochipNumber();
                                  _validateMicrochipDate();
                                }
                              });
                            },
                            providerController:
                                _formState.microchipProviderController,
                            numberController:
                                _formState.microchipNumberController,
                            dateController: _formState.microchipDateController,
                            providerError: _formState.microchipProviderError,
                            numberError: _formState.microchipNumberError,
                            dateError: _formState.microchipDateError,
                            onDateChanged: _validateMicrochipDate,
                          ),

                          const SizedBox(height: 30),

                          SaveButton(
                            isEnabled: _formState.isFormValid(),
                            onPressed: _saveForm,
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
