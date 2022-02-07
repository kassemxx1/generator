import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:generator/Payment_Screen.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'Main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
class Bill_Screen extends StatefulWidget {
  static const String id = 'Bill_Screen';
  static var client = '';
  const Bill_Screen({Key? key}) : super(key: key);

  @override
  _Bill_ScreenState createState() => _Bill_ScreenState();
}

class _Bill_ScreenState extends State<Bill_Screen> {
  TextEditingController SearchController = TextEditingController();
  var Value = '';
  var Type='';
  var Clients = [];
  var TempList = [];

  void refreshCLient() {
    print(Bill_Screen.client);
    if(Bill_Screen.client ==''){
    }
    else{
      getBackBill(Bill_Screen.client);
    }

  }


  void getBill(String id) async{
    EasyLoading.show();
    TempList.clear();
    var url = Uri.parse(Main_Screen.url.toString() + 'getSpecificbill');


    print(url);
    try{

      Map<String, dynamic> bbb = {
        'year':DateTime.now().year,
        'month':DateTime.now().month,
        'id': Type == 'clientcode' ? Value : getId(Value),
      };
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      for(var i in data['recordsets'][0]){
        setState(() {
          TempList.add(Bill(i['ClientCode'].toString(), i['Names'].toString(),
              i['schMonth'].toString(), i['schYear'].toString(), i['balance'].toString(),
              i['netAmount'].toString(), i['fctnbr'].toString(),i['MonthAr'],i['AccountCode'].toString(),i['schType'].toString(),i['schNumber'].toString(),i['PrevCounter'].toString(),i['CurCounter'].toString(),i['Uprice'].toString()));

        });
      }
      EasyLoading.dismiss();
    }
    catch(err){
      print(err);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();

  }
  void getBackBill(String id) async{
    EasyLoading.show();
    TempList.clear();
    var url = Uri.parse(Main_Screen.url.toString() + 'getSpecificbill');


    print(url);
    try{

      Map<String, dynamic> bbb = {
        'year':DateTime.now().year,
        'month':DateTime.now().month,
        'id': id,
      };
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      print(data);
      for(var i in data['recordsets'][0]){
        setState(() {
          TempList.add(Bill(i['ClientCode'].toString(), i['Names'].toString(),
              i['schMonth'].toString(), i['schYear'].toString(), i['balance'].toString(),
              i['netAmount'].toString(), i['fctnbr'].toString(),i['MonthAr'],i['AccountCode'].toString(),i['schType'].toString(),i['schNumber'].toString(),i['PrevCounter'].toString(),i['CurCounter'].toString(),i['Uprice'].toString()));

        });
      }
      EasyLoading.dismiss();
    }
    catch(err){
      print(err);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();

  }
  void getallBills() async {
    var clientdesc = [];
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    clientdesc.clear();
    Main_Screen.suggestionsbill.clear();
    Main_Screen.loadingbill = true;
    var url = Uri.parse(Main_Screen.url.toString()+'getbills');
    try{
      var response = await http.get(url);
      var data = json.decode(response.body);
      for (var i in data['recordsets'][0]) {
        var monthnumb=i['schMonth'].toString();
        var yearnumb=  i['schYear'].toString();
        var clientcode =i['ClientCode'].toString();
        var names = i['Names'].toString();
        var billnumb=i['fctnbr'].toString();
        var smsmobile=i['smsmobile'].toString();
        var PrevCounter = i['PrevCounter'].toString();
        var CurCounter=i['CurCounter'].toString();
        var FixCost=i['FixCost'].toString();
        var CtrQty=i['CtrQty'].toString();
        var XtraQty=i['XtraQty'].toString();
        var Uprice=i['Uprice'].toString();

        clientdesc.add({
          'monthnumb' : monthnumb,
          'yearnumb':yearnumb,
          'clientcode':clientcode,
          'names':names,
          'billnumb':billnumb,
          'smsmobile':smsmobile,
          'PrevCounter':PrevCounter,
          'CurCounter':CurCounter,
          'FixCost':FixCost,
          'CtrQty':CtrQty,
          'XtraQty':XtraQty,
          'Uprice':Uprice,
        });
      }
      _prefs.setString('lastupdatebill', DateTime.now().toString());
      _prefs.remove('allbills');
      _prefs.setString('allbills', json.encode(clientdesc));
      _prefs.setBool('second', false);
      Main_Screen.lastBillUpdate = formatDate(
          DateTime.parse(_prefs.getString('lastupdatebill').toString()),
          [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
          ': آخر تحديث';
      getclients();
      EasyLoading.dismiss();
      Main_Screen.loadingbill = false;
    }
    catch(err){
      print(err);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }
  void getlast() async {
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('second') == false) {
      setState(() {
        Main_Screen.lastBillUpdate = formatDate(
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
      Clients = json.decode(_prefs.getString('allbills').toString());
    });
  }
  void getData(String type) {
    EasyLoading.show();
    Main_Screen.suggestionsbill.clear();
    for (var i in Clients) {
      setState(() {
        Main_Screen.suggestionsbill.add(i[type].toString());
      });
    }
    EasyLoading.dismiss();
  }
  String getId(String name) {
    for (var i in Clients) {
      if (i['names'] == Value) {
        return i['clientcode'];
      }
      if (i['billnumb'] == Value) {
        return i['clientcode'];
      }
    }
    return (Value);
  }
  void getCounters(String id){
    for(var i in Clients){
      if(id == i['clientcode']){
        setState(() {

        });
      }
    }
  }
  @override
  void initState() {
    refreshCLient();
    getlast();
    getclients();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
              appBar: AppBar(
                title: Text(
                  'Bills',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                actions: [
                  IconButton(onPressed: () {
                    getallBills();
                  }, icon: Icon(Icons.update)),
                ],
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      Main_Screen.lastBillUpdate,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  CustomRadioButton(
                    enableShape: false,
                    elevation: 0,
                    absoluteZeroSpacing: true,
                    unSelectedColor: Colors.grey,
                    selectedBorderColor: Colors.blueGrey,
                    buttonLables: [
                      'Name',
                      'ID',
                      'Bill',
                    ],
                    buttonValues: [
                      "names",
                      "clientcode",
                      "billnumb",
                    ],
                    buttonTextStyle: ButtonTextStyle(

                        selectedColor: Colors.white,
                        unSelectedColor: Colors.black,
                        textStyle:
                            TextStyle(fontSize: 18, color: Colors.white)),
                    radioButtonValue: (value) {

                      TempList.clear();
                      setState(() {

                        SearchController.clear();
                        Type=value.toString();
                        getData(value.toString());
                        SearchController.text=' ';
                        SearchController.clear();
                      });

                    },
                    selectedColor: Theme.of(context).backgroundColor,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: EasyAutocomplete(
                        controller: SearchController,
                        suggestions: Main_Screen.suggestionsbill,
                        autofocus: true,
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
                          getBill(SearchController.text);
                          SearchController.clear();
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
                               width: MediaQuery.of(context).size.width*1.3/5,
                               child: Text('الاسم',style: TextStyle(
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black
                               ),),
                             )
                         ),
                         DataColumn(
                           label: Container(
                             width: MediaQuery.of(context).size.width*0.9/5,
                             child: Text('شهر',style: TextStyle(
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black
                             ),),
                           )
                         ),
                         DataColumn(
                             label: Container(
                               width: MediaQuery.of(context).size.width*0.9/5,
                               child: Text('المبلغ',style: TextStyle(
                                   fontSize: 18,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black
                               ),),
                             )
                         )
                       ],
                      rows: TempList.map((Bill) =>
                        DataRow(
                          onLongPress: (){
                            Payment_Screen.ID = Bill.ID;
                            Payment_Screen.name = Bill.name;
                            Payment_Screen.AcountCode = Bill.AcountCode;
                            Payment_Screen.netAmount = Bill.netAmount;
                            Payment_Screen.Balance = Bill.Balance;
                            Payment_Screen.MonthAr = Bill.MonthAr;
                            Payment_Screen.month = Bill.month;
                            Payment_Screen.Year = Bill.Year;
                            Payment_Screen.billnumb = Bill.billnumb;
                            Payment_Screen.schType = Bill.schType;
                            Payment_Screen.schCtrNbr = Bill.schNumber;
                            Payment_Screen.old = Bill.Prev;
                            Payment_Screen.New = Bill.Current;
                            Payment_Screen.price = Bill.Price;




                            Navigator.pushNamed(context, Payment_Screen.id);

                          },
                            cells:[
                              DataCell(
                            Text(
                                Bill.name,style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                            ),
                            ),
                            ),
                              DataCell(
                                Text(
                                  Bill.MonthAr,style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  Bill.Balance,style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                ),
                                ),
                              ),


                           ] )).toList(),
                            ),
                     ),


                ],
              ),
            );
  }
}


class Bill {
  String ID;
  String name;
  String month;
  String Year;
  String Balance;
  String netAmount;
  String billnumb;
  String MonthAr;
  String AcountCode;
  String schType;
  String schNumber;
  String Prev;
  String Current;
  String Price;


  Bill(this.ID,this.name,this.month,this.Year,this.Balance,this.netAmount,this.billnumb,this.MonthAr,this.AcountCode,this.schType,this.schNumber,this.Prev,this.Current,this.Price);
}