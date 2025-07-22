import 'package:flutter/material.dart';

import '../../../../utils/format_time.dart';

class TableData extends StatelessWidget {
  final String timeStart, timeEnd, title, lecture, room, teacher;
  final Color color, textColor;
  const TableData(
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
                    const SizedBox(height: 20),
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
                            Row(
                              children: [
                                Icon(Icons.person, size: 18, color: textColor),
                                const SizedBox(width: 5),
                                Text(teacher, style: TextStyle(fontSize: 13, color: textColor)),
                              ],
                            ),
                          ],
                        ),
                         Icon(Icons.notification_add, size: 26,color: textColor,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
