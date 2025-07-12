import 'package:flutter/material.dart';
import 'package:lbef/screen/student/daily_class_report/reports/reports.dart';
import 'package:lbef/screen/student/daily_class_report/shimmer/class_card_shimmer.dart';
import 'package:lbef/view_model/daily_class_report/dcr_view_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:lbef/screen/student/daily_class_report/widgets/class_card.dart';
import '../../../utils/navigate_to.dart';
import '../../../widgets/no_data/no_data_widget.dart';

class DailyClassReport extends StatefulWidget {
  const DailyClassReport({super.key});

  @override
  State<DailyClassReport> createState() => _DailyClassReportState();
}

class _DailyClassReportState extends State<DailyClassReport> {
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  void fetch() async {
    await Provider.of<DcrViewModel>(context, listen: false).fetch(context);
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
      body: SafeArea(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Consumer<DcrViewModel>(
            builder: (context, viewModel, child) {
              final dcrList = viewModel.dcrList ?? [];

              if (viewModel.isLoading) {
                return ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: ClassCardShimmer(),
                  ),
                );
              }

              if (dcrList.isEmpty) {
                return BuildNoData(
                  size,
                  'No class reports available',
                  Icons.disabled_visible_rounded,
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: dcrList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final report = dcrList[index];
                  return InkWell(
                    onTap: () {
                      _logger.d('Navigating to Reports with report: $report');
                      Navigator.of(context).push(
                        SlideRightRoute(
                          page: Reports(
                            subjectId: report.subjectId?.toString() ?? '',
                            uid: report.facultyId?.toString() ?? '',
                            image: 'assets/images/mountain.jpg',
                            facultyName: report.facultyName ?? '',
                            code: report.subjectCode ?? '',
                            section: report.sectionId ?? '',
                            subject: report.subjectName ?? '',
                            session: report.sessionName ?? '',
                          ),
                        ),
                      );
                    },
                    child: ClassCard(
                      text: report.subjectName ?? '',
                      code: report.subjectCode ?? '',
                      faculty: report.facultyName ?? '',
                      session: report.sessionName ?? '',
                      section: report.sectionId ?? '',
                      semester: report.semesterName ?? '',
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
