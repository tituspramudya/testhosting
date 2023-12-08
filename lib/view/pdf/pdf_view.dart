import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:example/view/pdf/preview_screen.dart';

Future<void> createPdf
(
  TextEditingController nameController,
  TextEditingController guruController,
  TextEditingController deskripsiController,
  String id,
  File image,
  BuildContext context,
) async {
  final doc = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  final imageLogo = (await rootBundle.load("assets/logo.png")).buffer.asUint8List();
  final imageInvoice = pw.MemoryImage(imageLogo);
  
  pw.ImageProvider pdfImageProvider(Uint8List imageBytes) {
    return pw.MemoryImage(imageBytes);
  }

  final ByteData data = await rootBundle.load(image.path);
  final Uint8List imageBytes = data.buffer.asUint8List();


  final pdfTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (pw.Context context) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex('#FFB059'),
            width: 1.w,
          ),
        ),
      );
    },
  );

  doc.addPage(
    pw.MultiPage(
      pageTheme: pdfTheme,
      header: (pw.Context context) {
        return headerPDF();
      },
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                      margin: pw.EdgeInsets.symmetric(
                          horizontal: 2.h, vertical: 2.h)),
                imageFromInput(pdfImageProvider, imageBytes),

                personalDataFromInput(nameController, guruController, deskripsiController),
                pw.SizedBox(height: 10.h),
                
                topOfInvoice(imageInvoice),
                barcodeGaris(id),
                pw.SizedBox(height: 5.h),

                barcodeKotak(id),
                pw.SizedBox(height: 1.h),
              ])),
          ];
      },
      footer: (pw.Context context) {
        return pw.Container(
          color: PdfColor.fromHex('#FFBD59'),
          child: footerPDF(formattedDate));
      }
    ),
  );

  Navigator.push(
    context, 
    MaterialPageRoute(
      builder: (context) => PreviewScreen(doc: doc),
    )
  );
}

pw.Header headerPDF() {
  return pw.Header(
    margin: pw.EdgeInsets.zero,
    outlineColor: PdfColors.amber50,
    outlineStyle: PdfOutlineStyle.normal,
    level: 5,
    decoration: pw.BoxDecoration(
      shape: pw.BoxShape.rectangle,
      gradient: pw.LinearGradient(
        colors: [
          PdfColor.fromHex('#FCDF8A'),
          PdfColor.fromHex('#F38381'),
        ],
        begin: pw.Alignment.topLeft,
        end: pw.Alignment.bottomRight,
      ),
    ),
    child: pw.Center(
      child: pw.Text(
        '-Pembayaran Pembelian Pelajaran-',
        style: pw.TextStyle (
          fontWeight: pw.FontWeight.bold,
          fontSize: 12.sp,
        )
      )
    )
  );
}

pw.Padding imageFromInput
(
  pw.ImageProvider Function(Uint8List imageBytes) pdfImageProvider,
  Uint8List imageBytes
) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
    child: pw.FittedBox(
      child: 
          pw.Image(pdfImageProvider(imageBytes), width: 33.h),
          fit: pw.BoxFit.fitHeight,
          alignment: pw.Alignment.center,
    )
  );
}

pw.Padding personalDataFromInput(TextEditingController nameController, TextEditingController phoneController,
TextEditingController addressController){
  return pw.Padding(
    padding: 
      pw.EdgeInsets.symmetric(horizontal: 5.h, vertical: 1.h),
    child: pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 1.h, vertical: 1.h
              ),
              child: pw.Text(
                'Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 1.h, vertical: 1.h
              ),
              child: pw.Text(
                nameController.text,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                )
              )
            )
          ]
        ),

        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 1.h, vertical: 1.h
              ),
              child: pw.Text(
                'Phone Number',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 1.h, vertical: 1.h
              ),
              child: pw.Text(
                phoneController.text,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                )
              )
            )
          ]
        ),

        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 1.h, vertical: 1.h
              ),
              child: pw.Text(
                'Address',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 1.h, vertical: 1.h
              ),
              child: pw.Text(
                addressController.text,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10.sp,
                )
              )
            )
          ]
        ),
      ]
    )
  );
}

pw.Padding topOfInvoice(pw.MemoryImage imageInvoice) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Image(imageInvoice, height: 30.h, width: 30.w),
        pw.Expanded(child: 
          pw.Container(
            height: 10.h,
            decoration: const pw.BoxDecoration(borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),color: PdfColors.amberAccent),
            padding: const pw.EdgeInsets.only(left: 40, top: 10, bottom: 10, right: 40),
            alignment: pw.Alignment.centerLeft,
            child: 
              pw.DefaultTextStyle(
                style: const pw.TextStyle(color: PdfColors.amber100, fontSize: 12),
                child: pw.GridView(
                  crossAxisCount: 2,
                  children: [
                    pw.Text('Awesome Product',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                    pw.Text('Anggrek Street 12',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                    pw.SizedBox(height: 1.h),
                    pw.Text('Jakarta 5111',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                    pw.SizedBox(height: 1.h),
                    pw.SizedBox(height: 1.h),
                    pw.Text('Jakarta 5111',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                    pw.SizedBox(height: 1.h),
                    pw.SizedBox(height: 1.h),
                    pw.Text('Contact Us',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                    pw.SizedBox(height: 1.h),
                    pw.Text('Phone Number',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                    pw.Text('0812345678',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                    pw.Text('Email',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                    pw.Text('awesomeproduct@gmail.com',
                            style: pw.TextStyle( fontSize: 10.sp, color: PdfColors.blue)),
                  ]
                )
              )
          )
        )
      ]
    )
  );
}

pw.Padding contentOfInvoice(pw.Widget table) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Column(children: [
      pw.Text("Dear Customer, thank you for buying our product, we hope the products can make your day."),
      pw.SizedBox(height: 3.h),
      table,
      pw.Text("Thanks for your trust, and till the next time."),
      pw.SizedBox(height: 3.h),
      pw.Text("Kind regards,"),
      pw.SizedBox(height: 3.h),
      pw.Text("1081"),
    ])
  );
}

pw.Padding barcodeKotak(String id) {
  return pw.Padding(
    padding: 
      pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
    child: pw.Center(
      child: 
          pw.BarcodeWidget(
        barcode: pw.Barcode.qrCode(
          errorCorrectLevel: BarcodeQRCorrectionLevel.high,
        ),
        data: id,
        width: 15.w,
        height: 15.h,
      ),
    ),
  );
}

pw.Container barcodeGaris(String id) {
  return pw.Container(
    child: 
      pw.Padding(
        padding: pw.EdgeInsets.symmetric(
          horizontal: 1.h, vertical: 1
        ),
        child: pw.BarcodeWidget(
          barcode: Barcode.code128(escapes: true),
          data: id,
          width: 10.w,
          height: 5.h,
        )
      )
  );
}

pw.Center footerPDF(String formattedDate) =>
  pw.Center(child: pw.Text('Created At $formattedDate', style: pw.TextStyle( fontSize: 10.sp, color:
  PdfColors.blue)));