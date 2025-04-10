import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/categories_horizontal_model.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/categories_list.dart';
import 'services/pet_file_service.dart';
import 'widgets/pet_card_list.dart';
import 'widgets/empty_pets_view.dart';

class PetHomeScreen extends StatefulWidget {
  const PetHomeScreen({super.key});

  @override
  PetHomeScreenState createState() => PetHomeScreenState();
}

class PetHomeScreenState extends State<PetHomeScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  final PetFileService _petFileService = PetFileService();
  List<Map<String, dynamic>> _allPets = [];
  List<Map<String, dynamic>> _filteredPets = [];
  bool _isLoading = true;
  int _selectedIndex = 0;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _petFileService.initFileWatcher(onFileChanged: refresh);
    refresh();
  }

  Future<void> refresh() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final petsData = await _petFileService.loadPetsFromFile();

      if (!mounted) return;

      setState(() {
        _allPets = petsData;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _allPets = [];
        _filteredPets = [];
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredPets =
          _selectedCategory != null
              ? _allPets
                  .where((pet) => pet['category'] == _selectedCategory)
                  .toList()
              : _allPets;
    });
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredPets =
          _allPets
              .where(
                (pet) =>
                    pet['petName'].toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    pet['petBreed'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RefreshIndicator(
                onRefresh: refresh,
                color: AppColors.orange,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBarWidget(
                        onSearchChanged: _onSearchChanged,
                        screenIndex: _selectedIndex,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Categorie',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CategoriesHorizontalModel(
                        categories: animalCategories,
                        onCategorySelected: _onCategorySelected,
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 400,
                        child:
                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.orange,
                                  ),
                                )
                                : _filteredPets.isEmpty
                                ? const EmptyPetsView()
                                : PetCardList(pets: _filteredPets),
                      ),

                      const SizedBox(height: 103),
                    ],
                  ),
                ),
              ),
            ),

            BottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onNavItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}
