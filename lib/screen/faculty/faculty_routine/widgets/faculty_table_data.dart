import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_dcr/attendence.dart';

import '../../../../resource/colors.dart';
import '../../../../utils/format_time.dart';
import '../../../../utils/navigate_to.dart';

class FacultyTableData extends StatelessWidget {
  final String timeStart, timeEnd, title, lecture, room, teacher;
  final Color color, textColor;
  const FacultyTableData(
      {super.key,
        required this.timeStart,
        required this.timeEnd,
        required this.title,
        required this.lecture,
        required this.room,
        required this.teacher,
        required this.color,
        required this.textColor});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 80,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(timeStart!=''||timeStart!=null?formatTimeTo12HourSimple(timeStart):''),
                  const SizedBox(height: 5),
                  Text(timeStart!=''||timeStart!=null?formatTimeTo12HourSimple(timeEnd):''),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:10,left: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    Text(
                      lecture,
                      style: TextStyle(color: textColor, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 18, color: textColor),
                                const SizedBox(width: 5),
                                Text(room, style: TextStyle(color: textColor, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.person, size: 18, color: textColor),
                                const SizedBox(width: 5),
                                Text(teacher, style: TextStyle(fontSize: 13, color: textColor)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        buildFilterButton('DCR', () {}, AppColors.primary),
                        buildFilterButton('Attendance', () {
                          Navigator.of(context).push(
                            SlideRightRoute(page: const Attendence()),
                          );
                        }, Colors.green),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildFilterButton(String title, VoidCallback onTap, Color color) {
    return Container(
      width: 100, // Set fixed width to ensure both buttons have same width
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: color),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }


}
