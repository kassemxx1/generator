import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generator/Main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';



class Login_Screen extends StatefulWidget {
  static const String id = 'Login_Screen';
  const Login_Screen({Key? key}) : super(key: key);
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}
class _Login_ScreenState extends State<Login_Screen> {
  TextEditingController UserController = TextEditingController();
  TextEditingController PassController = TextEditingController();


  var Name = '';
  var Pass ='';

  void login(String user,String pass) async {
    EasyLoading.show();
    var url = Uri.parse(Main_Screen.url.toString() + '/login');
    Map<String, dynamic> bbb = {
      'user': Name ,
      'password':Pass,
    };
    try{
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['Status'] == 1) {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength:
            Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('user',Name);
        _prefs.setString('pass',Pass);
        EasyLoading.dismiss();
        Navigator.pushNamed(context, Main_Screen.id);
      }
      if (data['Status'] == 0) {
        Fluttertoast.showToast(
            msg: "wrong user name or password",
            toastLength:
            Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        EasyLoading.dismiss();
      }
      if (data['Status'] == 2) {
        Fluttertoast.showToast(
            msg: "login Faild",
            toastLength:
            Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        EasyLoading.dismiss();
      }


    }
    catch(err){
      Fluttertoast.showToast(
          msg: "connection error",
          toastLength:
          Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      EasyLoading.dismiss();

    }

  }
  void checkIfLogged() async{

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(_prefs.getString('user')==null){
    }
    else{
      setState(() {
        Name = _prefs.getString('user').toString();
        Pass =_prefs.getString('pass').toString();
        UserController.text=Name;
        PassController.text=Pass;
      });

      login(Name, Pass);
    }
  }
  @override
  void initState() {
    checkIfLogged();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text('                          ISC-Power',style:TextStyle(
              fontSize: 30,
              decoration: TextDecoration.underline,
            ) ,),
            Text(
                '                                    APP',style: TextStyle(
              fontSize: 30,
            ),
            ),
            Center(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/g.jpg"),
                          fit: BoxFit.scaleDown)),
                )),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: TextField(
                  controller: UserController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'User Name',
                    border: OutlineInputBorder(),
                    suffixIcon: UserController.text.isEmpty
                        ? Container(
                      width: 0,
                    )
                        : IconButton(
                      onPressed: () {
                        UserController.clear();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      Name = value;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: TextField(
                  controller: PassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: PassController.text.isEmpty
                        ? Container(
                      width: 0,
                    )
                        : IconButton(
                      onPressed: () {
                        PassController.clear();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      Pass = value;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: Colors.blue,
                  child: Text('Login',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),),
                  onPressed:(){
                  login(Name, Pass);
              },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
