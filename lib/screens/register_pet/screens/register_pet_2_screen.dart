import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/back_button.dart';
import 'register_pet_3_screen.dart';
import '../widgets/category_grid.dart';
import '../widgets/continue_button.dart';

class RegisterPet2Screen extends StatefulWidget {
  const RegisterPet2Screen({super.key});

  @override
  State<RegisterPet2Screen> createState() => _RegisterPet2ScreenState();
}

class _RegisterPet2ScreenState extends State<RegisterPet2Screen> {
  final _formKey = GlobalKey<FormState>();
  bool _isCategorySelected = false;

  void _onCategorySelectionChanged(bool isSelected) {
    setState(() {
      _isCategorySelected = isSelected;
    });
  }

  void _submitForm() {
    if (_isCategorySelected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPet3Screen()),
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

                          CategoryGrid(
                            onSelectionChanged: _onCategorySelectionChanged,
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
                child: ContinueButton(
                  onPressed: _submitForm,
                  isEnabled: _isCategorySelected,
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
            "Scegli un tipo di animale domestico",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "Seleziona una categoria di animali per identificare il tuo animale domestico.",
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
