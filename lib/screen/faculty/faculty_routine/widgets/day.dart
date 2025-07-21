import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_routine/widgets/faculty_table_data.dart';
import 'package:lbef/screen/student/class_routines/widgets/table_row.dart';

class Sunday extends StatelessWidget {
  const Sunday({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 80,
              child: Center(
                child: Text(
                  "Time",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Courses",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        FacultyTableData(
            timeStart: '7:00 AM',
            timeEnd: '9:00 AM',
            title: 'OBJECT ORIENTED PROGRAMMING AND ',
            lecture: 'Lecture 2 : Data Management Sql',
            room: "Room 3 404",
            teacher: 'Nujan Shrestha',
            color: Color(0xff97E793),
            textColor: Colors.black),
        SizedBox(height: 15),
        FacultyTableData(
            timeStart: '10:00 AM',
            timeEnd: '12:00 AM',
            title: 'Mobile Application Development',
            lecture: 'Lecture 2 : Flutter',
            room: "Room 01 204",
            teacher: 'Season Maharjan',
            color: Color(0xffDCFF7D),
            textColor: Color(0xffE32D2D)),
      ],
    );
  }
}
