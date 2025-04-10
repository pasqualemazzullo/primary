import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'common_card.dart';

class NotesCard extends StatelessWidget {
  final String notes;

  const NotesCard({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      title: 'Note',
      icon: LucideIcons.fileText,
      content: Text(notes, style: const TextStyle(fontSize: 16, height: 1.5)),
    );
  }
}
