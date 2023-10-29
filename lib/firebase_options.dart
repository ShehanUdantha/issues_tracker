// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCm_GmeNky8IO-_TizjvkEAYn8K949l8Mw',
    appId: '1:860330746114:web:d60d59c9237a173c44e21b',
    messagingSenderId: '860330746114',
    projectId: 'issues-tracker-bc2a9',
    authDomain: 'issues-tracker-bc2a9.firebaseapp.com',
    storageBucket: 'issues-tracker-bc2a9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCY7zzEAWkw-DGtTOs236dahB45MuuLzBY',
    appId: '1:860330746114:android:e4aae1491f5c855c44e21b',
    messagingSenderId: '860330746114',
    projectId: 'issues-tracker-bc2a9',
    storageBucket: 'issues-tracker-bc2a9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1GcD4CF4eiTu7SJqRCmUdX0kqwXBEHk4',
    appId: '1:860330746114:ios:b5727746cc538ff144e21b',
    messagingSenderId: '860330746114',
    projectId: 'issues-tracker-bc2a9',
    storageBucket: 'issues-tracker-bc2a9.appspot.com',
    iosBundleId: 'com.example.issuesTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1GcD4CF4eiTu7SJqRCmUdX0kqwXBEHk4',
    appId: '1:860330746114:ios:cd750f054daab2f244e21b',
    messagingSenderId: '860330746114',
    projectId: 'issues-tracker-bc2a9',
    storageBucket: 'issues-tracker-bc2a9.appspot.com',
    iosBundleId: 'com.example.issuesTracker.RunnerTests',
  );
}
