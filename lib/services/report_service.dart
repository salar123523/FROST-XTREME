import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/device_data.dart';

class ReportService {
  Future<void> generatePDF(DeviceData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'FROST XTREME - گزارش عملکرد',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#00D4FF'),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text('داده\u200cهای دستگاه:'),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex('#333333')),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    _buildRow('دمای آب', '${data.waterTemp.toStringAsFixed(1)}°C'),
                    _buildRow('دمای محیط', '${data.ambientTemp.toStringAsFixed(1)}°C'),
                    _buildRow('رطوبت', '${data.humidity.toStringAsFixed(0)}%'),
                    _buildRow('دبی آب', '${data.flowRate.toStringAsFixed(1)} L/min'),
                    _buildRow('کمپرسور', data.compressorOn ? 'روشن' : 'خاموش'),
                    _buildRow('پمپ آب', data.pumpOn ? 'روشن' : 'خاموش'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'بازدهی: ${DeviceDataHelper.calculateEfficiency(data).toInt()}%',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#00D4FF'),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'تاریخ: ${DateTime.now().toString()}',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColor.fromHex('#808080'),
                ),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'گزارش FROST XTREME',
    );
  }

  pw.Row _buildRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 14)),
        pw.Text(value,
            style:
                const pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
}
