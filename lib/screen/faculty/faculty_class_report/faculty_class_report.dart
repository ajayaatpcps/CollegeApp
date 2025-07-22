import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_class_report/widgets/class_card.dart';
import 'package:lbef/screen/student/daily_class_report/widgets/class_card.dart';

class FacultyClassReport extends StatefulWidget {
  const FacultyClassReport({super.key});

  @override
  State<FacultyClassReport> createState() => _FacultyClassReportState();
}

class _FacultyClassReportState extends State<FacultyClassReport> {
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
            width: 56,
            height: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 14),
        ],
      ),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              FacultyClassCard(
                text: "OBJECT ORIENTED PROGRAMMING AND SOFTWARE ENGINEERING",
                code: 'CIS-0756465',
                faculty: 'Nujan Shrestha',
                session: 'PCPS Spring',
                section: 'A',
                semester: 'L6 SEM II',
              ),
              SizedBox(
                height: 14,
              ),
              FacultyClassCard(
                text: "OBJECT ORIENTED PROGRAMMING AND SOFTWARE ENGINEERING",
                code: 'CIS-0756465',
                faculty: 'Nujan Shrestha',
                session: 'PCPS Spring',
                section: 'A',
                semester: 'L6 SEM II',
              ),
              SizedBox(
                height: 14,
              ),
              FacultyClassCard(
                text: "OBJECT ORIENTED PROGRAMMING AND SOFTWARE ENGINEERING",
                code: 'CIS-0756465',
                faculty: '',
                session: '',
                section: '',
                semester: '',
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
