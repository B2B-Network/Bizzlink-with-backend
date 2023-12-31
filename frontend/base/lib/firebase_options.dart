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
    apiKey: 'AIzaSyBRrx752oPX1cu5aEubdynAgtcsrrkI-aI',
    appId: '1:792934304966:web:1bb0e90f7eedd2cdb39bc7',
    messagingSenderId: '792934304966',
    projectId: 'b2bnetwork-4fa62',
    authDomain: 'b2bnetwork-4fa62.firebaseapp.com',
    storageBucket: 'b2bnetwork-4fa62.appspot.com',
    measurementId: 'G-80CL9PQXH6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1pky1wLcjGWXfFM4z119Au_D0Ycqi4xE',
    appId: '1:792934304966:android:c617013e10904616b39bc7',
    messagingSenderId: '792934304966',
    projectId: 'b2bnetwork-4fa62',
    storageBucket: 'b2bnetwork-4fa62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9cuLB3zeivSNM2KJu2hIBZlXLScsSppA',
    appId: '1:792934304966:ios:f4f36bb858a44c4fb39bc7',
    messagingSenderId: '792934304966',
    projectId: 'b2bnetwork-4fa62',
    storageBucket: 'b2bnetwork-4fa62.appspot.com',
    iosBundleId: 'com.example.base',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC9cuLB3zeivSNM2KJu2hIBZlXLScsSppA',
    appId: '1:792934304966:ios:62ca9f8fd2daac82b39bc7',
    messagingSenderId: '792934304966',
    projectId: 'b2bnetwork-4fa62',
    storageBucket: 'b2bnetwork-4fa62.appspot.com',
    iosBundleId: 'com.example.base.RunnerTests',
  );
}
