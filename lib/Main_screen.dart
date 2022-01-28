import 'package:flutter/material.dart';
import 'Counter_Screen.dart';
import 'LoginScreen.dart';
import 'Printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Main_Screen extends StatefulWidget {
  static const String id = 'Main_Screen';
  static List<String> suggestions = [];
  static bool loading = false;
  static const String url = 'https://dry-thicket-38215.herokuapp.com/';
  static var lastUpdate = '';
  const Main_Screen({Key? key}) : super(key: key);


  @override
  _Main_ScreenState createState() => _Main_ScreenState();
}

class _Main_ScreenState extends State<Main_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Main'
        ),
        actions: [
          IconButton(onPressed: (){} ,
              icon: Icon(Icons.exit_to_app)),

        ],

      ),
      drawer: Drawer(
        child: ListView(
          children:[
            MaterialButton(
              onPressed: (){

              },
              child: Text('Printer Setup'),
            ),
            MaterialButton(
              onPressed: () async{
                SharedPreferences _prefs = await SharedPreferences.getInstance();
                _prefs.remove('user');
                _prefs.remove('pass');
                Navigator.pushNamed(context, Login_Screen.id);
              },
              child: Text('Sign Out'),
            ),
          ]
        )
      ),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 30,
          ),),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                height: 100,
                minWidth: MediaQuery.of(context).size.width -30,
                color: Colors.blue,
                onPressed: (){
                  Navigator.pushNamed(context, Counter_Screen.id);
                },
                child: Text('Counter',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                height: 100,
                minWidth: MediaQuery.of(context).size.width -30,
                color: Colors.blue,
                onPressed: (){
                },
                child: Text('Bills',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
              ),
            ),
          ),
        ],
      ),

    );

  }
}
