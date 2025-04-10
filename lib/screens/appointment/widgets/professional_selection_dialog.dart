import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/professional.dart';
import '../../../../theme/app_colors.dart';

class ProfessionalSelectionDialog extends StatefulWidget {
  final List<Professional> availableProfessionals;
  final Professional? selectedProfessional;

  const ProfessionalSelectionDialog({
    super.key,
    required this.availableProfessionals,
    this.selectedProfessional,
  });

  @override
  ProfessionalSelectionDialogState createState() =>
      ProfessionalSelectionDialogState();
}

class ProfessionalSelectionDialogState
    extends State<ProfessionalSelectionDialog> {
  late Professional? _selectedProfessional;
  final TextEditingController _searchController = TextEditingController();
  List<Professional> _filteredProfessionals = [];

  @override
  void initState() {
    super.initState();
    _selectedProfessional = widget.selectedProfessional;
    _filteredProfessionals = List.from(widget.availableProfessionals);

    _searchController.addListener(_filterProfessionals);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProfessionals);
    _searchController.dispose();
    super.dispose();
  }

  void _filterProfessionals() {
    final String query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredProfessionals = List.from(widget.availableProfessionals);
      } else {
        _filteredProfessionals =
            widget.availableProfessionals
                .where(
                  (professional) =>
                      professional.name.toLowerCase().contains(query) ||
                      professional.specialty.toLowerCase().contains(query),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.orangeLight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Seleziona un professionista',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cerca professionista...',
                  border: InputBorder.none,
                  icon: Icon(LucideIcons.search, color: AppColors.grey600),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child:
                    _filteredProfessionals.isEmpty
                        ? Center(
                          child: Text(
                            'Nessun professionista trovato',
                            style: TextStyle(color: AppColors.grey600),
                          ),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredProfessionals.length,
                          itemBuilder: (context, index) {
                            final professional = _filteredProfessionals[index];
                            final isSelected =
                                _selectedProfessional?.id == professional.id;

                            IconData specialtyIcon;
                            switch (professional.specialty.toLowerCase()) {
                              case 'veterinario':
                                specialtyIcon = LucideIcons.stethoscope;
                                break;
                              case 'toelettatore':
                                specialtyIcon = LucideIcons.scissors;
                                break;
                              case 'pet sitter':
                                specialtyIcon = LucideIcons.house;
                                break;
                              default:
                                specialtyIcon = LucideIcons.userCheck;
                            }

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedProfessional = professional;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.orangeLight.withValues(
                                            alpha: 0.3,
                                          )
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.orangeLight
                                          .withValues(alpha: 0.3),
                                      backgroundImage:
                                          professional.imagePath != null &&
                                                  File(
                                                    professional.imagePath!,
                                                  ).existsSync()
                                              ? FileImage(
                                                File(professional.imagePath!),
                                              )
                                              : null,
                                      child:
                                          professional.imagePath == null ||
                                                  !File(
                                                    professional.imagePath!,
                                                  ).existsSync()
                                              ? Icon(
                                                LucideIcons.user,
                                                color: AppColors.orange,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            professional.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                specialtyIcon,
                                                size: 14,
                                                color: AppColors.grey600,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                professional.specialty,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.grey600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    if (isSelected)
                                      Icon(
                                        LucideIcons.circleCheck,
                                        color: AppColors.orange,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Annulla',
                    style: TextStyle(color: AppColors.grey600),
                  ),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(_selectedProfessional),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Conferma'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
