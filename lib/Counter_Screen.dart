import 'package:flutter/material.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class Counter_Screen extends StatefulWidget {
  static const String id = 'Counter_Screen';
  static List<String> suggestions = [];
  const Counter_Screen({Key? key}) : super(key: key);
  @override
  _Counter_ScreenState createState() => _Counter_ScreenState();
}

class _Counter_ScreenState extends State<Counter_Screen> {
  TextEditingController SearchController = TextEditingController();
  var Value ='';
  var Type ='';
  var suggestions = [
    'kassem abboud',
    'tarek ismail',
    'ali abboud',
  ];
  var Clients =[{'id':'1','name':'kassem abboud','code':'23232','box':'9','lastcounter':'217','currentcounter':'','month':'1' },{'id':'2','name':'tarek ismail','code':'23432434','box':'9','lastcounter':'180','currentcounter':'190','month':'1' },{'id':'3','name':'ali abboud','code':'23232','box':'5','lastcounter':'500','currentcounter':'','month':'1' }];
List<client> TempList =[];
setcontname(String n){
  var n =TextEditingController();
  return n;
}
void getData(String type) {
  suggestions.clear();
  for (var i in Clients){
    setState(() {
      suggestions.add(
          i[type].toString());
    });
  }
}
void GetInfo( String value){
TempList.clear();
  for (var i in Clients){
  print(i);
    if(i[Type]==Value){
      print(i[value]);
      setState(() {
        TempList.add(client(i['id'].toString(), i['name'].toString(), i['lastcounter'].toString(), i['currentcounter'].toString(), i['month'].toString(),setcontname('controller' + Clients.indexOf(i).toString())));
      });
    }
  }
  print(TempList);
}
  @override
  void initState() {
  Type='name';
  getData('name');
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: ListView(
        children: [
          CustomRadioButton(
            enableShape: false,
            elevation: 0,
            absoluteZeroSpacing: true,
            unSelectedColor: Theme.of(context).canvasColor,
            buttonLables: [
              'name',
              'box',
              'code',
            ],
            buttonValues: [
              "name",
              "box",
              "code",
            ],
            buttonTextStyle: ButtonTextStyle(
                selectedColor: Colors.white,
                unSelectedColor: Colors.black,
                textStyle: TextStyle(fontSize: 16)),
            radioButtonValue: (value) {
              setState(() {
                Type=value.toString();
                getData(value.toString());
              });

            },
            selectedColor: Theme.of(context).backgroundColor,
          ),
          Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: EasyAutocomplete(
                controller: SearchController,
                suggestions: suggestions,
                autofocus: false,
                onChanged: (value){
                  setState(() {
                    Value = value;
                  });
                  print(Value);
                },
              )),
          Center(
            child: Text(Value),
          ),
          MaterialButton(
            child: Text('Get'),
            onPressed: (){
              SearchController.clear();
              GetInfo(Value);
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: DataTable(

              dataRowHeight: 60,
              columns:[
                DataColumn(label: Center(

                  child: Center(child: Text('ID')),
                )),
                DataColumn(label: Center(
                  child: Center(child: Text('Name')),
                )),
                DataColumn(label: Center(
                  child: Center(child: Text('LastCounter')),
                )),
                DataColumn(label: Center(
                  child: Center(child: Text('Counter')),
                )),
                DataColumn(label: Center(
                  child: Text('#'),
                )),

              ],
              rows:TempList.map((client) =>
                  DataRow(selected: true ,cells:[
                    DataCell(
                      Container(
                        width:MediaQuery.of(context).size.width/10,
                        child:Center(child: Text(client.id)),
                      ),
                    ),

                    DataCell(
                      Container(
                        width: MediaQuery.of(context).size.width*3/10,
                        child:Center(child: Text(client.name)),
                      ),
                    ),DataCell(
                      Container(
                        width: MediaQuery.of(context).size.width/10,
                        child:Center(child: Text(client.LastCounter)),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: MediaQuery.of(context).size.width*2/10,
                        child:Center(
                          child: TextField(
                            controller: client.cont,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              labelText: client.CurrentCounter.toString(),
                              suffix: client.cont.text.isEmpty ?
                                  Container(
                                    width: 0,
                                  )
                                  :
                                IconButton(onPressed: (){
                                  client.cont.clear();
                                },
                                    icon: Icon(Icons.close)
                                ),

                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value){

                            },
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width:MediaQuery.of(context).size.width*2/10,
                        child:MaterialButton(
                          onPressed: (){

                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ),
                      ])
              ).toList(),
            ),
          )
        ],
      ),
    );
  }
}
class client {
  String id;
  String name;
  String LastCounter;
  String CurrentCounter;
  String Month;
  TextEditingController cont;
  client(this.id,this.name,this.LastCounter,this.CurrentCounter,this.Month,this.cont);
}