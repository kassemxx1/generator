
import 'package:flutter/material.dart';

class printpage extends StatefulWidget {
  static const String id = 'printpage';
  const printpage({Key? key}) : super(key: key);

  @override
  State<printpage> createState() => _printpageState();
}

class _printpageState extends State<printpage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder:(c,i){
                    return ListTile(
                      subtitle: Text('kassem'),
                      trailing: Text('skdjaksjdksajd'),
                    );
                  }

              )),
          Container(
            child: MaterialButton(
              child: Text('Print'),
              onPressed: (){

              },
            )
          )
        ],
      ),
    );
  }
}
