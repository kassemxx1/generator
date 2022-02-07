import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:generator/Bills_Screen.dart';
import 'package:generator/Payment_Screen.dart';
import 'LoginScreen.dart';
import 'Main_screen.dart';
import 'Counter_Screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Payment_Screen.dart';

void main() {
  runApp(Generator());
}

class Generator extends StatefulWidget {
  @override
  _Generator createState() => _Generator();
}

class _Generator extends State<Generator> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      initialRoute: Splash.id,
      routes: {
        Login_Screen.id: (context) => Login_Screen(),
        Main_Screen.id: (context) => Main_Screen(),
        Counter_Screen.id: (context) => Counter_Screen(),
        Splash.id: (context) => Splash(),
        Bill_Screen.id:(context) =>Bill_Screen(),
        Payment_Screen.id:(context) =>Payment_Screen(),
        //   Printing.id:(context) => Printing(),
      },
    );
  }
}

class Splash extends StatefulWidget {
  static const String id = 'main';
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var Name = '';
  var Pass = '';
  void initialization() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getString('user') == null) {
      Navigator.pushNamed(context, Login_Screen.id);
    } else {
      setState(() {
        Name = _prefs.getString('user').toString();
        Pass = _prefs.getString('pass').toString();
      });
      print(Name);
      login(Name, Pass);
    }
  }

  void login(String user, String pass) async {
    var url = Uri.parse(Main_Screen.url.toString() + 'login');
    Map<String, dynamic> bbb = {
      'user': user,
      'password': pass,
    };
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['Status'] == 1) {
        print('kassem');
        // Navigator.pushNamed(context, Main_Screen.id);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Main_Screen()));
      }
      if (data['Status'] == 0) {
        // Navigator.pushNamed(context, Login_Screen.id);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Login_Screen()));
        print('ksm0');
      }
      if (data['Status'] == 2) {
        // Navigator.pushNamed(context, Login_Screen.id);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Login_Screen()));
        print('ksm2');
      }
    } catch (err) {
      //Navigator.pushNamed(context, Login_Screen.id);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Login_Screen()));
      print('ksm3');
    }
  }

  @override
  void initState() {
    initialization();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'images/bulb.gif',
            fit: BoxFit.cover,
          )),
    );
  }
}
