import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../screens/home/pet_home_screen.dart';
import '../screens/favorites/pet_favourite_screen.dart';
import '../screens/calendar/pet_calendar_screen.dart';
import '../screens/profile/profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem(LucideIcons.house, 0, context),
              const SizedBox(width: 16),
              _buildNavItem(LucideIcons.heart, 1, context),
              const SizedBox(width: 16),
              _buildNavItem(LucideIcons.calendar, 2, context),
              const SizedBox(width: 16),
              _buildNavItem(LucideIcons.user, 3, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, BuildContext context) {
    bool isSelected = selectedIndex == index;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: Icon(icon, color: isSelected ? Colors.white : AppColors.grey400),
        onPressed: () {
          onItemTapped(index);
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const PetHomeScreen(),
                transitionDuration: Duration.zero,
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const PetFavouriteScreen(),
                transitionDuration: Duration.zero,
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const PetCalendarScreen(),
                transitionDuration: Duration.zero,
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) => ProfileScreen(),
                transitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
    );
  }
}
