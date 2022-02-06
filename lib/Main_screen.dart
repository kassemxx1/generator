import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:generator/Bills_Screen.dart';
import 'Counter_Screen.dart';
import 'LoginScreen.dart';
import 'Printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;

class Main_Screen extends StatefulWidget {
  static const String id = 'Main_Screen';
  static List<String> suggestions = [];
  static bool loading = false;
  static List<String> suggestionsbill = [];
  static bool loadingbill = false;
 // static const String url = 'https://dry-thicket-38215.herokuapp.com/';
  static const String url = 'http://localhost:3000/';
  static var lastUpdate = '';
  const Main_Screen({Key? key}) : super(key: key);
  static var lastBillUpdate = '';


  @override
  _Main_ScreenState createState() => _Main_ScreenState();
}

class _Main_ScreenState extends State<Main_Screen> {
  var counter =50;
  var totalcounter = 100;
  var bills =40;
  var totalBills=100;

  void getrecords(int option) async{
    var url = Uri.parse(Main_Screen.url.toString() + 'getcounters');
    try {
      Map<String, dynamic> bbb = {
        'id':'',
        'month':DateTime.now().month,
        'Option':option,

      };
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      print(data);
     for(var i in data['recordsets'][0]){
       if(option==3){
         setState(() {
           counter = i['Countred'];
           if(i['ClientCount']>20){
             totalcounter=i['ClientCount'];
           }

         });
       }

       if(option==4){
         setState(() {
           bills = i['Countred'];
           if(i['ClientCount']>20){
             totalBills=i['ClientCount'];
           }

         });
       }
     }
    }

    catch (err){

    }
  print(totalBills);
    print(totalcounter);

  }
  @override
  void initState() {
    getrecords(3);
    getrecords(4);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
      body: GridView.count(
        crossAxisCount: 2,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, Counter_Screen.id);
              },
              child: Card(
                elevation: 20,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb,color: Colors.yellow,size: 50,),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Counter',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,color: Colors.black),),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularStepProgressIndicator(
                  totalSteps: int.parse(totalcounter.toString()),
                  currentStep: int.parse(counter.toString()),
                  stepSize: 10,
                  selectedStepSize: 25,
                  unselectedStepSize: 25,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.purple[400],
                  child: Center(child: Text(counter.toString() +'/' + totalcounter.toString(),style: TextStyle(
                    fontSize: 20,
                  ),)),

                  roundedCap: (_, __) => true,


                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, Bill_Screen.id);
              },
              child: Card(
                elevation: 20,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.article_outlined,color: Colors.pinkAccent,size: 50,),
                      SizedBox(height: 20,),
                      Text('Bills',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,color: Colors.black),),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularStepProgressIndicator(
                  totalSteps: totalBills ,
                  currentStep: bills,
                  stepSize: 10,
                  selectedStepSize: 25,
                  unselectedStepSize: 25,
                  selectedColor: Colors.greenAccent,
                  unselectedColor: Colors.yellowAccent,
                  child: Center(child: Text(bills.toString() +'/' + totalBills.toString(),style: TextStyle(
                    fontSize: 20,
                  ),)),

                  roundedCap: (_, __) => true,


                ),
              ),
            ),
          ),
        ],
      ),

    );

  }
}
