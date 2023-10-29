import 'package:flutter/material.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';

class PriorityLabel extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;
  final double fontSize;
  const PriorityLabel({
    super.key,
    required this.title,
    required this.bgColor,
    required this.textColor,
    this.fontSize = AppSizes.fontSizeXs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 5.0,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
