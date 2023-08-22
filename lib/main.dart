import 'package:flutter/material.dart';
import 'quiz.dart';
import 'database/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseHelper().initDatabase();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData.dark(),
      home: const MyAppWithMediaQuery(),
    );
  }
}

class MyAppWithMediaQuery extends StatelessWidget {
  const MyAppWithMediaQuery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(),
      child: const Scaffold(
        body: Quiz(),
      ),
    );
  }
}
