import 'package:flutter/material.dart';
import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/services/user_methods.dart';
import 'package:issues_tracker/utils/constants/constants.dart';

class UserProvider with ChangeNotifier {
  UserModel _currentUserModel = UserModel(
    userId: 'null',
    fullName: 'null',
    emailAddress: 'null',
    mobileNumber: 'null',
    password: 'null',
    userProfile: Constants.defaultProfilePicture,
  );

  UserModel get getUser => _currentUserModel;

  String get getUserId => _currentUserModel.userId;

  String get getUserProfilePicture => _currentUserModel.userProfile;

  Future<void> refreshUserDetails() async {
    UserModel userModel = await UserMethods().getUserDetails();
    _currentUserModel = userModel;
    notifyListeners();
  }
}
