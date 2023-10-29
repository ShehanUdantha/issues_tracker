// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:issues_tracker/models/issue_model.dart';
import 'package:uuid/uuid.dart';

class IssueMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

// create new issue
  Future<String> createNewIssue({
    required String ownerId,
    required String profileImage,
    required String title,
    required String description,
    required String priority,
  }) async {
    String response = 'Some error occurred';
    try {
      // generate issue id from uuid
      String issueId = const Uuid().v1();

      // create issue model
      IssueModel _issueModel = IssueModel(
        issueId: issueId,
        ownerId: ownerId,
        profileImage: profileImage,
        postedDate: DateTime.now(),
        title: title,
        description: description,
        priority: priority,
        status: 'Open',
      );

      // add issue to firebase
      await _fireStore
          .collection('issues')
          .doc(issueId)
          .set(_issueModel.toJson());

      response = 'Success';
    } catch (err) {
      response = err.toString();
    }
    return response;
  }
}
