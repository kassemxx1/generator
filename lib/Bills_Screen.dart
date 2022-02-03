import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
class Bill_Screen extends StatefulWidget {
  static const String id = 'Bill_Screen';
  const Bill_Screen({Key? key}) : super(key: key);

  @override
  _Bill_ScreenState createState() => _Bill_ScreenState();
}

class _Bill_ScreenState extends State<Bill_Screen> {

  Future<void> main(String name) async {
      final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
      final font = await PdfGoogleFonts.nunitoExtraLight();
   // final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            children: [
              pw.Text('name:' +name, style: pw.TextStyle(font: font)),
              pw.Text('name:' +name, style: pw.TextStyle(font: font)),
              pw.Text('name:' +name, style: pw.TextStyle(font: font)),
              pw.Text('name:' +name, style: pw.TextStyle(font: font)),
              pw.Text('name:' +name, style: pw.TextStyle(font: font)),
              pw.Text('name:' +name, style: pw.TextStyle(font: font)),
              pw.Text('name:' +name, style: pw.TextStyle(font: font)),
              pw.Text('name:' +name, style: pw.TextStyle(font: font)),
            ]
          ),
        ),
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
//   await file.writeAsBytes(await pdf.save());
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'example.pdf');
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => pdf.save());

   // await PdfPreview(
   //    build: (format) => pdf.save(),
   //  );


  }

  // Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
  //   final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  //   final font = await PdfGoogleFonts.nunitoExtraLight();
  //
  //   pdf.addPage(
  //
  //     pw.Page(
  //
  //       pageFormat: format,
  //       build: (context) {
  //         return pw.Column(
  //           children: [
  //             pw.SizedBox(
  //               width: double.infinity,
  //               child: pw.FittedBox(
  //                 child: pw.Text(title, style: pw.TextStyle(font: font)),
  //               ),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Flexible(child: pw.FlutterLogo())
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //
  //   return pdf.save();
  // }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: MaterialButton(
            onPressed: () async{
              main('kassem abboud');


            },
            child: Text('test'),
          ),

        ),
      ),
    );
  }
}
