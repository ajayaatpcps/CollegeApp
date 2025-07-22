import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_class_report/faculty_report/faculty_report.dart';
import 'package:lbef/screen/faculty/faculty_class_report/widgets/class_card.dart';
import 'package:lbef/screen/student/daily_class_report/reports/reports.dart';
import 'package:lbef/screen/student/daily_class_report/shimmer/class_card_shimmer.dart';
import 'package:lbef/view_model/daily_class_report/dcr_view_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lbef/screen/student/daily_class_report/widgets/class_card.dart';

import '../../../utils/navigate_to.dart';

class FacultyClassReport extends StatefulWidget {
  const FacultyClassReport({super.key});

  @override
  State<FacultyClassReport> createState() => _FacultyClassReportState();
}

class _FacultyClassReportState extends State<FacultyClassReport> {





  bool _isLoading = true;
  List<Map<String, String>> classReports = [];

  @override
  void initState() {
    super.initState();
    // fetch();
    _loadDummyData();
  }

  void _loadDummyData() async {
    classReports = [
      {
        'image': 'assets/images/mountain.jpg',
        'subject': 'OBJECT ORIENTED PROGRAMMING AND SOFTWARE ENGINEERING',
        'code': 'CIS-0756465',
        'section': 'C',
        'facultyName': 'Krishna Aryal',
      },
      {
        'image': 'assets/images/sunburn.jpg',
        'subject': 'DATA COMMUNICATION AND NETWORKING',
        'code': 'CIS-0756466',
        'section': 'C',
        'facultyName': 'Nujan Shrestha',
      },
      {
        'image': 'assets/images/content.png',
        'subject': 'WEB TECHNOLOGIES',
        'section': 'C',
        'code': 'CIS-0756467',
        'facultyName': 'Season Maharjan',
      },
      {
        'image': 'assets/images/content.png',
        'subject': 'WEB TECHNOLOGIES',
        'section': 'C',
        'code': 'CIS-0756467',
        'facultyName': 'Tara GC',
      },
    ];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Daily Class Reports",
          style: TextStyle(fontFamily: 'poppins', fontSize: 18),
        ),
        automaticallyImplyLeading: false,
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
      body: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: _isLoading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 14),
                  child: ClassCardShimmer(),
                ),
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: classReports.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final report = classReports[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        SlideRightRoute(
                            page: FacultyReport(
                                uid: "",
                                image: report['image']!,
                                facultyName: report['facultyName']!,
                                code: report['code']!,
                                section: report['section']!,
                                subject: report['subject']!,)),
                      );
                    },
                    child: FacultyClassCard(
                      text: report['subject']!,
                      code: report['code']!,
                      faculty: 'Nujan Shrestha',
                      session: 'PCPS SPRING',
                      section: 'A',
                      semester: 'second',
                    ),
                  );
                },
              ),
      ),
    );
  }
}
