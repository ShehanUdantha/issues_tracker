import 'package:issues_tracker/screens/main/home/chart/individual_bar.dart';

class BarModel {
  final int openCount;
  final int progressCount;
  final int closedCount;

  BarModel({
    required this.openCount,
    required this.progressCount,
    required this.closedCount,
  });

  List<IndividualBar> barData = [];

  void initializedBarData() {
    barData = [
      IndividualBar(x: 0, y: openCount),
      IndividualBar(x: 1, y: progressCount),
      IndividualBar(x: 2, y: closedCount),
    ];
  }
}
