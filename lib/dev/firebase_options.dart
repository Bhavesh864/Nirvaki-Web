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
    apiKey: 'AIzaSyAw1c1ZWMUmGZHk7crsEOxm8ZDb9vAFwR0',
    appId: '1:868897852943:web:45a680dc31050803979d7a',
    messagingSenderId: '868897852943',
    projectId: 'brokr-in',
    authDomain: 'brokr-in.firebaseapp.com',
    databaseURL: 'https://brokr-in-default-rtdb.firebaseio.com',
    storageBucket: 'brokr-in.appspot.com',
    measurementId: 'G-4G43D3Z8FK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUeJdbgyHJrlipvGFe6Jz4HY3Ftrw2tmI',
    appId: '1:868897852943:android:da6e9a154a1d6117979d7a',
    messagingSenderId: '868897852943',
    projectId: 'brokr-in',
    databaseURL: 'https://brokr-in-default-rtdb.firebaseio.com',
    storageBucket: 'brokr-in.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-WI8Ng4Bubdv-nG0cZcSVgLJW-li8qlE',
    appId: '1:868897852943:ios:9d3a1c4e480129eb979d7a',
    messagingSenderId: '868897852943',
    projectId: 'brokr-in',
    databaseURL: 'https://brokr-in-default-rtdb.firebaseio.com',
    storageBucket: 'brokr-in.appspot.com',
    androidClientId: '868897852943-s3h62g9gvhcr0trk80ugbh3ud978l649.apps.googleusercontent.com',
    iosClientId: '868897852943-sa7p0lub6upq9b3rjkrthd5vhdu6gial.apps.googleusercontent.com',
    iosBundleId: 'com.example.yesBroker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-WI8Ng4Bubdv-nG0cZcSVgLJW-li8qlE',
    appId: '1:868897852943:ios:2a26edff0356baa2979d7a',
    messagingSenderId: '868897852943',
    projectId: 'brokr-in',
    databaseURL: 'https://brokr-in-default-rtdb.firebaseio.com',
    storageBucket: 'brokr-in.appspot.com',
    androidClientId: '868897852943-s3h62g9gvhcr0trk80ugbh3ud978l649.apps.googleusercontent.com',
    iosClientId: '868897852943-vitn6u89j8pt3kegcodic5aqglc13qeg.apps.googleusercontent.com',
    iosBundleId: 'com.example.yesBroker.RunnerTests',
  );
}
