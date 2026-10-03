import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'data/local/banco.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAuth? auth;
  FirebaseFirestore? firestore;
  if (firebaseConfigurado) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
  }
  runApp(
    MarcoZeroApp(
      banco: AppDatabase.padrao(),
      firebasePronto: firebaseConfigurado,
      authFirebase: auth,
      firestore: firestore,
    ),
  );
}
