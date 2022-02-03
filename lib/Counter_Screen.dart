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
  var Clients = [];
  List<client> TempList = [];
  var success = '';

  setcontname(String n) {
    var n = TextEditingController();
    return n;
  }

  bool checkifnum(String Numb) {
    if (int.tryParse(Numb) == null) {
      return true;
    } else {
      return false;
    }
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
    } else {
      Main_Screen.lastUpdate = 'Please Update';
    }
    EasyLoading.dismiss();
  }

  void getclients() async {
    Clients.clear();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      Clients = json.decode(_prefs.getString('allclients').toString());
    });
    print(Clients);
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

  String getId(String name) {
    for (var i in Clients) {
      if (i['name'] == Value) {
        return i['id'];
      }
      if (i['id'] == Value) {
        return i['id'];
      }
    }
    return (Value);
  }

  String getPhone(String name) {
    for (var i in Clients) {
      if (i['id'].toString() == name.toString()) {
        return i['phone'].toString();
      } else {
        return '';
      }
    }
    return '';
  }

  void GetInfo(String value) async {
    EasyLoading.show();
    TempList.clear();
    var url = Uri.parse(Main_Screen.url.toString() + 'getcounters');
    Map<String, dynamic> bbb = {
      'Option': Type == 'box' ? 2 : 1,
      'CodeId': Type == 'box' ? Value : getId(Value),
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
            false,
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
            backgroundColor: Colors.yellowAccent,
            appBar: AppBar(
              title: Text(
                'Counters',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.blueGrey[400],
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
                Center(
                    child: Text(
                  Main_Screen.lastUpdate,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                CustomRadioButton(
                  enableShape: false,
                  elevation: 0,
                  absoluteZeroSpacing: true,
                  unSelectedColor: Colors.yellowAccent,
                  selectedBorderColor: Colors.blueGrey,
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
                      textStyle: TextStyle(fontSize: 16, color: Colors.white)),
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
                      },
                    )),
                Container(
                  height: 40,
                  child: Center(
                    child: Text(
                      Value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    color: Colors.blueGrey,
                    child: MaterialButton(
                      child: Text('Get',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        SearchController.clear();
                        GetInfo(Value);
                      },
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 70,
                    columns: [
                      DataColumn(
                          label: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Column(
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Old Counter',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ))),
                            Expanded(
                              flex: 3,
                              child: Center(
                                  child: Text('New Counter',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ))),
                            ),
                            Expanded(
                              flex: 4,
                              child: Center(
                                  child: Text('#',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ))),
                            )
                          ],
                        ),
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
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            Center(
                                                child: Text(
                                              client.LastCounter,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20),
                                            )),
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
                                              hintText: client.CurrentCounter
                                                  .toString(),
                                              errorText: client._validate
                                                  ? 'Wrong Input'
                                                  : null,
                                            ),
                                            keyboardType: TextInputType.number,
                                          )),
                                      Expanded(
                                        flex: 4,
                                        child: MaterialButton(
                                          onPressed: () async {
                                            print(checkifnum(client.cont.text));
                                            if (checkifnum(client.cont.text
                                                        .toString()) ==
                                                    true ||
                                                int.parse(client.cont.text) <=
                                                    int.parse(
                                                        client.LastCounter)) {
                                              setState(() {
                                                client._validate = true;
                                              });
                                            } else {
                                              setState(() {
                                                client._validate = false;
                                              });
                                              SharedPreferences _prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              EasyLoading.show();
                                              var url = Uri.parse(
                                                  Main_Screen.url +
                                                      'transaction');

                                              Map<String, dynamic> bbb = {
                                                'id': client.id.toString(),
                                                'counter':
                                                    int.parse(client.cont.text),
                                                'userName': _prefs
                                                    .getString('user')
                                                    .toString()
                                              };
                                              try {
                                                var response = await http.post(
                                                    url,
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/x-www-form-urlencoded; charset=UTF-8',
                                                    },
                                                    body: json.encode(bbb));
                                                var data =
                                                    json.decode(response.body);
                                                if (data['state'] == 1) {
                                                  Fluttertoast.showToast(
                                                      msg: "Success",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  // client.cont.clear();
                                                  EasyLoading.dismiss();
                                                }
                                                if (data['state'] == 2) {
                                                  Fluttertoast.showToast(
                                                      msg: "error",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  EasyLoading.dismiss();
                                                }
                                              } catch (err) {
                                                Fluttertoast.showToast(
                                                    msg: "internet problem",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                EasyLoading.dismiss();
                                              }
                                            }
                                          },
                                          child: Text(
                                            'Submit',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20),
                                          ),
                                        ),
                                      )
                                    ],
                                  )), onLongPress: () {
                            var phonenumber = '';
                            for (var i in Clients) {
                              if (i['id'] == client.id) {
                                setState(() {
                                  phonenumber = i['phone'];
                                });
                              }
                            }
                            //print(getPhone(client.id));

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.yellowAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Text('id:' + client.id),
                                          Text('name:' + client.name),
                                          Text('PhoneNumber :' + phonenumber),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('done'),
                                      )
                                    ],
                                  );
                                });
                          }),
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
  bool _validate;
  String id;
  String name;
  String LastCounter;
  String CurrentCounter;
  TextEditingController cont;
  client(this.id, this.name, this.LastCounter, this.CurrentCounter, this.cont,
      this._validate);
}
