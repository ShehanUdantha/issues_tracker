import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:issues_tracker/models/user_model.dart';
import 'package:issues_tracker/utils/constants/constants.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

// create user account and store user details
  Future<String> signUpMethod({
    required String fullName,
    required String emailAddress,
    required String mobileNumber,
    required String password,
  }) async {
    String response = 'Some error occurred';

    try {
      // register user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: emailAddress, password: password);
      // create user model to store fireStore
      UserModel userModel = UserModel(
        userId: userCredential.user!.uid,
        fullName: fullName,
        emailAddress: emailAddress,
        mobileNumber: mobileNumber,
        password: password,
        userProfile: Constants.defaultProfilePicture,
      );
      // store user details in fireStore
      await _fireStore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());

      response = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        response = 'your password is too weak';
      } else if (e.code == 'email-already-in-use') {
        response = 'This email already registered';
      } else if (e.code == 'invalid-email') {
        response = 'Your email is not a valid email';
      } else {
        response = e.toString();
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

// send user verification email
  Future<String> sendVerificationEmail() async {
    String response = 'Some error occurred';
    try {
      await _auth.currentUser?.sendEmailVerification();
      response = 'Success';
    } on FirebaseAuthException catch (e) {
      response = e.toString();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

// login to account
  Future<String> signInMethod({
    required String emailAddress,
    required String password,
  }) async {
    String response = 'Some error occurred';
    try {
      // sign in user
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      response = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        response = 'Your email is not a valid email';
        return response;
      }
      if (e.code == 'user-not-found') {
        response = 'This email not registered yet';
        return response;
      }
      if (e.code == 'wrong-password') {
        response = 'Your password is incorrect';
        return response;
      }
    } catch (e) {
      response = e.toString();
    }

    return response;
  }

// send user forgot password email
  Future<String> sendForgetPasswordEmail({required String emailAddress}) async {
    String response = 'Some error occurred';
    try {
      await _auth.sendPasswordResetEmail(
        email: emailAddress,
      );
      response = 'Success';
    } on FirebaseAuthException catch (e) {
      response = e.toString();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

// sign out from account
  Future<String> signOutMethod() async {
    String response = 'Some error occurred';
    try {
      // sign out user
      await _auth.signOut();

      response = 'Success';
    } catch (err) {
      response = err.toString();
    }
    return response;
  }
}
