import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'Main_screen.dart';
import 'Counter_Screen.dart';
void main() => runApp(Generator());

class Generator extends StatefulWidget {
  @override
  _Generator createState() => _Generator();
}

class _Generator extends State<Generator> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: Login_Screen.id,
      routes: {
        Login_Screen.id: (context) => Login_Screen(),
        Main_Screen.id: (context) => Main_Screen(),
        Counter_Screen.id:(context) => Counter_Screen(),
      },
    );
  }
}