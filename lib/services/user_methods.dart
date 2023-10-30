// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/services/storage_methods.dart';

class UserMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // get userData from firebase
  Future<UserModel> getUserDetails({String? userId}) async {
    DocumentSnapshot documentSnapshot = await _fireStore
        .collection('users')
        .doc(userId ?? _auth.currentUser!.uid)
        .get();

    return UserModel.getValueFromSnapshot(documentSnapshot);
  }

  // update user profile picture
  Future<String> updateProfileImage({required Uint8List image}) async {
    String response = 'Some error occurred';

    String url = await StorageMethods().uploadImage(
      pathName: 'profilePicture',
      image: image,
    );

    try {
      await _fireStore.collection('users').doc(_auth.currentUser!.uid).update({
        'userProfile': url,
      });

      response = 'Success';
    } catch (e) {
      print(e.toString());
    }

    return response;
  }
}
