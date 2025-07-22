import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_routine/widgets/faculty_table_data.dart';
import 'package:lbef/screen/student/class_routines/widgets/table_row.dart';

class Sunday extends StatelessWidget {
  const Sunday({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FacultyTableData(
          timeStart: '7:00',
          timeEnd: '9:00',
          title: 'OBJECT ORIENTED PROGRAMMING AND ',
          lecture: 'Lecture 2 : Data Management Sql',
          room: "Room 3 404",
          teacher: 'Nujan Shrestha',
          textColor: Colors.black,
          schedule: 'Morning',
        ),
        SizedBox(height: 15),
        FacultyTableData(
            timeStart: '10:00',
            timeEnd: '12:00',
            title: 'Mobile Application Development',
            lecture: 'Lecture 2 : Flutter',
            room: "Room 01 204",
            teacher: 'Season Maharjan',
            textColor: Colors.black,
            schedule: 'Morning'),
      ],
    );
  }
}
