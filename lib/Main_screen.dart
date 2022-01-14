import 'package:flutter/material.dart';
import 'Counter_Screen.dart';

class Main_Screen extends StatefulWidget {
  static const String id = 'Main_Screen';
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
              child: Text('test1'),
            ),
            MaterialButton(
              onPressed: (){

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