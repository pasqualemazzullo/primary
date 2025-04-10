import 'package:flutter/material.dart';
import '../models/pet_form_state.dart';
import 'form_field_container.dart';
import 'date_picker_field.dart';
import 'gender_selector.dart';
import 'sterilized_selector.dart';
import 'microchip_section.dart';
import 'save_button.dart';

class EditPetForm extends StatefulWidget {
  final PetFormState formState;
  final VoidCallback onSave;

  const EditPetForm({super.key, required this.formState, required this.onSave});

  @override
  State<EditPetForm> createState() => _EditPetFormState();
}

class _EditPetFormState extends State<EditPetForm> {
  late PetFormState _formState;

  @override
  void initState() {
    super.initState();
    _formState = widget.formState;

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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nome del tuo animale',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Genere',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Colore',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Data di nascita',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            providerController: _formState.microchipProviderController,
            numberController: _formState.microchipNumberController,
            dateController: _formState.microchipDateController,
            providerError: _formState.microchipProviderError,
            numberError: _formState.microchipNumberError,
            dateError: _formState.microchipDateError,
            onDateChanged: _validateMicrochipDate,
          ),

          const SizedBox(height: 30),

          SaveButton(
            isEnabled: _formState.isFormValid(),
            onPressed: widget.onSave,
          ),
        ],
      ),
    );
  }
}
