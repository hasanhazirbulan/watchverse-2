// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyA-ZYYZJY_lhfuytCQUM5r58nmV8G-qZx0',
    appId: '1:286877660588:web:befd26e5b2e9225878b609',
    messagingSenderId: '286877660588',
    projectId: 'watchvers',
    authDomain: 'watchvers.firebaseapp.com',
    storageBucket: 'watchvers.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGFxFp4xsSn9UBzPTN-fbBXmHCGtbGh-I',
    appId: '1:286877660588:android:9a13ea0fcd3b255c78b609',
    messagingSenderId: '286877660588',
    projectId: 'watchvers',
    storageBucket: 'watchvers.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPtCct7anOI5qxB7noCtmS-bWpFBBJQPU',
    appId: '1:286877660588:ios:f6a0592a84466cb478b609',
    messagingSenderId: '286877660588',
    projectId: 'watchvers',
    storageBucket: 'watchvers.firebasestorage.app',
    iosBundleId: 'com.example.watchVerse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPtCct7anOI5qxB7noCtmS-bWpFBBJQPU',
    appId: '1:286877660588:ios:f6a0592a84466cb478b609',
    messagingSenderId: '286877660588',
    projectId: 'watchvers',
    storageBucket: 'watchvers.firebasestorage.app',
    iosBundleId: 'com.example.watchVerse',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-ZYYZJY_lhfuytCQUM5r58nmV8G-qZx0',
    appId: '1:286877660588:web:b7c875dda713282278b609',
    messagingSenderId: '286877660588',
    projectId: 'watchvers',
    authDomain: 'watchvers.firebaseapp.com',
    storageBucket: 'watchvers.firebasestorage.app',
  );
}
