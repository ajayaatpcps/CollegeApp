import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_class_report/faculty_report/stacked_faculty_report.dart';
import 'package:lbef/screen/student/daily_class_report/widgets/attendence_bar.dart';
import 'package:lbef/screen/student/daily_class_report/widgets/individual_card_head.dart';

import '../../../../resource/colors.dart';
import '../../../student/daily_class_report/reports/stacked_reports.dart';

class FacultyReport extends StatefulWidget {
  const FacultyReport({super.key});
  @override
  State<FacultyReport> createState() => _FacultyReportState();
}

class _FacultyReportState extends State<FacultyReport> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Report",
          style: TextStyle(fontFamily: 'poppins', fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/lbef.png'),
            width: 56,
            height: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 14),
        ],
      ),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const IndividualCardHead(
                image: 'assets/images/mountain.jpg',
                tutor: "Nujan Shrestha",
                subject: 'OBJECT ORIENTED PROGRAMMING AND SOFTWARE ENGINEERING',
                code: 'CIS6FGV8',
                session: '',
                section: '',
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'View FacultyReport from the last 30 classes.',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 15,
              ),
              const StackedFacultyReport(
                date: '',
                time: '',
                room: '',
                roomNo: '',
                taught: '',
                taughtInClass: '',
                assignmentInClass: '',
                assignment: '',
                activity: '',
                task: '',
                attendenceScore: '',
                attendence: '',
                teacher: '',
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
