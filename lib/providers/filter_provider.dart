// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  String _selectedStatus = '';
  String _selectedPriority = '';

  String get selectedStatus => _selectedStatus;
  String get selectedPriority => _selectedPriority;

  void updateStatus(String newStates) {
    _selectedStatus = newStates;
    notifyListeners();
  }

  void updatePriority(String newPriority) {
    _selectedPriority = newPriority;
    notifyListeners();
  }
}
