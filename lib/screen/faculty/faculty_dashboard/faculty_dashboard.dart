import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/faculty/faculty_dashboard/widgets/faculty_dashboard_head.dart';
import 'package:lbef/view_model/notice_board/notice_board_view_model.dart';
import 'package:provider/provider.dart';
import '../faculty_routine/widgets/faculty_table_data.dart';

class FacultyDashboard extends StatefulWidget {
  const FacultyDashboard({super.key});

  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  void fetch() async {
    await Provider.of<NoticeBoardViewModel>(context, listen: false)
        .fetch(context);
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const FacultyDashboardHead(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Todays Classes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "View All",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  FacultyTableData(
                    timeStart: '7:00',
                    timeEnd: '9:00',
                    title:
                        'OBJECT ORIENTED PROGRAMMING AND MOBILE APP DEVELOPMENT',
                    lecture: 'Lecture 2 : Data Management Sql',
                    room: "Room 3 404",
                    teacher: 'Nujan Shrestha',
                    textColor: Colors.black,
                    schedule: 'Morning',
                  ),
                  SizedBox(height: 10),
                  FacultyTableData(
                    timeStart: '10:00',
                    timeEnd: '12:00',
                    title: 'Mobile Application Development',
                    lecture: 'Lecture 2 : Flutter',
                    room: "Room 01 204",
                    teacher: 'Season Maharjan',
                    textColor: Colors.black,
                    schedule: 'Morning',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
