// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:issues_tracker/common/widgets/priority_label.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/models/issue_model.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';

class IssueCard extends StatefulWidget {
  final snap;
  const IssueCard({super.key, this.snap});

  @override
  State<IssueCard> createState() => _IssueCardState();
}

class _IssueCardState extends State<IssueCard> {
  @override
  Widget build(BuildContext context) {
    IssueModel _issueModel = IssueModel.getValueFromSnapshot(widget.snap);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      padding: const EdgeInsets.all(
        AppSizes.spaceBtwItems,
      ),
      margin: const EdgeInsets.only(
        bottom: AppSizes.spaceBtwItems,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//  title
              Expanded(
                child: Text(
                  _issueModel.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(fontSizeDelta: 3),
                ),
              ),
              // profile picture
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  _issueModel.profileImage,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSizes.md,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // status label
                  PriorityLabel(
                    title: _issueModel.status,
                    bgColor: HelperFunction().statusColor(
                      _issueModel.status,
                      'bg',
                    ),
                    textColor: HelperFunction().statusColor(
                      _issueModel.status,
                      'text',
                    ),
                    fontSize: 14.0,
                  ),
                  const SizedBox(
                    width: AppSizes.spaceBtwItems,
                  ),
// priority label
                  PriorityLabel(
                    title: _issueModel.priority,
                    bgColor: HelperFunction().priorityColor(
                      _issueModel.priority,
                      'bg',
                    ),
                    textColor: HelperFunction().priorityColor(
                      _issueModel.priority,
                      'text',
                    ),
                    fontSize: 14.0,
                  ),
                ],
              ),
              // posted date
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    HelperFunction().formatDate(
                      _issueModel.postedDate,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
