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
              Expanded(
                child: Text(
                  _issueModel.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(fontSizeDelta: 3),
                ),
              ),
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
                  PriorityLabel(
                    bgColor: _issueModel.status == 'Open'
                        ? AppColors.hightBg
                        : _issueModel.status == 'In Progress'
                            ? AppColors.progBg
                            : AppColors.selectBg,
                    textColor: _issueModel.status == 'Open'
                        ? AppColors.highText
                        : _issueModel.status == 'In Progress'
                            ? AppColors.progText
                            : AppColors.selectText,
                    title: _issueModel.status,
                    fontSize: 14.0,
                  ),
                  const SizedBox(
                    width: AppSizes.spaceBtwItems,
                  ),
                  PriorityLabel(
                    bgColor: _issueModel.priority == 'High'
                        ? AppColors.hightBg
                        : _issueModel.priority == 'Medium'
                            ? AppColors.mediumBg
                            : AppColors.lowBg,
                    textColor: _issueModel.priority == 'High'
                        ? AppColors.highText
                        : _issueModel.priority == 'Medium'
                            ? AppColors.mediumText
                            : AppColors.lowText,
                    title: _issueModel.priority,
                    fontSize: 14.0,
                  ),
                ],
              ),
              Text(
                HelperFunction().formatDate(
                  _issueModel.postedDate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
