import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';

import '../theme/app_colors.dart';
import '../screens/register_pet/screens/register_pet_1_screen.dart';
import '../screens/appointment/appointment_pet_screen.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onAppointmentAdded;
  final int screenIndex;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
    this.onAppointmentAdded,
    required this.screenIndex,
  });

  @override
  State<SearchBarWidget> createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  late File _file;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initFile();
    searchController.addListener(() {
      widget.onSearchChanged(searchController.text);
    });
  }

  Future<void> _initFile() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _file = File('${directory.path}/pet_data.json');
    });
  }

  Future<void> _addNewPet() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPet1Screen()),
    );
  }

  Future<void> _addNewAppointment() async {
    if (!mounted) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppointmentPetScreen()),
    );

    if (result == true &&
        context.mounted &&
        widget.onAppointmentAdded != null) {
      widget.onAppointmentAdded!();
    }
  }

  Future<void> _resetPets() async {
    if (!mounted) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.orangeLight,
          title: const Text(
            'Vuoi davvero svuotare tutte le cucce?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Una volta fatto, non potrai tornare indietro e tutti i dati andranno persi.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Annulla',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Svuota tutte',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      if (await _file.exists()) {
        await _file.writeAsString('[]');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.orange,
            content: Row(
              children: [
                Icon(LucideIcons.circleCheck, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Tutte le cucce sono state liberate!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Errore durante il reset: $e',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resetAppointments() async {
    if (!mounted) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.orangeLight,
          title: const Text(
            'Vuoi davvero rimuovere tutti gli appuntamenti?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text('Questa azione non può essere annullata.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Annulla',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Rimuovi tutti',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      if (await _file.exists()) {
        String contents = await _file.readAsString();

        List<Map<String, dynamic>> pets =
            (jsonDecode(contents) as List).cast<Map<String, dynamic>>();

        for (var pet in pets) {
          pet['appointments'] = [];
        }

        await _file.writeAsString(jsonEncode(pets));

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.orange,
            content: Row(
              children: [
                Icon(LucideIcons.circleCheck, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Tutti gli appuntamenti sono stati rimossi!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );

        if (widget.onAppointmentAdded != null) {
          widget.onAppointmentAdded!();
        }
      }
    } catch (e) {
      // Non succede niente.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Cerca i tuoi animali',
              prefixIcon: Icon(LucideIcons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFFF5F5F5),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(100),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(
              LucideIcons.slidersHorizontal,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: AppColors.orangeLight,
            onSelected: (String value) {
              switch (value) {
                case 'addPet':
                  _addNewPet();
                  break;
                case 'addAppointment':
                  _addNewAppointment();
                  break;
                case 'resetPets':
                  _resetPets();
                  break;
                case 'resetAppointments':
                  _resetAppointments();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              List<String> visibleItems = [];

              switch (widget.screenIndex) {
                case 0:
                  visibleItems = ['addPet', 'resetPets'];
                  break;
                case 1:
                  visibleItems = ['addPet', 'resetPets'];
                  break;
                case 2:
                  visibleItems = ['addAppointment', 'resetAppointments'];
                  break;
                default:
                  visibleItems = ['addPet', 'addAppointment'];
              }

              List<PopupMenuItem<String>> allItems = [
                PopupMenuItem<String>(
                  value: 'addPet',
                  child: Row(
                    children: [
                      Icon(LucideIcons.plus, color: AppColors.orange),
                      const SizedBox(width: 8),
                      const Text(
                        'Aggiungi un nuovo amico',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'addAppointment',
                  child: Row(
                    children: [
                      Icon(LucideIcons.plus, color: AppColors.orange),
                      const SizedBox(width: 8),
                      const Text(
                        'Aggiungi appuntamento',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'resetPets',
                  child: Row(
                    children: [
                      const Icon(LucideIcons.trash2, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text(
                        'Libera tutte le cucce',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'resetAppointments',
                  child: Row(
                    children: [
                      const Icon(LucideIcons.calendarX, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text(
                        'Libera tutti gli appuntamenti',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ];

              return allItems
                  .where((item) => visibleItems.contains(item.value))
                  .toList();
            },
          ),
        ),
      ],
    );
  }
}
