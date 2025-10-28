import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/student/notice/skeleton/email_shimmer.dart';
import 'package:lbef/screen/student/notice/skeleton/notice_skeleton.dart';
import 'package:lbef/screen/student/notice/view_email_notice.dart';
import 'package:lbef/screen/student/notice/view_notice_board.dart';
import 'package:lbef/screen/student/notice/widgets/notice_widget.dart';
import 'package:lbef/screen/student/notice/widgets/sms_widget.dart';
import 'package:lbef/view_model/notice_board/email_view_model.dart';
import 'package:lbef/view_model/notice_board/notice_board_view_model.dart';
import 'package:lbef/view_model/notice_board/sms_view_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../../utils/navigate_to.dart';
import 'email_notice.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({super.key});

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard>
    with SingleTickerProviderStateMixin {
  var logger = Logger();
  late TabController _tabController;

  void fetch() async {
    await Provider.of<NoticeBoardViewModel>(context, listen: false)
        .fetch(context);
    await Provider.of<EmailViewModel>(context, listen: false).fetch(context);
    await Provider.of<SmsViewModel>(context, listen: false).fetch(context);
  }

  @override
  void initState() {
    super.initState();
    fetch();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notices",
          style: TextStyle(fontFamily: 'poppins', fontSize: 20),
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
            width: 70,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Notices"),
            Tab(text: "SMS"),
            Tab(text: "Emails"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /// Tab 1: Notices
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Consumer<NoticeBoardViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: NoticeShimmer(),
                    ),
                  );
                }
                if (viewModel.notices!.isEmpty) {
                  return const Center(
                    child: Text("No notices available."),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.notices!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final notices = viewModel.notices![index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          SlideRightRoute(
                            page: ViewNoticeBoard(noticeData: notices),
                          ),
                        );
                      },
                      child: NoticeWidget(
                        published: notices.noticeDate ?? '',
                        body: notices.subject ?? '',
                        subBody: notices.subject ?? '',
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Consumer<SmsViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: EmailShimmer(),
                    ),
                  );
                }

                if (viewModel.notices == null || viewModel.notices!.isEmpty) {
                  return const Center(
                    child: Text("No Sms available."),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.notices!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final notices = viewModel.notices![index];

                    return SMSWidget(
                      smsMessage: notices.smsMessage ?? '',
                      sentOn: notices.sentOn ?? '',
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Consumer<EmailViewModel>(

              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: EmailShimmer(),
                    ),
                  );
                }

                if (viewModel.notices == null || viewModel.notices!.isEmpty) {
                  return const Center(
                    child: Text("No Email records available."),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.notices!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final notices = viewModel.notices![index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ViewEmail(emailData: notices)));
                      },
                      child: EmailWidget(
                        subject: notices.subject ?? '',
                        sentOn: notices.sentOn.toString() ?? '',
                        mailToName: notices.mailToname ?? '',
                        mailFromName: notices.mailFromname ?? '',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
