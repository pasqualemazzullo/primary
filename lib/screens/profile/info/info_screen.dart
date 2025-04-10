import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../widgets/back_button.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: BackButtonWidget(
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(72.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: OverflowBox(
                        maxWidth: 200,
                        maxHeight: 200,
                        child: Image.asset(
                          'assets/image_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Primary",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Versione 1.0.0",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 48),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Made with", style: TextStyle(fontSize: 16)),
                        SizedBox(width: 4),
                        Icon(LucideIcons.heart, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text("by", style: TextStyle(fontSize: 16)),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Pasquale Mazzullo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "[MAT. 170006]",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Esame di Progettazione di Applicazioni Mobili",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Università degli Studi di Udine",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
