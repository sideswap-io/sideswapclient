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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsAFprhD1wTTkeZGMVIGGscTWyp5rFT8Y',
    appId: '1:283004570085:android:bc9a81cefa880fd9d5c70c',
    messagingSenderId: '283004570085',
    projectId: 'sideswap-1268b',
    storageBucket: 'sideswap-1268b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCT9AU3U0KQ1K-nutYEagVNoN76CIIXmak',
    appId: '1:283004570085:ios:384ebc06b469eee7d5c70c',
    messagingSenderId: '283004570085',
    projectId: 'sideswap-1268b',
    storageBucket: 'sideswap-1268b.appspot.com',
    iosClientId: '283004570085-37d87n3icqmoosgnkurgu2o0lnti494n.apps.googleusercontent.com',
    iosBundleId: 'io.sideswap.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCT9AU3U0KQ1K-nutYEagVNoN76CIIXmak',
    appId: '1:283004570085:ios:384ebc06b469eee7d5c70c',
    messagingSenderId: '283004570085',
    projectId: 'sideswap-1268b',
    storageBucket: 'sideswap-1268b.appspot.com',
    iosClientId: '283004570085-37d87n3icqmoosgnkurgu2o0lnti494n.apps.googleusercontent.com',
    iosBundleId: 'io.sideswap.app',
  );
}
