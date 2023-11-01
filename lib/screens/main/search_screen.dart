// ignore_for_file: unnecessary_null_comparison, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:issues_tracker/common/styles/searchbar.dart';
import 'package:issues_tracker/common/widgets/issue_card.dart';
import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/providers/filter_provider.dart';
import 'package:issues_tracker/providers/user_provider.dart';
import 'package:issues_tracker/screens/main/issue_screen.dart';
import 'package:issues_tracker/utils/constants/constants.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  bool showSearchIssues = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<bool> detectBackButton() async {
    bool shouldCloseApp = false;
    if (showSearchIssues) {
      setState(() {
        showSearchIssues = false;
        _searchController.clear();
      });
      shouldCloseApp = false;
    } else {
      shouldCloseApp = true;
    }
    return shouldCloseApp;
  }

  void sortDocumentsByDate(List documents, String name) {
    return documents.sort((a, b) {
      Timestamp dateA = a[name] as Timestamp;
      Timestamp dateB = b[name] as Timestamp;

      return dateB.compareTo(dateA);
    });
  }

  @override
  Widget build(BuildContext context) {
    var query = _fireStore.collection('issues');
    UserModel _userModel = Provider.of<UserProvider>(context).getUser;

    return Consumer<FilterProvider>(
      builder: (context, filterProvider, child) {
        return WillPopScope(
// check if user want to go back after using search
          onWillPop: detectBackButton,
          child: Scaffold(
            appBar: AppBar(
// search bar
              title: TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  if (_searchController.text.isNotEmpty) {
                    setState(() {
                      showSearchIssues = true;
                    });
                  } else {
                    setState(() {
                      showSearchIssues = false;
                    });
                  }
                },
                decoration: SearchBarStyle().searchBarDecoration,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppSizes.defaultSpace,
                ).copyWith(
                  bottom: 0.0,
                ),

// first check if user search something, then it will display search issues and other wise is display filtering section
                child: showSearchIssues
                    ?
// retrieve all search issues from firebase
                    Column(
                        children: [
                          Expanded(
                            child: FutureBuilder(
                              future: query
                                  .where('title',
                                      isGreaterThanOrEqualTo:
                                          _searchController.text)
                                  .get(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.none ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                // take a documents snapshot
                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;
                                // filter documents by ownerId
                                var currentUserBasedIssue =
                                    documents.where((element) {
                                  return element['ownerId'] ==
                                      _userModel.userId;
                                }).toList();

                                return ListView.builder(
                                  itemCount: currentUserBasedIssue.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
// if user clicked on a issue card it will navigate to issue screen
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => IssueScreen(
                                              issueId:
                                                  currentUserBasedIssue[index]
                                                      ['issueId'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: IssueCard(
                                        snap:
                                            currentUserBasedIssue[index].data(),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
// filter section
                            Text(
                              'Filters',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(
                              height: AppSizes.defaultSpace,
                            ),

                            // status filter section
                            const Text(
                              'Filter by status',
                            ),
                            Row(
                              children: Constants.statusList
                                  .map((status) => Row(
                                        children: [
                                          FilterChip(
                                            selected:
                                                filterProvider.selectedStatus ==
                                                    status,
                                            onSelected: (value) {
                                              if (value) {
                                                filterProvider
                                                    .updateStatus(status);
                                              } else {
                                                filterProvider.updateStatus('');
                                              }
                                            },
                                            label: Text(
                                              status,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: AppSizes.spaceBtwItems / 2,
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: AppSizes.sm,
                            ),

                            // priority filter section
                            const Text(
                              'Filter by priority',
                            ),
                            Row(
                              children: Constants.priorityList
                                  .map(
                                    (priority) => Row(
                                      children: [
                                        FilterChip(
                                          selected:
                                              filterProvider.selectedPriority ==
                                                  priority,
                                          onSelected: (value) {
                                            if (value) {
                                              filterProvider
                                                  .updatePriority(priority);
                                            } else {
                                              filterProvider.updatePriority('');
                                            }
                                          },
                                          label: Text(
                                            priority,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppSizes.spaceBtwItems / 2,
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(
                              height: AppSizes.spaceBtwSections,
                            ),

                            // display all issues section
                            Text(
                              'List of Issues',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(
                              height: AppSizes.defaultSpace,
                            ),

// retrieve all issues from firebase
                            Row(
                              children: [
                                Expanded(
                                  child: StreamBuilder(
                                    stream: filterProvider.selectedStatus !=
                                                '' &&
                                            filterProvider.selectedPriority !=
                                                ''
                                        ? query
                                            .where(
                                              'ownerId',
                                              isEqualTo: _userModel.userId,
                                            )
                                            .where(
                                              'status',
                                              isEqualTo:
                                                  filterProvider.selectedStatus,
                                            )
                                            .where(
                                              'priority',
                                              isEqualTo: filterProvider
                                                  .selectedPriority,
                                            )
                                            .snapshots()
                                        : filterProvider.selectedStatus != '' &&
                                                filterProvider
                                                        .selectedPriority ==
                                                    ''
                                            ? query
                                                .where(
                                                  'ownerId',
                                                  isEqualTo: _userModel.userId,
                                                )
                                                .where(
                                                  'status',
                                                  isEqualTo: filterProvider
                                                      .selectedStatus,
                                                )
                                                .snapshots()
                                            : filterProvider.selectedStatus ==
                                                        '' &&
                                                    filterProvider
                                                            .selectedPriority !=
                                                        ''
                                                ? query
                                                    .where(
                                                      'ownerId',
                                                      isEqualTo:
                                                          _userModel.userId,
                                                    )
                                                    .where(
                                                      'priority',
                                                      isEqualTo: filterProvider
                                                          .selectedPriority,
                                                    )
                                                    .snapshots()
                                                : query
                                                    .where(
                                                      'ownerId',
                                                      isEqualTo:
                                                          _userModel.userId,
                                                    )
                                                    .snapshots(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.none ||
                                          snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

// take a documents snapshot
                                      List<DocumentSnapshot> documents =
                                          snapshot.data!.docs;
// Sort the documents based on the date
// recent added issue document to last document
                                      sortDocumentsByDate(
                                          documents, 'postedDate');

                                      return ListView.builder(
                                        itemCount: documents.length,
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
// if user clicked on a issue card it will navigate to issue screen
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      IssueScreen(
                                                    issueId: documents[index]
                                                        ['issueId'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: IssueCard(
                                              snap: documents[index].data(),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
