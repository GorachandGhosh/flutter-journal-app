import 'package:flutter/material.dart';
import 'package:myjournalapp/screens/auth_wrapper.dart';

class MyJournalApp extends StatelessWidget {
  const MyJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Daily Thoughts",
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}
