import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/app_colors.dart';

mixin PetDialogs<T extends StatefulWidget> on State<T> {
  void showPermissionDeniedDialog(BuildContext context, String permissionType) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Permesso negato'),
              content: Text(
                'L\'accesso alla $permissionType è necessario per questa funzionalità. '
                'Per favore, abilita i permessi nelle impostazioni del dispositivo.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annulla'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                  child: const Text('Impostazioni'),
                ),
              ],
            ),
      );
    }
  }

  void showModalBottomSheetForImageSource(
    BuildContext context,
    Function(ImageSource) onImageSourceSelected,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.orangeLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(LucideIcons.image, color: AppColors.orange),
                  title: const Text(
                    'Seleziona dalla galleria',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onImageSourceSelected(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(LucideIcons.camera, color: AppColors.orange),
                  title: const Text(
                    'Scatta una foto',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onImageSourceSelected(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOptionsMenu(
    BuildContext context,
    VoidCallback onEditPress,
    VoidCallback onDeletePress,
    Map<String, dynamic>? petData,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.orangeLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(LucideIcons.pencil, color: AppColors.orange),
                  title: const Text(
                    'Modifica dati animale',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onEditPress();
                  },
                ),
                ListTile(
                  leading: Icon(LucideIcons.fileText, color: AppColors.orange),
                  title: const Text(
                    'Scarica PDF animale',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    downloadPetDataAsPdf(context, petData: petData);
                  },
                ),
                ListTile(
                  leading: const Icon(LucideIcons.trash2, color: Colors.red),
                  title: const Text(
                    'Elimina animale',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onDeletePress();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDeleteConfirmationDialog(
    BuildContext context,
    String petName,
    VoidCallback onDeleteConfirmed,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.orangeLight,
            title: Text(
              'Vuoi davvero eliminare $petName?',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            content: const Text(
              'Una volta fatto, non potrai tornare indietro e tutti i dati andranno persi.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Annulla',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDeleteConfirmed();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text(
                  'Elimina',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> downloadPetDataAsPdf(
    BuildContext context, {
    Map<String, dynamic>? petData,
  }) async {
    final pet = petData ?? {};
    if (pet.isEmpty) {
      return;
    }

    try {
      pw.Widget? petImage;
      try {
        final imagePath = pet['petImagePath'] ?? pet['imagePath'];
        if (imagePath != null && imagePath.toString().isNotEmpty) {
          final file = File(imagePath);
          if (file.existsSync()) {
            final imageBytes = file.readAsBytesSync();
            final image = pw.MemoryImage(imageBytes);

            petImage = pw.Container(
              width: 200,
              height: 200,
              alignment: pw.Alignment.center,
              child: pw.Image(image, fit: pw.BoxFit.cover),
            );
          }
        }
      } catch (e) {
        petImage = null;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'Scheda Animale',
                    style: pw.TextStyle(fontSize: 24),
                  ),
                ),
                pw.SizedBox(height: 20),

                if (petImage != null) ...[
                  pw.Center(child: petImage),
                  pw.SizedBox(height: 20),
                ],

                if (pet['petName'] != null &&
                    pet['petName'].toString().isNotEmpty) ...[
                  pw.Text(
                    'Nome: ${pet['petName']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['petBreed'] != null &&
                    pet['petBreed'].toString().isNotEmpty) ...[
                  pw.Text(
                    'Razza: ${pet['petBreed']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['petColor'] != null &&
                    pet['petColor'].toString().isNotEmpty) ...[
                  pw.Text(
                    'Colore: ${pet['petColor']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['gender'] != null) ...[
                  pw.Text(
                    'Genere: ${pet['gender'] == 0 ? 'Maschio' : 'Femmina'}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['birthDate'] != null &&
                    pet['birthDate'].toString().isNotEmpty) ...[
                  pw.Text(
                    'Data di nascita: ${pet['birthDate']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['isSterilized'] != null) ...[
                  pw.Text(
                    'Sterilizzato: ${pet['isSterilized'] ? 'Sì' : 'No'}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['hasMicrochip'] != null) ...[
                  pw.Text(
                    'Microchip: ${pet['hasMicrochip'] ? 'Sì' : 'No'}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['hasMicrochip'] == true &&
                    pet['microchipNumber'] != null &&
                    pet['microchipNumber'].toString().isNotEmpty) ...[
                  pw.Text(
                    'Numero microchip: ${pet['microchipNumber']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['hasMicrochip'] == true &&
                    pet['microchipProvider'] != null &&
                    pet['microchipProvider'].toString().isNotEmpty) ...[
                  pw.Text(
                    'Fornitore microchip: ${pet['microchipProvider']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                if (pet['hasMicrochip'] == true &&
                    pet['microchipDate'] != null &&
                    pet['microchipDate'].toString().isNotEmpty) ...[
                  pw.Text(
                    'Data microchip: ${pet['microchipDate']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 10),
                ],

                pw.Divider(),
                pw.Text(
                  'Documento generato il ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} da Primary',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
              ],
            );
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final petName = pet['petName'] ?? 'animale';
      final fileName =
          '${petName.toString().replaceAll(' ', '_').toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${output.path}/$fileName');

      await file.writeAsBytes(await pdf.save());
      final filePath = file.path;

      if (context.mounted) {
        showDialog(
          context: context,
          builder:
              (dialogContext) => AlertDialog(
                backgroundColor: AppColors.orangeLight,
                title: const Text('PDF Generato'),
                content: const Text(
                  'Il file PDF è stato generato con successo.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text(
                      'Chiudi',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      OpenFile.open(filePath);
                    },
                    child: Text(
                      'Apri PDF',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder:
              (errorContext) => AlertDialog(
                title: const Text('Errore'),
                content: const Text(
                  'Si è verificato un errore nella generazione del PDF.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(errorContext).pop(),
                    child: const Text('Chiudi'),
                  ),
                ],
              ),
        );
      }
    }
  }

  int min(int a, int b) {
    return a < b ? a : b;
  }
}
