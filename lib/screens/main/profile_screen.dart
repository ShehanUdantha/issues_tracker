// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/providers/user_provider.dart';
import 'package:issues_tracker/services/auth_methods.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void signOutUser(String routeName) async {
    String response = await AuthMethods().signOutMethod();
    if (response == 'Success') {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    } else {
      HelperFunction().showSnackBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              AppSizes.defaultSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: AppColors.grey,
                        backgroundImage: NetworkImage(
                          _userModel.userProfile,
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.defaultSpace,
                ),
                Text(
                  _userModel.fullName,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: AppSizes.defaultSpace,
                ),
                OutlinedButton(
                  onPressed: () => signOutUser('/forget'),
                  child: const Text('Forgot Password'),
                ),
                const SizedBox(
                  height: AppSizes.defaultSpace,
                ),
                ElevatedButton(
                  onPressed: () => signOutUser('/login'),
                  child: const Text('Sign out'),
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
