import 'package:flutter/material.dart';

class RegisterPetProvider with ChangeNotifier {
  String _petName = '';
  DateTime _birthDate = DateTime.now();
  int _gender = 0;
  String? _category;
  String _petBreed = '';
  String _petColor = '';

  String get petName => _petName;
  DateTime get birthDate => _birthDate;
  int get gender => _gender;
  String? get category => _category;
  String get petBreed => _petBreed;
  String get petColor => _petColor;

  set petName(String value) {
    _petName = value;
    notifyListeners();
  }

  set birthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  set gender(int value) {
    _gender = value;
    notifyListeners();
  }

  set category(String? value) {
    _category = value;
    notifyListeners();
  }

  set petBreed(String value) {
    _petBreed = value;
    notifyListeners();
  }

  set petColor(String value) {
    _petColor = value;
    notifyListeners();
  }
}
