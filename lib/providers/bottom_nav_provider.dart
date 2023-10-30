// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class BottomNavigationProvider with ChangeNotifier {
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  void updateIndex(int newIndex) {
    _pageIndex = newIndex;
    notifyListeners();
  }

  void setDefault() {
    _pageIndex = 0;
  }
}
