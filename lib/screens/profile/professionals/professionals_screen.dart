import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/back_button.dart';
import 'services/associated_professionals_service.dart';
import 'widgets/professional_card.dart';
import 'widgets/empty_professionals_view.dart';

class AssociatedProfessionalsScreen extends StatefulWidget {
  const AssociatedProfessionalsScreen({super.key});

  @override
  AssociatedProfessionalsScreenState createState() =>
      AssociatedProfessionalsScreenState();
}

class AssociatedProfessionalsScreenState
    extends State<AssociatedProfessionalsScreen> {
  final AssociatedProfessionalsService _professionalsService =
      AssociatedProfessionalsService();
  List<Map<String, dynamic>> _allProfessionals = [];
  List<Map<String, dynamic>> _filteredProfessionals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssociatedProfessionals();
  }

  Future<void> _loadAssociatedProfessionals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final professionals =
          await _professionalsService.loadAssociatedProfessionals();

      setState(() {
        _allProfessionals = professionals;
        _filteredProfessionals = _allProfessionals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _allProfessionals = [];
        _filteredProfessionals = [];
        _isLoading = false;
      });

      _showErrorSnackBar('Errore nel caricamento: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _handleRemoveAssociation(int professionalId) async {
    try {
      await _professionalsService.removeAssociation(professionalId);

      _loadAssociatedProfessionals();
    } catch (e) {
      _showErrorSnackBar('Errore nella rimozione: ${e.toString()}');
    }
  }

  void _onProfessionalCardTap(int professionalId) {
    _professionalsService
        .navigateToProfessionalDetail(context, professionalId)
        .then((result) {
          if (result == true) {
            _loadAssociatedProfessionals();
          }
        });
  }

  void _handleAddProfessional() {
    _professionalsService.navigateToProfessionalEdit(context, null).then((
      result,
    ) {
      if (result == true) {
        _loadAssociatedProfessionals();
      }
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButtonWidget(onPressed: () => Navigator.of(context).pop()),
          IconButton(
            icon: const Icon(
              LucideIcons.plus,
              color: AppColors.orange,
              size: 28,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.orangeLight.withValues(alpha: 0.3),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(8),
            ),
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            onPressed: _handleAddProfessional,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadAssociatedProfessionals,
        color: AppColors.orange,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildHeader(),

            if (_isLoading)
              Container(
                height: MediaQuery.of(context).size.height - 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(color: AppColors.orange),
              )
            else if (_filteredProfessionals.isEmpty)
              Container(
                height: MediaQuery.of(context).size.height - 200,
                alignment: Alignment.center,
                child: EmptyProfessionalsView(
                  onAddPressed: _handleAddProfessional,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: List.generate(_filteredProfessionals.length, (
                    index,
                  ) {
                    final professional = _filteredProfessionals[index];
                    final professionalId = professional['id'] as int;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ProfessionalCard(
                        professional: professional,
                        onRemoveAssociation:
                            () => _handleRemoveAssociation(professionalId),
                        onTap: () => _onProfessionalCardTap(professionalId),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
