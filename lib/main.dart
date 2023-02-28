import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_chat_app/firestore/room_firestore.dart';
import 'package:test_chat_app/pages/top_page.dart';
import 'package:test_chat_app/utils/shared_pref.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'firebase_options.dart';
import 'firestore/user_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '',
  );
  await SharedPref.setPrefsInstance();
  String? uid = SharedPref.fetchUid();
  if (uid == null) await UserFirestore.createUser();
  print(uid);
  getFID();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopPage(),
    );
  }
}

void getFID() async {
  String id = await FirebaseInstallations.instance.getId();
  print('id : $id');
}
