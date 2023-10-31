// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectivityResult = ConnectivityResult.other;

  String get connectivityResult => _connectivityResult.name;

  void checkNetwork() {
    _connectivity.onConnectivityChanged.listen((event) {
      _connectivityResult = event;
      notifyListeners();
    });
  }
}
