import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/users_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn = false;

  void onLoginSuccess() {
    setState(() => _loggedIn = true);
  }

  void onLogout() {
    setState(() => _loggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: _loggedIn
          ? UsersPage(onLogout: onLogout)
          : LoginPage(onSuccess: onLoginSuccess),
    );
  }
}
