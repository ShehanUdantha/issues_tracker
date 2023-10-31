// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:issues_tracker/services/issue_methods.dart';

class StatusProvider with ChangeNotifier {
  int _openCount = 0;
  int _progressCount = 0;
  int _closedCount = 0;

  int get openCount => _openCount;
  int get progressCount => _progressCount;
  int get closedCount => _closedCount;

  void initializedStatus() async {
    int openLength = await IssueMethods().getStatusLength('Open');
    int progressLength = await IssueMethods().getStatusLength('In Progress');
    int closedLength = await IssueMethods().getStatusLength('Closed');

    _openCount = openLength;
    _progressCount = progressLength;
    _closedCount = closedLength;

    notifyListeners();
  }

  void setDefault() {
    _openCount = 0;
    _progressCount = 0;
    _closedCount = 0;
  }
}
