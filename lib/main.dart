// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/views/homePage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyA2koLpZpNTdb6I76iyef8zpz4fRqYx7hQ",
          appId: "1:91850746038:web:1e8de57c05050caad75e17",
          messagingSenderId: "91850746038",
          projectId: "final-project-9a4f3"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
    home: homePage());
  }
}
