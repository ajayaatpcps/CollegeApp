import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../resource/colors.dart';

class AdmitCard extends StatelessWidget {
  const AdmitCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Routines",
            style: TextStyle(fontFamily: 'poppins')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/lbef.png'),
            width: 70,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        label: const Text('Export PDF', style: TextStyle(color: Colors.white)),
        onPressed: () => _exportAsPdfPreview(context),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/new.jpg'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'PATAN COLLEGE FOR PROFESSIONAL STUDIES',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Behind Kandevtasthan, Kupondole, Lalitpur, Nepal',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey[600]),
                      ),
                      const Divider(height: 24, thickness: 1.2),
                      Text(
                        'University End Term Examination - Dec 2024',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _infoRow('Name', 'Pratik Tamang'),
                _infoRow('Course', 'BSc CSSE'),
                _infoRow('Intake', 'Autumn 2024'),
                _infoRow('Candidate ID', '2214130'),
                _infoRow(
                    'Exam Center', 'PCPS College, Kupondole, Lalitpur, Nepal'),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                Text('Exam Details',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _detailRow('Subject',
                          'Object Oriented Programming & Software Engineering'),
                      _detailRow('Code', 'CIS016-2'),
                      _detailRow('Type', 'Regular'),
                      _detailRow('Date', '2024-12-18 1:45 PM'),
                      _detailRow('Room', '407'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Instructions',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...[
                  'Valid admit card & college ID',
                  'Arrive 30 min early',
                  'Use BLACK/BLUE pen only',
                  'Mobile phones not allowed',
                  'No borrowing stationery',
                  'Strict action for malpractice',
                  'Disqualification for unfair means',
                ].map(_instructionBullet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text('$label:',
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _instructionBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _exportAsPdfPreview(BuildContext context) async {
    final pdf = pw.Document();

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/new.jpg')).buffer.asUint8List(),
    );
    final pcpsLogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/lbef.png')).buffer.asUint8List(),
    );
    final bedfordLogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/lbef.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Image(pcpsLogo, width: 80, height: 60),
                    pw.Column(
                      children: [
                        pw.Text('PATAN COLLEGE FOR PROFESSIONAL STUDIES',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            'Behind Kandevtasthan, Kupondole, Lalitpur, Nepal',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                    pw.Image(bedfordLogo, width: 80, height: 60),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                    'Admit Card For University End Term Examination - Dec 2024',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text('Ref No: 67565b107063e-2302112085-20241217085933',
                    style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 12),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Column(
                        children: [
                          _pdfInfoRow('Exam Year-Month', '2024-12'),
                          _pdfInfoRow('Student Name', 'Pratik Tamang'),
                          _pdfInfoRow('Course', 'BSc CSSE'),
                          _pdfInfoRow('Intake Code', 'Autumn 2024'),
                          _pdfInfoRow('Candidate ID', '2214130'),
                          _pdfInfoRow('Exam Center',
                              'PCPS College, Kupondole, Lalitpur, Nepal'),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Image(profileImage, width: 80, height: 80),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Text('Your BREO Password: ********',
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: [
                    'S.No',
                    'Code',
                    'Subject Name',
                    'Exam Type',
                    'Exam Date',
                    'Room No'
                  ],
                  data: [
                    [
                      '1',
                      'CIS016-2',
                      'Object Oriented Programming and Software Engineering',
                      'Regular',
                      '2024-12-18 1:45 PM',
                      '407'
                    ],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.grey300),
                  border: pw.TableBorder.all(color: PdfColors.grey),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                    'Important Instructions for the Examination [Please read carefully]',
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...[
                  'No one is allowed to enter the examination hall/presentation hall without valid admit card / College ID Card.',
                  'You cannot enter the examination hall/presentation hall after the commencement of exam.',
                  'Come at least 30 minutes early. Gates close after the exam starts.',
                  'You cannot leave until 60 minutes have passed.',
                  'Use only BLACK or BLUE pen.',
                  'Mobile phones are not allowed.',
                  'Possession of mobile phone (even off) = MALPRACTICE.',
                  'No arrangements to keep mobile phones at center.',
                  'Bring only non-programmable calculator.',
                  'No borrowing of stationery.',
                  'Unfair means lead to disqualification.',
                  'Campus management’s decision is final.',
                ].map(_pdfBullet),
                pw.SizedBox(height: 20),
                pw.Text('Best of Luck!',
                    style: pw.TextStyle(color: PdfColors.green800)),
              ],
            ),
          );
        },
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Admit Card PDF Preview")),
          body: PdfPreview(build: (format) => pdf.save()),
        ),
      ),
    );
  }

  pw.Widget _pdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
              flex: 2,
              child: pw.Text('$label:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10))),
          pw.Expanded(
              flex: 3,
              child: pw.Text(value, style: const pw.TextStyle(fontSize: 10))),
        ],
      ),
    );
  }

  pw.Widget _pdfBullet(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('- ', style: const pw.TextStyle(fontSize: 10)),
          pw.Expanded(
              child: pw.Text(text, style: const pw.TextStyle(fontSize: 10))),
        ],
      ),
    );
  }
}
