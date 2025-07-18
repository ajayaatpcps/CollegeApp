import 'package:flutter/material.dart';
import 'package:lbef/screen/student/daily_class_report/widgets/report_detail.dart';


class StackedReports extends StatefulWidget {
  final String date,
      time,
      room,
      roomNo,
      taught,
      taughtInClass,
      assignmentInClass,
      assignment,
      activity,
      task,
  teacher,
      attendenceScore,
      attendence;
  const StackedReports(
      {super.key,
      required this.date,
      required this.time,
      required this.room,
      required this.roomNo,
      required this.taught,
      required this.taughtInClass,
      required this.assignmentInClass,
      required this.assignment,
      required this.activity,
      required this.task,
      required this.attendenceScore,
      required this.attendence, required this.teacher});

  @override
  State<StackedReports> createState() => _StackedReportsState();
}

class _StackedReportsState extends State<StackedReports> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xffEE4432),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.transparent),
              ),
              child: Text(
                widget.date,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        ReportDetail(
            head: widget.room,
            value: widget.roomNo,
            icon: Icons.dashboard_rounded),
        ReportDetail(
            head: widget.taught,
            value: widget.taughtInClass,
            icon: Icons.chrome_reader_mode_outlined),
        if(widget.assignmentInClass!='')...[
          ReportDetail(
              head: widget.assignment,
              value: widget.assignmentInClass,
              icon: Icons.assignment),
        ],
        if(widget.task!='')...[
          ReportDetail(
              head: widget.activity, value: widget.task, icon: Icons.read_more),
        ],
        ReportDetail(
            head: "Taught By",
            value: widget.teacher,
            icon: Icons.school),
        ReportDetail(
            head: widget.attendence,
            value: widget.attendenceScore,
            icon: Icons.check_circle),
      ],
    );
  }
}
