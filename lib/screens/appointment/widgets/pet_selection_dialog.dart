import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../models/pet.dart';

class PetSelectionDialog extends StatefulWidget {
  final List<Pet> availablePets;
  final List<Pet> selectedPets;

  const PetSelectionDialog({
    super.key,
    required this.availablePets,
    required this.selectedPets,
  });

  @override
  State<PetSelectionDialog> createState() => _PetSelectionDialogState();
}

class _PetSelectionDialogState extends State<PetSelectionDialog> {
  late List<Pet> selectedPets;

  @override
  void initState() {
    super.initState();
    selectedPets = List.from(widget.selectedPets);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.orangeLight,
      title: const Text('Seleziona animali'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.availablePets.isEmpty)
              const Text('Nessun animale disponibile'),

            ...widget.availablePets.map((pet) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(pet.name),
                  Checkbox(
                    value: selectedPets.contains(pet),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedPets.add(pet);
                        } else {
                          selectedPets.remove(pet);
                        }
                      });
                    },
                    activeColor: AppColors.orange,
                    checkColor: Colors.white,
                  ),
                ],
              );
            }),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(selectedPets),
                child: const Text(
                  'Continua',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
