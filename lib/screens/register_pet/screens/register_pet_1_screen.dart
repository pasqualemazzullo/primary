import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import '../../../providers/register_pet_provider.dart';
import '../../../widgets/back_button.dart';
import 'register_pet_2_screen.dart';
import '../widgets/pet_name_input.dart';
import '../widgets/gender_selector.dart';
import '../widgets/birthdate_picker.dart';
import '../widgets/continue_button.dart';

class RegisterPet1Screen extends StatefulWidget {
  const RegisterPet1Screen({super.key});

  @override
  State<RegisterPet1Screen> createState() => _RegisterPet1ScreenState();
}

class _RegisterPet1ScreenState extends State<RegisterPet1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  String? _petNameError;

  @override
  void initState() {
    super.initState();
    final petProvider = Provider.of<RegisterPetProvider>(
      context,
      listen: false,
    );
    if (petProvider.gender == -1) {
      petProvider.gender = 0;
    }
  }

  @override
  void dispose() {
    _petNameController.dispose();
    super.dispose();
  }

  void _onPetNameChanged(String value, String? error) {
    setState(() {
      _petNameError = error;
    });
  }

  void _submitForm() {
    setState(() {
      _petNameError =
          _petNameController.text.isEmpty
              ? 'Davvero il tuo animale non ha un nome?🤔'
              : null;
    });

    if (_formKey.currentState!.validate() && _petNameError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterPet2Screen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: SafeArea(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BackButtonWidget(
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),

                          _buildHeaderText(),
                          const SizedBox(height: 32),

                          const Text(
                            'Nome del tuo animale',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          PetNameInput(
                            controller: _petNameController,
                            onChanged: _onPetNameChanged,
                            error: _petNameError,
                          ),
                          const SizedBox(height: 32),

                          const Text(
                            'Genere',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const GenderSelector(),
                          const SizedBox(height: 32),

                          const Text(
                            'Data di nascita',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const BirthdatePicker(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: ContinueButton(
                  onPressed: _submitForm,
                  isEnabled:
                      _petNameController.text.isNotEmpty &&
                      Provider.of<RegisterPetProvider>(context).gender != -1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        const Center(
          child: Text(
            "Ci vogliono 20 secondi!",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "Inserisci i primi dati relativi al tuo animale domestico per registrarlo.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey600,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
