import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generator/Main_screen.dart';

class Login_Screen extends StatefulWidget {
  static const String id = 'Login_Screen';
  const Login_Screen({Key? key}) : super(key: key);
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}
class _Login_ScreenState extends State<Login_Screen> {
  TextEditingController UserController = TextEditingController();
  TextEditingController PassController = TextEditingController();
  bool _validate = true;

  var Name = '';
  var Pass ='';
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
                  Navigator.pushNamed(context, Main_Screen.id);
              },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
