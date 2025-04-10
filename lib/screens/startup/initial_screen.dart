import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../theme/app_colors.dart';
import '../welcome/welcome_screen.dart';
import '../home/pet_home_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  Future<bool> _hasPetsSaved() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pet_data.json');

    if (await file.exists()) {
      try {
        final fileData = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);
        return jsonData.isNotEmpty;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasPetsSaved(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          return const WelcomeScreen();
        } else {
          return const PetHomeScreen();
        }
      },
    );
  }
}
