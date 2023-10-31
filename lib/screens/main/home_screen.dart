// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:issues_tracker/common/widgets/grid_card.dart';

import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/providers/status_provider.dart';
import 'package:issues_tracker/providers/user_provider.dart';
import 'package:issues_tracker/screens/main/home/add_issue.dart';
import 'package:issues_tracker/screens/main/home/chart/bar_chat.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // initialized the status values of a current user
    Provider.of<StatusProvider>(context, listen: false).initializedStatus();
  }

  void callBottomSheet(String uid, String profilePic) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return AddIssue(
            userId: uid,
            profileImage: profilePic,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserProvider>(context).getUser;

    return _userModel.userId == 'null'
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    height: 40.0,
                    image: AssetImage(
                      'assets/logos/logo_empty.png',
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      _userModel.userProfile,
                    ),
                  ),
                ],
              ),
            ),
            body: Consumer<StatusProvider>(
              builder: (
                context,
                statusProvider,
                child,
              ) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppSizes.defaultSpace,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // name section
                          Text(
                            'Welcome Home,',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.darkGrey,
                                    ),
                          ),
                          Text(
                            _userModel.fullName,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(
                            height: AppSizes.spaceBtwSections,
                          ),

                          // create 3 boxes to display the count of the each status
                          Row(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  itemCount: 3,
                                  shrinkWrap: true,
                                  // disable grid view scroll
                                  primary: false,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.7),
                                  ),
                                  itemBuilder: (context, index) {
                                    List summery = [
                                      [
                                        'Opened',
                                        statusProvider.openCount,
                                        'assets/images/open.png',
                                      ],
                                      [
                                        'In Progress',
                                        statusProvider.progressCount,
                                        'assets/images/progress.png'
                                      ],
                                      [
                                        'Closed',
                                        statusProvider.closedCount,
                                        'assets/images/correct.png'
                                      ],
                                    ];
                                    return GridCard(
                                      title: summery[index][0],
                                      value: summery[index][1],
                                      image: summery[index][2],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: AppSizes.spaceBtwSections,
                          ),
                          // create bar chart for status
                          Text(
                            'Activity Chart',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            height: AppSizes.spaceBtwSections,
                          ),
                          AspectRatio(
                            aspectRatio: 1.3,
                            child: SizedBox(
                              child: BarChartView(
                                openCount: statusProvider.openCount,
                                progressCount: statusProvider.progressCount,
                                closedCount: statusProvider.closedCount,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => callBottomSheet(
                _userModel.userId,
                _userModel.userProfile,
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              child: const Icon(
                Icons.add,
              ),
            ),
          );
  }
}
