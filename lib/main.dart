import 'package:championship_tracker/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'api/db.dart';
import 'api/fanta.dart';
import 'api/nba.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Championship Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
