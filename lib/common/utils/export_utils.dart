import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';

class ExportUtils {
  static Future<File> exportToPDF(String title, List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: data.first.keys.toList(),
            data: data.map((row) => row.values.toList()).toList(),
          ),
        ],
      ),
    ));

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/report.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> exportToCSV(String filename, List<Map<String, dynamic>> data) async {
    final csvData = ListToCsvConverter().convert(
      [data.first.keys.toList(), ...data.map((row) => row.values.toList())],
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.csv');
    await file.writeAsString(csvData);
    return file;
  }
}
