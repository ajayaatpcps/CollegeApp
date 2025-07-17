import 'package:flutter/material.dart';
import 'package:lbef/data/status.dart';
import 'package:lbef/model/dcr_detail_model.dart';
import 'package:lbef/screen/student/daily_class_report/reports/stacked_reports.dart';
import 'package:lbef/screen/student/daily_class_report/widgets/attendence_bar.dart';
import 'package:lbef/screen/student/daily_class_report/widgets/individual_card_head.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:lbef/view_model/daily_class_report/dcr_detail_view_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../../../resource/colors.dart';
import '../../../../utils/format_time.dart';
import '../../../../view_model/theme_provider.dart';
import '../../../../widgets/no_data/no_data_widget.dart';
import '../shimmer/class_card_shimmer.dart';
import '../shimmer/report_shimmer.dart';

class Reports extends StatefulWidget {
  final String uid,
      session,
      image,
      subjectId,
      facultyName,
      subject,
      code,
      section;
  const Reports({
    super.key,
    required this.image,
    required this.facultyName,
    required this.code,
    required this.section,
    required this.subject,
    required this.uid,
    required this.subjectId,
    required this.session,
  });

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final Logger _logger = Logger();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  void _fetchInitialData() async {
    final viewModel = Provider.of<DcrDetailViewModel>(context, listen: false);
    await viewModel.fetch(widget.subjectId, widget.uid, context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Report",
          style: TextStyle(fontFamily: 'poppins', fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
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
      ),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IndividualCardHead(
              image: widget.image,
              tutor: widget.facultyName,
              subject: "${widget.code} - ${widget.subject}",
              code: widget.code,
              session: widget.session,
              section: 'section - ${widget.section}',
            ),
            const SizedBox(height: 10),
            Text(
              'View reports from the last 30 classes.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<DcrDetailViewModel>(
                builder: (context, viewModel, child) {
                  final data = viewModel.currentDetails;
                  if (viewModel.isLoading) {
                    return const ReportsShimmer();
                  }
                  if (data == null ||
                      data.classReport == null ||
                      data.classReport!.isEmpty) {
                    return Center(
                      child: BuildNoData(
                        size,
                        'No DCR available! Stay up to date!',
                        Icons.disabled_visible_rounded,
                      ),
                    );
                  }

                  return Column(
                    children: [
                      if (data.attendance != null &&
                          data.attendance!.isNotEmpty)
                        AttendanceBar(
                          percentage: _calculateAttendancePercentage(
                              data.attendance!.first),
                        ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 2,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                buildCompactStat(
                                    "Total Period",
                                    data.attendance!.first.totalPeriod ?? "0",
                                    Colors.blue),
                                buildCompactStat(
                                    "Present",
                                    data.attendance!.first.present ?? "0",
                                    Colors.green),
                                buildCompactStat(
                                    "Absent",
                                    data.attendance!.first.absent ?? "0",
                                    Colors.red),
                                buildCompactStat(
                                    "Late",
                                    data.attendance!.first.late ?? "0",
                                    Colors.orange),
                                buildCompactStat(
                                    "Leave",
                                    data.attendance!.first.leave ?? "0",
                                    Colors.purple),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: data.classReport!.length,
                          itemBuilder: (context, index) {
                            final report = data.classReport![index];
                            if (data.classReport!.isEmpty ||
                                data.classReport == []) {
                              return BuildNoData(
                                  size,
                                  "No DCR Detail available",
                                  Icons.disabled_visible_rounded);
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: StackedReports(
                                teacher: report.facultyName ?? 'N/A',
                                date: report.classDate != null
                                    ? parseDate(report.classDate.toString())
                                    : 'N/A',
                                time: formatTimeRange(report.startTime ?? '',
                                    report.endTime ?? ''),
                                room: 'Room Number',
                                roomNo: report.roomNo?.toString() ?? 'N/A',
                                taught: 'Taught in Class',
                                taughtInClass: report.taughtInClass ?? 'N/A',
                                assignment: 'Assignment',
                                assignmentInClass: report.assignment ?? 'N/A',
                                activity: 'Activity',
                                task: report.classActivity ?? 'N/A',
                                attendence: 'Attendance',
                                attendenceScore:
                                    report.attendanceStatus ?? 'N/A',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCompactStat(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  double _calculateAttendancePercentage(Attendance attendance) {
    try {
      final present = double.parse(attendance.present ?? '0');
      final total = double.parse(attendance.totalPeriod ?? '1');

      if (total == 0) return 0.0;

      final percentage = (present / total) * 100;
      return double.parse(percentage.toStringAsFixed(2));
    } catch (e) {
      _logger.e('Error calculating attendance percentage: $e');
      return 0.0;
    }
  }
}
