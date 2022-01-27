import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';
import 'Main_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Provider.dart';

class Counter_Screen extends StatefulWidget {
  static const String id = 'Counter_Screen';
  static List<String> suggestions = [];
  const Counter_Screen({Key? key}) : super(key: key);
  @override
  _Counter_ScreenState createState() => _Counter_ScreenState();
}

class _Counter_ScreenState extends State<Counter_Screen> {
  TextEditingController SearchController = TextEditingController();
  var Value = '';
  var Type = '';
  // var suggestions = [];
//  var Clients =[{'id':'1','name':'kassem abboud','code':'23232','box':'9','lastcounter':'217','currentcounter':'','month':'1' },{'id':'2','name':'tarek ismail','code':'23432434','box':'9','lastcounter':'180','currentcounter':'190','month':'1' },{'id':'3','name':'ali abboud','code':'23232','box':'5','lastcounter':'500','currentcounter':'','month':'1' }];
  var Clients = [];
  List<client> TempList = [];
  var success = '';
  setcontname(String n) {
    var n = TextEditingController();
    return n;
  }

  void getlast() async {
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('first') == false) {
      setState(() {
        Main_Screen.lastUpdate = formatDate(
                DateTime.parse(_prefs.getString('lastupdate').toString()),
                [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
            ': آخر تحديث';
      });

      print(_prefs.getString('lastupdate'));
      print(Main_Screen.lastUpdate);
    } else {
      Main_Screen.lastUpdate = 'Please Update';
    }
    EasyLoading.dismiss();
  }

  void getclients() async {
    EasyLoading.show();
    Clients.clear();
    // var url=Uri.parse('http://localhost:5000');
    // var response = await http.get(url);
    // var data = json.decode(response.body);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Clients = json.decode(_prefs.getString('allclients').toString());
    for (var i in Clients) {
      var id = i['id'].toString();
      var name = i['name'].toString();
      var lastcounter = i['lastcounter'].toString();
      var box = i['box'].toString();
      Clients.add(
          {'id': id, 'name': name, 'lastcounter': lastcounter, 'box': box});
    }
    setState(() {
      getData('name');
    });

    EasyLoading.dismiss();
  }

  void getData(String type) {
    EasyLoading.show();
    Main_Screen.suggestions.clear();
    for (var i in Clients) {
      setState(() {
        Main_Screen.suggestions.add(i[type].toString());
      });
    }
    EasyLoading.dismiss();
  }
  String getId(String name){
    for(var i in Clients){
      if(i['name']==Value){
        return i['id'];
      }
      if(i['id']==Value){
        return i['id'];
      }

    }
    return(Value);
  }

  void GetInfo(String value) async {
    EasyLoading.show();
    TempList.clear();
    var url = Uri.parse(Main_Screen.url.toString() + '/getcounters');
    Map<String, dynamic> bbb = {
      'Option': Type == 'box' ? 2 : 1,
      'CodeId': Type == 'box' ? Value : getId(Value) ,

    };
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      for (var i in data['recordsets'][0]) {
        setState(() {
          TempList.add(client(
            i['clientcode'].toString(),
            i['clientName'].toString(),
            i['prevCtr'].toString(),
            i['newCtr'].toString(),
            setcontname('controller' + Clients.indexOf(i).toString()),
          ));
        });
        EasyLoading.dismiss();
      }
    } catch (err) {
      Fluttertoast.showToast(
          msg: "internet problem",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      EasyLoading.dismiss();


    }

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    getclients();
    getlast();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Clientss>.value(
        value: Clientss(),
        child: Consumer<Clientss>(
          builder: (context, value, child) => Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Provider.of<Clientss>(context, listen: false)
                          .getclients();
                      getclients();
                    },
                    icon: Icon(Icons.update)),
              ],
            ),
            body: ListView(
              children: [
                Text(Main_Screen.lastUpdate),
                CustomRadioButton(
                  enableShape: false,
                  elevation: 0,
                  absoluteZeroSpacing: true,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: [
                    'name',
                    'box',
                    'id',
                  ],
                  buttonValues: [
                    "name",
                    "box",
                    "id",
                  ],
                  buttonTextStyle: ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: TextStyle(fontSize: 16)),
                  radioButtonValue: (value) {
                    setState(() {
                      Type = value.toString();
                      getData(Type);
                    });
                  },
                  selectedColor: Theme.of(context).backgroundColor,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: EasyAutocomplete(
                      controller: SearchController,
                      suggestions: Main_Screen.suggestions,
                      autofocus: false,
                      onChanged: (value) {
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
                  onPressed: () {
                    SearchController.clear();
                    GetInfo(Value);
                  },
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 60,
                    columns: [
                      DataColumn(
                          label: Center(
                        child: Center(child: Text('ID')),
                      )),
                    ],
                    rows: TempList.map((client) =>
                        DataRow(selected: true, cells: [
                          DataCell(
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              client.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Center(child: Text(client.LastCounter,style: TextStyle(color: Colors.red,fontSize: 20),)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: TextField(
                                          controller: client.cont,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText:
                                                client.CurrentCounter.toString(),

                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {},
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          EasyLoading.show();
                                          var url = Uri.parse(
                                              'http://localhost:5000/transaction');

                                          Map<String, dynamic> bbb = {
                                            'id': int.parse(client.id),
                                            'counter':
                                                int.parse(client.cont.text),
                                          };
                                          try {
                                            var response = await http.post(url,
                                                headers: <String, String>{
                                                  'Content-Type':
                                                      'application/x-www-form-urlencoded; charset=UTF-8',
                                                },
                                                body: json.encode(bbb));
                                            var data =
                                                json.decode(response.body);
                                            print(response.body);
                                            if (data['state'] == 1) {
                                              Fluttertoast.showToast(
                                                  msg: "Success",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              client.cont.clear();
                                              EasyLoading.dismiss();
                                            }
                                            if (data['state'] == 2) {
                                              Fluttertoast.showToast(
                                                  msg: "error",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              EasyLoading.dismiss();
                                            }
                                          } catch (err) {
                                            Fluttertoast.showToast(
                                                msg: "internet problem",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            EasyLoading.dismiss();
                                          }
                                        },
                                        child: Text('Submit',style: TextStyle(
                                          color:Colors.blue,fontSize: 20
                                        ),),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ])).toList(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class client {
  String id;
  String name;
  String LastCounter;
  String CurrentCounter;

  TextEditingController cont;
  client(this.id, this.name, this.LastCounter, this.CurrentCounter, this.cont);
}
