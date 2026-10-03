import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Substituído pelo `flutterfire configure`. Enquanto a chave contiver
/// SUBSTITUA, o app não tenta autenticar.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return windows;
    }
    throw UnsupportedError('Esta versão é só para Windows.');
  }

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBaU97FG8y6PLcbevnP77EYUJAhDhFr1IM',
    appId: '1:835039745152:web:f67ebdaef2611d2370c265',
    messagingSenderId: '835039745152',
    projectId: 'cea-reuniao-marco-zero',
    authDomain: 'cea-reuniao-marco-zero.firebaseapp.com',
    storageBucket: 'cea-reuniao-marco-zero.firebasestorage.app',
  );

}

bool get firebaseConfigurado {
  final chave = DefaultFirebaseOptions.windows.apiKey;
  return chave.isNotEmpty && !chave.contains('SUBSTITUA');
}