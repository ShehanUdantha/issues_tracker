// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/providers/user_provider.dart';
import 'package:issues_tracker/services/auth_methods.dart';
import 'package:issues_tracker/services/issue_methods.dart';
import 'package:issues_tracker/services/user_methods.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? selectedProfilePic;

  void signOutUser(String routeName) async {
    String response = await AuthMethods().signOutMethod();
    if (response == 'Success') {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    } else {
      HelperFunction().showSnackBar(context, response);
    }
  }

  void selectProfileImage() async {
    Uint8List pickedImage = await HelperFunction().pickImage(
      ImageSource.gallery,
      context,
    );

    setState(() {
      selectedProfilePic = pickedImage;
    });

    String response = await UserMethods().updateProfileImage(
      image: pickedImage,
    );

    if (response == 'Success') {
      // if successfully profile picture added, then update user provider
      Provider.of<UserProvider>(context, listen: false).refreshUserDetails();
      // update profile picture of the issue card
      String response = await IssueMethods().updateProfileImage(
        url: Provider.of<UserProvider>(context, listen: false)
            .getUserProfilePicture,
      );

      if (response != 'Success') {
        HelperFunction().showSnackBar(
          context,
          response,
        );
      }
    } else {
      HelperFunction().showSnackBar(
        context,
        response,
      );
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
// user profile picture section
                    Stack(children: [
                      selectedProfilePic != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundColor: AppColors.grey,
                              backgroundImage: MemoryImage(
                                selectedProfilePic!,
                              ),
                            )
                          : CircleAvatar(
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
                          onPressed: selectProfileImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),

// user information section
                Text(
                  'Profile Information',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: AppSizes.defaultSpace,
                ),
//  user name
                UserInfoField(
                  name: 'Name',
                  info: _userModel.fullName,
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwInputFields,
                ),
// user email
                UserInfoField(
                  name: 'E-mail',
                  info: _userModel.emailAddress,
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwInputFields,
                ),
// user mobile number
                UserInfoField(
                  name: 'Phone Number',
                  info: _userModel.mobileNumber,
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwItems,
                ),
                const Divider(),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
//  forget password button
                OutlinedButton(
                  onPressed: () => signOutUser('/forget'),
                  child: const Text('Forgot Password'),
                ),
                const SizedBox(
                  height: AppSizes.defaultSpace,
                ),

//  sign out button
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

class UserInfoField extends StatelessWidget {
  final String name;
  final String info;
  const UserInfoField({
    super.key,
    required this.name,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          info,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
