import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widgets/pet_cards.dart';
import 'page_indicator.dart';

class PetCardList extends StatefulWidget {
  final List<Map<String, dynamic>> pets;

  const PetCardList({super.key, required this.pets});

  @override
  State<PetCardList> createState() => _PetCardListState();
}

class _PetCardListState extends State<PetCardList> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final ValueNotifier<double> _pageNotifier = ValueNotifier<double>(0.0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification &&
                  _pageController.hasClients) {
                _pageNotifier.value = _pageController.page ?? 0;
              }
              return true;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.pets.length,
              onPageChanged: (page) {
                _pageNotifier.value = page.toDouble();
              },
              itemBuilder: (context, index) {
                final pet = widget.pets[index];
                return _buildPetCard(pet);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        PageIndicator(
          pageCount: widget.pets.length,
          pageNotifier: _pageNotifier,
        ),
      ],
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: PetCardWidget(
        petId: pet['id'],
        name: pet['petName'],
        breed: pet['petBreed'],
        age:
            pet['birthDate'] != null
                ? DateFormat(
                  'dd/MM/yyyy',
                ).format(DateTime.parse(pet['birthDate']))
                : null,
        imageUrl: pet['petImagePath'],
        gender: pet['gender'],
      ),
    );
  }
}
