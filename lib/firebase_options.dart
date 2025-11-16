import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCaC-x2fto0kdGEFVmQ2pIU9pSZ91ncLSU',
    appId: '1:205059647335:web:1370bc1336fa90eccef1c2',
    messagingSenderId: '205059647335',
    projectId: 'nurses-notes-app-ph',
    authDomain: 'nurses-notes-app-ph.firebaseapp.com',
    storageBucket: "nurses-notes-app-ph.appspot.com",
    measurementId: 'G-B8KMGXNJ2L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFyjSwiqdSz89IUalsEdG8a07cEnU6eHE',
    appId: '1:205059647335:android:5e7da715d52c88ddcef1c2',
    messagingSenderId: '205059647335',
    projectId: 'nurses-notes-app-ph',
    storageBucket: "nurses-notes-app-ph.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD896gFqyVhJUDgKFa0TRptpC1dtek_s4o',
    appId: '1:205059647335:ios:89a68c79b1a58ac8cef1c2',
    messagingSenderId: '205059647335',
    projectId: 'nurses-notes-app-ph',
    storageBucket: "nurses-notes-app-ph.appspot.com",
    iosBundleId: 'com.example.nursesNotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD896gFqyVhJUDgKFa0TRptpC1dtek_s4o',
    appId: '1:205059647335:ios:89a68c79b1a58ac8cef1c2',
    messagingSenderId: '205059647335',
    projectId: 'nurses-notes-app-ph',
    storageBucket: "nurses-notes-app-ph.appspot.com",
    iosBundleId: 'com.example.nursesNotes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCaC-x2fto0kdGEFVmQ2pIU9pSZ91ncLSU',
    appId: '1:205059647335:web:070bef8cdb31c203cef1c2',
    messagingSenderId: '205059647335',
    projectId: 'nurses-notes-app-ph',
    authDomain: 'nurses-notes-app-ph.firebaseapp.com',
    storageBucket: "nurses-notes-app-ph.appspot.com",
    measurementId: 'G-Q064X4XMYX',
  );
}
