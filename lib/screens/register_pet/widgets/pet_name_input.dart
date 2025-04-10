import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import '../../../providers/register_pet_provider.dart';

class PetNameInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, String?) onChanged;
  final String? error;

  const PetNameInput({
    super.key,
    required this.controller,
    required this.onChanged,
    this.error,
  });

  @override
  State<PetNameInput> createState() => _PetNameInputState();
}

class _PetNameInputState extends State<PetNameInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    final String text = widget.controller.text;
    String? error;

    if (text.isNotEmpty && widget.error != null) {
      error = null;
    }

    widget.onChanged(text, error);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Mr. Rocky',
              hintStyle: TextStyle(color: AppColors.grey300),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              Provider.of<RegisterPetProvider>(context, listen: false).petName =
                  value;
            },
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
