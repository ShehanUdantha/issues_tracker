import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String fullName;
  final String emailAddress;
  final String mobileNumber;
  final String password;
  final String userProfile;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.emailAddress,
    required this.mobileNumber,
    required this.password,
    required this.userProfile,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'fullName': fullName,
        'emailAddress': emailAddress,
        'mobileNumber': mobileNumber,
        'password': password,
        'userProfile': userProfile,
      };

  static UserModel getValueFromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;

    return UserModel(
      userId: snapshot['userId'],
      fullName: snapshot['fullName'],
      emailAddress: snapshot['emailAddress'],
      mobileNumber: snapshot['mobileNumber'],
      password: snapshot['password'],
      userProfile: snapshot['userProfile'],
    );
  }
}
