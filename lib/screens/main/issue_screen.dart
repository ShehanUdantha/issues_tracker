// ignore_for_file: unnecessary_null_comparison, avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:issues_tracker/common/widgets/priority_label.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/providers/network_provider.dart';
import 'package:issues_tracker/providers/status_provider.dart';
import 'package:issues_tracker/providers/user_provider.dart';
import 'package:issues_tracker/screens/network_screen.dart';
import 'package:issues_tracker/services/issue_methods.dart';
import 'package:issues_tracker/services/user_methods.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

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
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String ownerId = '';
  String profileImage = '';
  String postedDate = '';
  String title = '';
  String description = '';
  String priority = '';
  String status = '';
  bool isLoading = false;
  bool isSubmitLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    setIssueDetails();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void setIssueDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // get issue details
      var response = await IssueMethods().getIssueData(
        issueId: widget.issueId,
      );

      if (response != null) {
        setState(() {
          ownerId = response.ownerId;
          profileImage = response.profileImage;
          postedDate = HelperFunction().formatDate(response.postedDate);
          title = response.title;
          description = response.description;
          priority = response.priority;
          status = response.status;
          _titleController.text = response.title;
          _descriptionController.text = response.description;
        });
      }
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  void clickedEditButton() async {
    if (isEdit) {
      // validate text field before calling to the firebase
      if (_titleController.text.isNotEmpty) {
        if (_descriptionController.text.isNotEmpty) {
          setState(() {
            isSubmitLoading = true;
          });
          UserModel owner = await UserMethods().getUserDetails(userId: ownerId);

          String response = await IssueMethods().updateIssueData(
            issueId: widget.issueId,
            ownerId: ownerId,
            profileImage: owner.userProfile,
            title: _titleController.text,
            description: _descriptionController.text,
            priority: priority,
            status: status,
          );

          setState(() {
            isSubmitLoading = false;
          });

          // refresh issue status details when user add new issue
          Provider.of<StatusProvider>(context, listen: false)
              .initializedStatus();

          if (ownerId !=
              Provider.of<UserProvider>(context, listen: false).getUserId) {
            Navigator.pop(context);
          }

          if (response == null) {
            print(response);
          }
        } else {
          HelperFunction().showSnackBar(
            context,
            'Description is required',
          );
        }
      } else {
        HelperFunction().showSnackBar(
          context,
          'Title is required',
        );
      }
    }
    setState(() {
      isEdit = !isEdit;
    });
  }

  void clickedDeleteButton() async {
    String response = await IssueMethods().deleteIssueData(
      issueId: widget.issueId,
    );

    if (response == 'Success') {
      // refresh issue status details when user add new issue
      Provider.of<StatusProvider>(context, listen: false).initializedStatus();
      Navigator.pop(context);
    } else {
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(),
      body:
          Consumer<NetworkProvider>(builder: (context, networkProvider, child) {
        return networkProvider.connectivityResult == 'none'
            ? const NetworkScreen()
            : isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppSizes.defaultSpace,
                        ).copyWith(
                          top: 0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
// header section
                            Row(
                              children: [
                                Expanded(
// header title
                                  child: Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.sm,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
// current status of the issue
                                PriorityLabel(
                                  title: status,
                                  bgColor: HelperFunction().statusColor(
                                    status,
                                    'bg',
                                  ),
                                  textColor: HelperFunction().statusColor(
                                    status,
                                    'text',
                                  ),
                                ),
                                const SizedBox(
                                  width: AppSizes.md,
                                ),
// issue posted date
                                Text(
                                  'Opened on $postedDate',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spaceBtwSections,
                            ),

// assign section
//  user can assign their issue to another user
                            Text(
                              'Assign to:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              height: AppSizes.spaceBtwItems,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: StreamBuilder(
// get all users without current user
                                    stream: _fireStore
                                        .collection('users')
                                        .where(
                                          'userId',
                                          isNotEqualTo: _userModel.userId,
                                        )
                                        .snapshots(),
                                    builder: (context, snapshot) {
// collecting filtered users
                                      List<DropdownMenuItem> usersList = [];

                                      if (snapshot.connectionState ==
                                              ConnectionState.none ||
                                          snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.active) {
// get all filtered users from firebase
                                        final users =
                                            snapshot.data!.docs.toList();

// first add current user data as a first value to list
// assign current user and other users value is their user id
                                        usersList.add(
                                          DropdownMenuItem(
                                            value: _userModel.userId,
                                            child: Row(
                                              children: [
//  user profile picture
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                    _userModel.userProfile,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: AppSizes.defaultSpace,
                                                ),
// user name
                                                Text(
                                                  _userModel.fullName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .apply(
                                                        fontSizeDelta: 3,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );

// then add all filtered users data to List
                                        for (var user in users) {
                                          usersList.add(
                                            DropdownMenuItem(
                                              value: user['userId'],
                                              child: Row(
                                                children: [
//  user profile picture
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      user['userProfile'],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width:
                                                        AppSizes.defaultSpace,
                                                  ),
//  user name
                                                  Text(
                                                    user['fullName'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .apply(
                                                          fontSizeDelta: 3,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      }
// return drop down button with user list
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: AppSizes.sm,
                                        ),
                                        child: IgnorePointer(
                                          ignoring: !isEdit,
                                          child: DropdownButton(
                                            value: ownerId,
                                            isExpanded: false,
                                            items: usersList,
                                            underline: const SizedBox(),
// if user change assign user, this will change the drop down current value
                                            onChanged: (value) {
                                              setState(() {
                                                ownerId = value;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spaceBtwSections,
                            ),
//  form section
                            Form(
                              child: Column(
                                children: [
// title text field
                                  TextField(
                                    controller: _titleController,
                                    enabled: isEdit,
                                    decoration: const InputDecoration(
                                      hintText: 'Title',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppSizes.spaceBtwInputFields,
                                  ),
// description text field
                                  TextField(
                                    controller: _descriptionController,
                                    enabled: isEdit,
                                    maxLines: 5,
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
                            Text(
                              'Priority level:',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: AppSizes.sm,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isEdit) {
                                      setState(() {
                                        priority = 'Low';
                                      });
                                    }
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
                                    if (isEdit) {
                                      setState(() {
                                        priority = 'Medium';
                                      });
                                    }
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
                                    if (isEdit) {
                                      setState(() {
                                        priority = 'High';
                                      });
                                    }
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
                            const SizedBox(
                              height: AppSizes.md,
                            ),

// status section
                            Text(
                              'Current status:',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: AppSizes.sm,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isEdit) {
                                      setState(() {
                                        status = 'Open';
                                      });
                                    }
                                  },
                                  child: PriorityLabel(
                                    title: 'Open',
                                    bgColor: status == 'Open'
                                        ? HelperFunction().statusColor(
                                            'Open',
                                            'bg',
                                          )
                                        : AppColors.selectBg,
                                    textColor: status == 'Open'
                                        ? HelperFunction().statusColor(
                                            'Open',
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
                                    if (isEdit) {
                                      setState(() {
                                        status = 'In Progress';
                                      });
                                    }
                                  },
                                  child: PriorityLabel(
                                    title: 'In Progress',
                                    bgColor: status == 'In Progress'
                                        ? HelperFunction().statusColor(
                                            'In Progress',
                                            'bg',
                                          )
                                        : AppColors.selectBg,
                                    textColor: status == 'In Progress'
                                        ? HelperFunction().statusColor(
                                            'In Progress',
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
                                    if (isEdit) {
                                      setState(() {
                                        status = 'Closed';
                                      });
                                    }
                                  },
                                  child: PriorityLabel(
                                    title: 'Closed',
                                    bgColor: status == 'Closed'
                                        ? HelperFunction().statusColor(
                                            'Closed',
                                            'bg',
                                          )
                                        : AppColors.selectBg,
                                    textColor: status == 'Closed'
                                        ? HelperFunction().statusColor(
                                            'Closed',
                                            'text',
                                          )
                                        : AppColors.selectText,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spaceBtwSections,
                            ),
// delete button
                            OutlinedButton(
                              onPressed: clickedDeleteButton,
                              child: const Text('Delete Issue'),
                            ),
                            const SizedBox(
                              height: AppSizes.spaceBtwInputFields,
                            ),
// edit button
                            ElevatedButton(
                              onPressed: clickedEditButton,
                              child: isSubmitLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.textWhite,
                                      ),
                                    )
                                  : isEdit
                                      ? const Text('Submit')
                                      : const Text('Edit Issue'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
      }),
    );
  }
}
