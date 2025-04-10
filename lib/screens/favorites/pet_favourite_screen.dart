import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'services/favorites_service.dart';
import 'widgets/favorite_pet_card.dart';
import 'widgets/empty_favorites_view.dart';

class PetFavouriteScreen extends StatefulWidget {
  const PetFavouriteScreen({super.key});

  @override
  PetFavouriteScreenState createState() => PetFavouriteScreenState();
}

class PetFavouriteScreenState extends State<PetFavouriteScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  int _selectedIndex = 1;
  List<Map<String, dynamic>> _allFavPets = [];
  List<Map<String, dynamic>> _filteredFavPets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavouritePets();
  }

  Future<void> _loadFavouritePets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favPets = await _favoritesService.loadFavoritePets();

      setState(() {
        _allFavPets = favPets;
        _filteredFavPets = _allFavPets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _allFavPets = [];
        _filteredFavPets = [];
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredFavPets =
          _allFavPets
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

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleRemoveFavorite(int petId) async {
    await _favoritesService.removeFavorite(petId);
    _loadFavouritePets();
  }

  void _onPetCardTap(int petId) {
    _favoritesService.navigateToPetDetail(context, petId).then((_) {
      _loadFavouritePets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadFavouritePets,
              color: AppColors.orange,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                children: [
                  SearchBarWidget(
                    onSearchChanged: _onSearchChanged,
                    screenIndex: _selectedIndex,
                  ),
                  const SizedBox(height: 20),

                  if (_isLoading)
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: AppColors.orange,
                      ),
                    )
                  else if (_filteredFavPets.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height - 300,
                      child: const EmptyFavoritesView(),
                    )
                  else
                    ...List.generate(_filteredFavPets.length, (index) {
                      final pet = _filteredFavPets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: FavoritePetCard(
                          pet: pet,
                          onRemoveFavorite:
                              () => _handleRemoveFavorite(pet['id']),
                          onTap: () => _onPetCardTap(pet['id']),
                        ),
                      );
                    }),

                  const SizedBox(height: 80),
                ],
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
