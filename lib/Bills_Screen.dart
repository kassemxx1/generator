import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'Main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
class Bill_Screen extends StatefulWidget {
  static const String id = 'Bill_Screen';
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

  Future<void> main() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.iBMPlexSansArabicRegular();
    // final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) => pw.Center(
          child: pw.Column(children: [

          ]),
        ),
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
//   await file.writeAsBytes(await pdf.save());
   await Printing.sharePdf(bytes: await pdf.save(), filename: 'example.pdf');
   //  await Printing.layoutPdf(
   //      onLayout: (PdfPageFormat format) async => pdf.save());

    // await PdfPreview(
    //    build: (format) => pdf.save(),
    //  );
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
      print(data);
      for(var i in data['recordsets'][0]){
        setState(() {
          TempList.add(Bill(i['ClientCode'].toString(), i['Names'].toString(),
              i['schMonth'].toString(), i['schYear'].toString(), i['balance'].toString(),
              i['netAmount'].toString(), i['fctnbr'].toString(),i['MonthAr']));

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
        clientdesc.add({
          'monthnumb' : monthnumb,
          'yearnumb':yearnumb,
          'clientcode':clientcode,
          'names':names,
          'billnumb':billnumb,
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
  @override
  void initState() {
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
                      setState(() {
                        Type=value.toString();
                      });
                      getData(value.toString());
                    },
                    selectedColor: Theme.of(context).backgroundColor,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: EasyAutocomplete(
                        controller: SearchController,
                        suggestions: Main_Screen.suggestionsbill,
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
                                  Bill.netAmount,style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                ),
                                ),
                              ),


                           ] )).toList(),
                            ),
                     ),

                  MaterialButton(
                    onPressed: (){
                      main();
                  },
                    child: Text('Pay'),
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
  Bill(this.ID,this.name,this.month,this.Year,this.Balance,this.netAmount,this.billnumb,this.MonthAr);
}