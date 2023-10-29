import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:issues_tracker/models/user_model.dart';

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
}
