import 'package:flutter/material.dart';
import 'app/primary_app.dart';

void main() async {
  await PrimaryApp.initializeApp();
  runApp(const PrimaryApp());
}
