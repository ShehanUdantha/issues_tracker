import 'package:flutter/material.dart';
import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/providers/user_provider.dart';
import 'package:issues_tracker/screens/main/home/add_issue.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              height: 50.0,
              image: AssetImage(
                'assets/logos/logo.png',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              AppSizes.defaultSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [],
            ),
          ),
        ),
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
