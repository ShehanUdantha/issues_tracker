import 'package:flutter/material.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';

class IssueScreen extends StatefulWidget {
  final String issueId;
  const IssueScreen({
    super.key,
    required this.issueId,
  });

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            AppSizes.defaultSpace,
          ),
          child: Column(
            children: [Text(widget.issueId)],
          ),
        ),
      )),
    );
  }
}
