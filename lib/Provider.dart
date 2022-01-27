import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Main_screen.dart';
import 'package:http/http.dart' as http;

class Clientss extends ChangeNotifier {
  var clientdesc = [];

  List<String> boxs = [];
  void getclients() async {
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    clientdesc.clear();
    Main_Screen.suggestions.clear();
    Main_Screen.loading = true;
    var url = Uri.parse(Main_Screen.url.toString());
    var response = await http.get(url);
    var data = json.decode(response.body);
    for (var i in data['recordsets'][0]) {
      var id = i['clientcode'].toString();
      var name = i['clientname'].toString();
      var lastcounter = i['oldcounter'].toString();
      var box = i['boxcode'].toString();
      clientdesc.add({
        'id': id,
        'name': name,
        'lastcounter': lastcounter,
        'box': box
      });
    }
    _prefs.setString('lastupdate', DateTime.now().toString());
    _prefs.remove('allclients');
    _prefs.setString('allclients', json.encode(clientdesc));
    _prefs.setBool('first', false);
    Main_Screen.lastUpdate = formatDate(
        DateTime.parse(_prefs.getString('lastupdate').toString()),
        [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
        ': آخر تحديث';
    EasyLoading.dismiss();
    print(Main_Screen.lastUpdate);
    Main_Screen.loading = false;
    notifyListeners();
  }




}