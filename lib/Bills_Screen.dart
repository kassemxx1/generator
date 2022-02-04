import 'dart:convert';
import 'dart:typed_data';

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
import 'Provider.dart';
import 'package:http/http.dart' as http;
class Bill_Screen extends StatefulWidget {
  static const String id = 'Bill_Screen';
  const Bill_Screen({Key? key}) : super(key: key);

  @override
  _Bill_ScreenState createState() => _Bill_ScreenState();
}

class _Bill_ScreenState extends State<Bill_Screen> {
  TextEditingController SearchController = TextEditingController();
  var Value = '';

  var id='';
  var name='';
  var phone='';
  var prev='';
  var curr='';
  var total='';
  var fixed='';
  var amount='';
  var price='';
  var extra='';
  var month='';
  var year='';

  Future<void> main() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.iBMPlexSansArabicRegular();
    // final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) => pw.Center(
          child: pw.Column(children: [
            pw.Text('month:' + month +'/'+year, style: pw.TextStyle(font: font)),

            pw.Text('name:' + name, style: pw.TextStyle(font: font),textDirection: pw.TextDirection.rtl),
            pw.Text('phone:' + phone, style: pw.TextStyle(font: font)),
            pw.Text('old Counter:' + prev, style: pw.TextStyle(font: font)),
            pw.Text('new Counter:' + curr, style: pw.TextStyle(font: font)),
            pw.Text('fixed:' + fixed, style: pw.TextStyle(font: font)),
            pw.Text('total:' + total, style: pw.TextStyle(font: font)),
            pw.Text('1 kilo:' + price, style: pw.TextStyle(font: font)),
            pw.Text('amount:' + amount, style: pw.TextStyle(font: font)),
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
    var url = Uri.parse(Main_Screen.url.toString() + 'getbill/$id');
    print(url);
    try{
      var response = await http.get(url);
      var data = json.decode(response.body);
      for(var i in data['recordsets'][0]){
        setState(() {
          name=i['Names'].toString();
          id=i['ClientCode'].toString();
          phone=i['smsmobile'].toString();
          prev=i['PrevCounter'].toString();
          curr=i['CurCounter'].toString();
          fixed=i['FixCost'].toString();
          total=i['CtrQty'].toString();
          extra=i['XtraQty'].toString();
          amount=i['Amount'].toString();
          price=i['Uprice'].toString();
          month=i['schMonth'].toString();
          year=i['schYear'].toString();
        });
      }

    }
    catch(err){
      print(err);
    }

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
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.blueGrey[400],
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.update)),
                ],
              ),
              body: ListView(
                children: [
                  Center(
                      child: Text(
                    Main_Screen.lastBillUpdate,
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
                        textStyle:
                            TextStyle(fontSize: 16, color: Colors.white)),
                    radioButtonValue: (value) {},
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
                          getBill(SearchController.text);
                          SearchController.clear();
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3,
                    child: Column(
                      children: [
                        Center(
                          child:Text(
                            'Month:' +month +'/'+year
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex:5,
                              child: Text('name:'+ name),
                            ),
                            Expanded(
                              flex:5,
                              child: Text('phone:'+ phone),
                            ),

                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex:5,
                              child: Text('old counter:'+ prev),
                            ),
                            Expanded(
                              flex:5,
                              child: Text('new count:'+ curr),
                            ),

                          ],
                        ),
                        Center(
                          child: Text('kilowatt:'+ total),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex:5,
                              child: Text('price:'+ price),
                            ),
                            Expanded(
                              flex:5,
                              child: Text('fixed:'+ fixed),
                            ),

                          ],
                        ),
                        Center(

                          child: Text('amount:'+ amount),
                        ),

                      ],
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


