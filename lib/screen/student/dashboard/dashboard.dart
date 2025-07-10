import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/navbar/student_navbar.dart';
import 'package:lbef/screen/student/dashboard/widgets/dashboard_head.dart';
import 'package:lbef/screen/student/notice/notice.dart';
import 'package:lbef/view_model/notice_board/notice_board_view_model.dart';
import 'package:provider/provider.dart';

import '../../../utils/navigate_to.dart';
import '../../../widgets/no_data/no_data_widget.dart';
import '../application/widgets/application_shimmer.dart';
import '../notice/view_notice_board.dart';
import '../notice/widgets/notice_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
            const DashboardHead(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Events',
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: BuildNoData(
                  size,
                  "No upcoming events at the moment. Stay tuned for future updates!",
                  Icons.event_busy),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Latest Notices',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            SlideRightRoute(
                              page: const NoticeBoard(),
                            ),
                          );
                        },
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
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<NoticeBoardViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.only(bottom: 14),
                            child: ApplicationShimmer(),
                          ),
                        );
                      }

                      final notices = viewModel.notices;

                      if (notices == null || notices.isEmpty) {
                        return BuildNoData(
                          size,
                          'No notices available',
                          Icons.disabled_visible_rounded,
                        );
                      }

                      final displayedNotices =
                      notices.length > 3 ? notices.take(3).toList() : notices;

                      return Wrap(
                        spacing: 0,
                        runSpacing: 14,
                        children: displayedNotices.map((application) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                SlideRightRoute(
                                  page: ViewNoticeBoard(noticeData: application),
                                ),
                              );
                            },
                            child: NoticeWidget(
                              published: application.noticeDate ?? '',
                              body: application.subject ?? '',
                              subBody: application.subject ?? '',
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
