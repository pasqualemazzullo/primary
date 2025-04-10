import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class MonthSelector extends StatelessWidget {
  final int currentMonth;
  final Function(int) onMonthSelected;

  const MonthSelector({
    super.key,
    required this.currentMonth,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(12, (index) {
            int month = index + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildMonthButton(month, _getMonthNames()[index]),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMonthButton(int month, String monthName) {
    final bool isSelected = month == currentMonth;

    return GestureDetector(
      onTap: () => onMonthSelected(month),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange : Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          monthName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  List<String> _getMonthNames() {
    return [
      'Gen',
      'Feb',
      'Mar',
      'Apr',
      'Mag',
      'Giu',
      'Lug',
      'Ago',
      'Set',
      'Ott',
      'Nov',
      'Dic',
    ];
  }
}
