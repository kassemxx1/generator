import 'package:flutter/material.dart';
import 'package:generator/Bills_Screen.dart';
import 'Counter_Screen.dart';
import 'LoginScreen.dart';
import 'Printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
class Main_Screen extends StatefulWidget {
  static const String id = 'Main_Screen';
  static List<String> suggestions = [];
  static bool loading = false;
 // static const String url = 'https://dry-thicket-38215.herokuapp.com/';
  static const String url = 'http://localhost:3000/';
  static var lastUpdate = '';
  const Main_Screen({Key? key}) : super(key: key);
  static var lastBillUpdate = '';


  @override
  _Main_ScreenState createState() => _Main_ScreenState();
}

class _Main_ScreenState extends State<Main_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(onPressed: (){} ,
              icon: Icon(Icons.exit_to_app)),

        ],
        iconTheme: IconThemeData(color: Colors.black),

      ),

      drawer: Drawer(

        child: Container(
          color: Colors.yellowAccent,
          child: ListView(
            children:[
              Container(
                width: MediaQuery.of(context).size.width,
               // color: Colors.yellowAccent,
                height: MediaQuery.of(context).size.height/4,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(100),bottomRight: Radius.elliptical(100, 100))
                ),
              ),
              SizedBox(
                height: 30,
              ),

              MaterialButton(
                onPressed: (){

                },
                child: Center(
                    child: Container(
                      color: Colors.blueGrey,
                    height: 50,
                    width: MediaQuery.of(context).size.width/2,
                    child: Center(child: Text('Printer Setup',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),)))),
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () async{
                  SharedPreferences _prefs = await SharedPreferences.getInstance();
                  _prefs.remove('user');
                  _prefs.remove('pass');
                  Navigator.pushNamed(context, Login_Screen.id);
                },
                child: Center(
                  child: Container(
                    color: Colors.blueGrey,
                    height: 50,
                    width: MediaQuery.of(context).size.width/2,
                    child: Center(
                      child: Text('Sign Out',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,

                      )),
                    ),
                  ),
                ),
              ),
            ]
          ),
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
              child: Container(
                height: 150,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: MaterialButton(

                        height: 100,
                        minWidth: MediaQuery.of(context).size.width -30,
                        color: Colors.blueGrey,
                        onPressed: (){
                          Navigator.pushNamed(context, Counter_Screen.id);
                        },
                        child: Text('Counter',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,color: Colors.white),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        height: 100,
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: CircularStepProgressIndicator(
                            totalSteps: 100,
                            currentStep: 65,
                            stepSize: 10,
                            selectedStepSize: 20,
                            unselectedStepSize: 20,
                            selectedColor: Colors.red,
                            unselectedColor: Colors.purple[400],
                            child: Center(child: Text('65/100')),

                            roundedCap: (_, __) => true,


                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                height: 100,
                minWidth: MediaQuery.of(context).size.width -30,
                color: Colors.blueGrey,
                onPressed: (){
                  Navigator.pushNamed(context, Bill_Screen.id);
                },
                child: Text('Bills',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,color: Colors.white),),
              ),
            ),
          ),
        ],
      ),

    );

  }
}
