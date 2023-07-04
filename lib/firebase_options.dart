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
    apiKey: 'AIzaSyCZie813lttT-JH2gnHDsYMDtxU8dKB5AE',
    appId: '1:773312093068:web:a0a3c9fe5ec612cd3894a9',
    messagingSenderId: '773312093068',
    projectId: 'mynotebook-fbd3d',
    authDomain: 'mynotebook-fbd3d.firebaseapp.com',
    storageBucket: 'mynotebook-fbd3d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgzm7npRFbXfQyW7zY2oSACFviLbe8Mls',
    appId: '1:773312093068:android:b333de3d0ca9f6333894a9',
    messagingSenderId: '773312093068',
    projectId: 'mynotebook-fbd3d',
    storageBucket: 'mynotebook-fbd3d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDCKI2aYDyeA_keHWlR7VtQ3zccxJQONg',
    appId: '1:773312093068:ios:13e0d0a1f77567e13894a9',
    messagingSenderId: '773312093068',
    projectId: 'mynotebook-fbd3d',
    storageBucket: 'mynotebook-fbd3d.appspot.com',
    iosClientId: '773312093068-m3loer1k1aab0lr0icqslc077elm4ge4.apps.googleusercontent.com',
    iosBundleId: 'com.example.mynotebook',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDCKI2aYDyeA_keHWlR7VtQ3zccxJQONg',
    appId: '1:773312093068:ios:509366d96a9cfee23894a9',
    messagingSenderId: '773312093068',
    projectId: 'mynotebook-fbd3d',
    storageBucket: 'mynotebook-fbd3d.appspot.com',
    iosClientId: '773312093068-t8s1l6vehpteahqi45q6kmfp5th2rv1g.apps.googleusercontent.com',
    iosBundleId: 'com.example.mynotebook.RunnerTests',
  );
}
