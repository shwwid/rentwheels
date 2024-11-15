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
    apiKey: 'AIzaSyAKGPvUyyX4rEGO47litUNPggBa9x9dFcQ',
    appId: '1:62538751675:web:ebf5941e0049685f17139e',
    messagingSenderId: '62538751675',
    projectId: 'rentwheels-32bd9',
    authDomain: 'rentwheels-32bd9.firebaseapp.com',
    storageBucket: 'rentwheels-32bd9.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFaMzkboSAZCiBPhDXHZuoCENFZId69zg',
    appId: '1:62538751675:android:c1249ad42e97f3b617139e',
    messagingSenderId: '62538751675',
    projectId: 'rentwheels-32bd9',
    storageBucket: 'rentwheels-32bd9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBI75OdB_IBlYstdLT-uLL1zggHTLp-Nj8',
    appId: '1:62538751675:ios:6126b0d7af21b20e17139e',
    messagingSenderId: '62538751675',
    projectId: 'rentwheels-32bd9',
    storageBucket: 'rentwheels-32bd9.firebasestorage.app',
    iosBundleId: 'com.example.rentwheels.rentwheels',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBI75OdB_IBlYstdLT-uLL1zggHTLp-Nj8',
    appId: '1:62538751675:ios:6126b0d7af21b20e17139e',
    messagingSenderId: '62538751675',
    projectId: 'rentwheels-32bd9',
    storageBucket: 'rentwheels-32bd9.firebasestorage.app',
    iosBundleId: 'com.example.rentwheels.rentwheels',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAKGPvUyyX4rEGO47litUNPggBa9x9dFcQ',
    appId: '1:62538751675:web:f9e8c409283215d517139e',
    messagingSenderId: '62538751675',
    projectId: 'rentwheels-32bd9',
    authDomain: 'rentwheels-32bd9.firebaseapp.com',
    storageBucket: 'rentwheels-32bd9.firebasestorage.app',
  );
}