import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cltvspj/models/report_model.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generatePdfReport(ReportData data) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

  final robotoRegular = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
  );
  final robotoBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
  );

  final baseStyle = pw.TextStyle(font: robotoRegular, fontSize: 12);
  final boldStyle = pw.TextStyle(font: robotoBold, fontSize: 12);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              data.title,
              style: pw.TextStyle(font: robotoBold, fontSize: 24),
            ),

            pw.SizedBox(height: 20),

            pw.Text('${data.labels.namePrefix} ${data.name}', style: baseStyle),

            pw.SizedBox(height: 6),

            pw.Text(
              '${data.labels.professionPrefix} ${data.profession}',
              style: baseStyle,
            ),

            pw.SizedBox(height: 10),

            pw.SizedBox(height: 10),

            pw.TableHelper.fromTextArray(
              headerStyle: boldStyle,
              cellStyle: baseStyle,
              headers: data.labels.tableHeaders,
              data: data.summaryRows
                  .map((row) => [row.label, row.value])
                  .toList(),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              data.labels.benefitsTitle,
              style: boldStyle.copyWith(fontSize: 14),
            ),

            pw.SizedBox(height: 6),

            ...data.benefitsRows.map(
              (e) => pw.Text('• ${e.label}: ${e.value}', style: baseStyle),
            ),

            if (data.chartBytes != null) ...[
              pw.SizedBox(height: 30),
              pw.Text(
                data.labels.chartTitle,
                style: pw.TextStyle(font: robotoBold, fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Image(pw.MemoryImage(data.chartBytes!)),
            ],
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
