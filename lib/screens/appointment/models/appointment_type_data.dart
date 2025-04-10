import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppointmentTypeData {
  final String name;
  final IconData icon;

  AppointmentTypeData(this.name, this.icon);

  static List<AppointmentTypeData> getDefaultTypes() {
    return [
      AppointmentTypeData("Controllo", LucideIcons.activity),
      AppointmentTypeData("Bagno", LucideIcons.bath),
      AppointmentTypeData("Compleanno", LucideIcons.gift),
      AppointmentTypeData("Esercizio", LucideIcons.volleyball),
      AppointmentTypeData("Pulci", LucideIcons.sprayCan),
      AppointmentTypeData("Cibo", LucideIcons.bone),
      AppointmentTypeData("Toelettatura", LucideIcons.sparkles),
      AppointmentTypeData("Medicinale", LucideIcons.pill),
      AppointmentTypeData("Chirurgia", LucideIcons.building2),
      AppointmentTypeData("Trattamento", LucideIcons.handshake),
      AppointmentTypeData("Vaccino", LucideIcons.syringe),
      AppointmentTypeData("Passeggiata", LucideIcons.pawPrint),
      AppointmentTypeData("Peso", LucideIcons.scale),
      AppointmentTypeData("Sverminazione", LucideIcons.bug),
      AppointmentTypeData("Altro", LucideIcons.circle),
    ];
  }
}
