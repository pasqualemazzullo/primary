import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_colors.dart';
import '../edit_pet/edit_pet_screen.dart';
import '../../widgets/back_button.dart';

import 'data_manager.dart';
import 'image_handler.dart';
import 'ui_components.dart';
import 'dialogs.dart';
import 'appointments_section.dart';

class PetDetailScreen extends StatefulWidget {
  final int petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  PetDetailScreenState createState() => PetDetailScreenState();
}

class PetDetailScreenState extends State<PetDetailScreen>
    with
        PetDataManager<PetDetailScreen>,
        PetDialogs<PetDetailScreen>,
        PetImageHandler<PetDetailScreen>,
        PetUIComponents<PetDetailScreen>,
        PetAppointmentsSection<PetDetailScreen> {
  @override
  void initState() {
    super.initState();
    petId = widget.petId;
    initializeDateFormatting('it', null);
    loadPetDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loadPetDetails();
  }

  void _navigateToEditPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPetScreen(petData: petData!)),
    );

    if (result != null) {
      setState(() {});

      await loadPetDetails();
    }
  }

  void _handleDeletePressed() {
    showDeleteConfirmationDialog(
      context,
      petData?['petName'] ?? 'questo animale',
      () => deletePet(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double backButtonHeight = 86.0;
    final double safeAreaTop = statusBarHeight + backButtonHeight + 16.0;
    final double maxSize =
        1.0 - (safeAreaTop / MediaQuery.of(context).size.height);

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => showImageSourceActionSheet(context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                petImagePath != null
                    ? Image.file(
                      File(petImagePath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                    )
                    : Image.asset(
                      'assets/image_placeholder.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: maxSize,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.orange,
                          ),
                        )
                        : petData == null
                        ? buildPetNotFoundUI(context)
                        : SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 5,
                                    margin: const EdgeInsets.only(bottom: 24),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        petData?['petName'] ?? 'Senza nome',
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: toggleFavorite,
                                          icon: Icon(
                                            LucideIcons.heart,
                                            color:
                                                isFavorite
                                                    ? Colors.white
                                                    : AppColors.orange,
                                            size: 28,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor:
                                                isFavorite
                                                    ? AppColors.orange
                                                    : Colors.white,
                                            shape: const CircleBorder(
                                              side: BorderSide(
                                                color: AppColors.orange,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed:
                                              () => showOptionsMenu(
                                                context,
                                                _navigateToEditPet,
                                                _handleDeletePressed,
                                                petData,
                                              ),
                                          icon: Icon(
                                            LucideIcons.ellipsis,
                                            color: AppColors.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                buildLocationSection(),

                                const SizedBox(height: 20),

                                buildBasicInfoSection(),

                                buildMicrochipSection(),

                                const SizedBox(height: 24),

                                Divider(color: AppColors.grey300, thickness: 1),

                                const SizedBox(height: 16),

                                buildAppointmentsSection(context),

                                const Divider(
                                  color: AppColors.grey300,
                                  thickness: 1,
                                ),

                                const SizedBox(height: 16),

                                buildVeterinarianSection(),

                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButtonWidget(onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
