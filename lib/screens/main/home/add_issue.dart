// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:issues_tracker/common/widgets/priority_label.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/providers/network_provider.dart';
import 'package:issues_tracker/providers/status_provider.dart';
import 'package:issues_tracker/screens/network_screen.dart';
import 'package:issues_tracker/services/issue_methods.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class AddIssue extends StatefulWidget {
  final userId;
  final profileImage;
  const AddIssue({
    super.key,
    this.userId,
    this.profileImage,
  });

  @override
  State<AddIssue> createState() => _AddIssueState();
}

class _AddIssueState extends State<AddIssue> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String priority = 'Low';
  String errMessage = '';
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void createNewIssue() async {
    // validate title and description empty or not before send it into the firebase

    if (_titleController.text.isNotEmpty) {
      if (_descriptionController.text.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        String response = await IssueMethods().createNewIssue(
          ownerId: widget.userId,
          profileImage: widget.profileImage,
          title: _titleController.text,
          description: _descriptionController.text,
          priority: priority,
        );
        setState(() {
          isLoading = false;
        });

        // refresh issue status details when user add new issue
        Provider.of<StatusProvider>(context, listen: false).initializedStatus();

        Navigator.pop(context);

        if (response == null) {
          print(response);
        }
      } else {
        setState(() {
          errMessage = 'Description is required';
        });
      }
    } else {
      setState(() {
        errMessage = 'Title is required';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
        builder: (context, networkProvider, child) {
      return networkProvider.connectivityResult == 'none'
          ? const NetworkScreen()
          : Padding(
              padding: const EdgeInsets.all(
                AppSizes.defaultSpace,
              ).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 400.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
// form section
                    Form(
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            onChanged: (value) {
                              setState(() {
                                errMessage = '';
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Title',
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.spaceBtwInputFields,
                          ),
                          TextField(
                            controller: _descriptionController,
                            maxLines: 5,
                            onChanged: (value) {
                              setState(() {
                                errMessage = '';
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Description',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.spaceBtwInputFields,
                    ),
// priority level section
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              priority = 'Low';
                            });
                          },
                          child: PriorityLabel(
                            title: 'Low',
                            bgColor: priority == 'Low'
                                ? HelperFunction().priorityColor(
                                    'Low',
                                    'bg',
                                  )
                                : AppColors.selectBg,
                            textColor: priority == 'Low'
                                ? HelperFunction().priorityColor(
                                    'Low',
                                    'text',
                                  )
                                : AppColors.selectText,
                          ),
                        ),
                        const SizedBox(
                          width: AppSizes.spaceBtwInputFields,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              priority = 'Medium';
                            });
                          },
                          child: PriorityLabel(
                            title: 'Medium',
                            bgColor: priority == 'Medium'
                                ? HelperFunction().priorityColor(
                                    'Medium',
                                    'bg',
                                  )
                                : AppColors.selectBg,
                            textColor: priority == 'Medium'
                                ? HelperFunction().priorityColor(
                                    'Medium',
                                    'text',
                                  )
                                : AppColors.selectText,
                          ),
                        ),
                        const SizedBox(
                          width: AppSizes.spaceBtwInputFields,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              priority = 'High';
                            });
                          },
                          child: PriorityLabel(
                            title: 'High',
                            bgColor: priority == 'High'
                                ? HelperFunction().priorityColor(
                                    'High',
                                    'bg',
                                  )
                                : AppColors.selectBg,
                            textColor: priority == 'High'
                                ? HelperFunction().priorityColor(
                                    'High',
                                    'text',
                                  )
                                : AppColors.selectText,
                          ),
                        ),
                      ],
                    ),
// error message display section
                    errMessage != ''
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              errMessage,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: AppSizes.fontSizeXs,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections,
                    ),
//data submitted button
                    ElevatedButton(
                      onPressed: createNewIssue,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.textWhite,
                              ),
                            )
                          : const Text('Create Issue'),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
