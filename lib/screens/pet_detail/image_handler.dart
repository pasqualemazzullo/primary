import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'data_manager.dart';
import 'dialogs.dart';

mixin PetImageHandler<T extends StatefulWidget>
    on State<T>, PetDataManager<T>, PetDialogs<T> {
  final ImagePicker _picker = ImagePicker();

  Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      showPermissionDeniedDialog(context, 'fotocamera');
      return false;
    }

    status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestPhotosPermission() async {
    if (await Permission.photos.status.isGranted) {
      return true;
    }

    if (await Permission.photos.status.isPermanentlyDenied) {
      if (!mounted) return false;
      showPermissionDeniedDialog(context, 'galleria');
      return false;
    }

    var status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<void> pickImage(ImageSource source) async {
    bool permissionGranted = false;

    if (source == ImageSource.camera) {
      permissionGranted = await requestCameraPermission();
    } else {
      permissionGranted = await requestPhotosPermission();
    }

    if (!permissionGranted) {
      return;
    }

    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final String permanentPath = await savePermanentCopy(pickedFile.path);

      if (!mounted) return;
      setState(() {});

      await saveImagePath(permanentPath);
    }
  }

  Future<String> savePermanentCopy(String tempPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName =
        'pet_${petId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String newPath = '${directory.path}/images/$fileName';

    final imageDir = Directory('${directory.path}/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final File tempFile = File(tempPath);
    final File newFile = await tempFile.copy(newPath);

    return newFile.path;
  }

  void showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheetForImageSource(context, pickImage);
  }
}
