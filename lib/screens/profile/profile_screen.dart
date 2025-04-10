import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/bottom_nav_bar.dart';
import 'widgets/profile_menu_item.dart';
import 'info/info_screen.dart';
import 'professionals/professionals_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openProfessionisti() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssociatedProfessionalsScreen(),
      ),
    );
  }

  void _openInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppInfoScreen()),
    );
  }

  void _openFeedback() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        ProfileMenuItem(
                          title: 'Professionisti',
                          subtitle:
                              'Aggiungi veterinari, toelettatori e altri servizi',
                          icon: LucideIcons.users,
                          onTap: _openProfessionisti,
                        ),
                        const SizedBox(height: 16),

                        ProfileMenuItem(
                          title: 'Info',
                          subtitle: 'Informazioni sull\'app e assistenza',
                          icon: LucideIcons.info,
                          onTap: _openInfo,
                        ),
                        const SizedBox(height: 16),

                        ProfileMenuItem(
                          title: 'Feedback',
                          subtitle: 'Condividi la tua opinione sull\'app',
                          icon: LucideIcons.messageSquare,
                          onTap: _openFeedback,
                        ),
                      ],
                    ),
                  ),
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
