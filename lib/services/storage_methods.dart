import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

// add selected image to firebase storage and get the downloadable url
  Future<String> uploadImage({
    required String pathName,
    required Uint8List image,
  }) async {
    // create a path on storage to store a image
    Reference reference = _storage.ref().child(pathName).child(
          _auth.currentUser!.uid,
        );
    // image uploaded and store
    UploadTask task = reference.putData(image);
    TaskSnapshot snapshot = await task;
    // get downloadable url from stored image
    String downloadableUrl = await snapshot.ref.getDownloadURL();

    return downloadableUrl;
  }
}
