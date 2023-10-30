// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:issues_tracker/models/issue_model.dart';
import 'package:uuid/uuid.dart';

class IssueMethods {
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

// get issue data from firebase
  Future<IssueModel> getIssueData({required String issueId}) async {
    // get issue data from issue id
    DocumentSnapshot _snap =
        await _fireStore.collection('issues').doc(issueId).get();
    // send it to a issue model and issue object and return
    IssueModel _issueModel = IssueModel.getValueFromSnapshot(_snap);

    return _issueModel;
  }

// update issue data
  Future<String> updateIssueData({
    required String issueId,
    required String ownerId,
    required String profileImage,
    required String title,
    required String description,
    required String priority,
    required String status,
  }) async {
    String response = 'Some error occurred';
    try {
      // update issue in firebase
      await _fireStore.collection('issues').doc(issueId).update({
        'ownerId': ownerId,
        'profileImage': profileImage,
        'title': title,
        'description': description,
        'priority': priority,
        'status': status,
      });

      response = 'Success';
    } catch (err) {
      response = err.toString();
    }
    return response;
  }

// delete issue data
  Future<String> deleteIssueData({required String issueId}) async {
    String response = 'Some error occurred';
    try {
      // delete issue in firebase
      await _fireStore.collection('issues').doc(issueId).delete();

      response = 'Success';
    } catch (err) {
      response = err.toString();
    }
    return response;
  }
}
