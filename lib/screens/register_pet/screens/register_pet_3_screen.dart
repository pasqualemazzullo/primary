import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/back_button.dart';
import '../../home/pet_home_screen.dart';
import '../../../providers/register_pet_provider.dart';
import '../widgets/text_input_field.dart';
import '../services/pet_data_service.dart';

class RegisterPet3Screen extends StatefulWidget {
  const RegisterPet3Screen({super.key});

  @override
  State<RegisterPet3Screen> createState() => _RegisterPet3ScreenState();
}

class _RegisterPet3ScreenState extends State<RegisterPet3Screen> {
  final _petBreedController = TextEditingController();
  final _petColorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _petBreedError;
  String? _petColorError;
  final _petDataService = PetDataService();

  @override
  void initState() {
    super.initState();
    _petBreedController.addListener(_onPetBreedChanged);
    _petColorController.addListener(_onPetColorChanged);
  }

  @override
  void dispose() {
    _petBreedController.removeListener(_onPetBreedChanged);
    _petColorController.removeListener(_onPetColorChanged);
    _petBreedController.dispose();
    _petColorController.dispose();
    super.dispose();
  }

  void _onPetBreedChanged() {
    if (_petBreedController.text.isNotEmpty && _petBreedError != null) {
      setState(() {
        _petBreedError = null;
      });
    }
    setState(() {});
  }

  void _onPetColorChanged() {
    if (_petColorController.text.isNotEmpty && _petColorError != null) {
      setState(() {
        _petColorError = null;
      });
    }
    setState(() {});
  }

  bool _isFormValid() {
    return _petBreedController.text.isNotEmpty &&
        _petColorController.text.isNotEmpty;
  }

  void _submitForm() {
    setState(() {
      _petBreedError =
          _petBreedController.text.isEmpty
              ? 'Davvero il tuo animale non ha una razza?🤔'
              : null;
      _petColorError =
          _petColorController.text.isEmpty
              ? 'Davvero il tuo animale non ha un colore?🤔'
              : null;
    });

    if (_formKey.currentState!.validate() &&
        _petBreedError == null &&
        _petColorError == null) {
      final petProvider = Provider.of<RegisterPetProvider>(
        context,
        listen: false,
      );
      petProvider.petBreed = _petBreedController.text;
      petProvider.petColor = _petColorController.text;

      _petDataService.savePetData(petProvider).then((_) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PetHomeScreen()),
        );
      });
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
                            'Razza',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextInputField(
                            controller: _petBreedController,
                            hintText: 'Labrador',
                            errorText: _petBreedError,
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Colore',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextInputField(
                            controller: _petColorController,
                            hintText: 'Marrone',
                            errorText: _petColorError,
                          ),
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
                child: _buildFinishButton(),
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
            "Ci siamo quasi!",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "Inserisci gli ultimi dati fondamentali per registrare il tuo animale domestico.",
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

  Widget _buildFinishButton() {
    return GestureDetector(
      onTap: () {
        final petProvider = Provider.of<RegisterPetProvider>(
          context,
          listen: false,
        );
        petProvider.petBreed = _petBreedController.text;
        petProvider.petColor = _petColorController.text;
        _submitForm();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isFormValid() ? AppColors.orange : AppColors.grey300,
          ),
          borderRadius: BorderRadius.circular(30),
          color: _isFormValid() ? AppColors.orange : AppColors.lightGrey,
        ),
        child: Center(
          child: Text(
            'Fine',
            style: TextStyle(
              color: _isFormValid() ? Colors.white : AppColors.orange,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
