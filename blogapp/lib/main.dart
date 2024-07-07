import 'package:blogapp/screens/homepage.dart';
import 'package:blogapp/screens/login_page.dart';
import 'package:blogapp/screens/register_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => Homepage(), // Assuming HomePage is your main app screen
      },
    );
  }
}
