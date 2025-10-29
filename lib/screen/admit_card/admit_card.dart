import 'package:flutter/material.dart';
import 'package:lbef/constant/base_url.dart';
import 'package:lbef/data/status.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:lbef/view_model/user_view_model/current_user_model.dart';
import 'package:lbef/widgets/custom_shimmer.dart';
import 'package:lbef/widgets/no_data/no_data_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:lbef/model/admit_card_model.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/view_model/user_view_model/admit_card_view_model.dart';

class AdmitCardScreen extends StatefulWidget {
  const AdmitCardScreen({super.key});

  @override
  State<AdmitCardScreen> createState() => _AdmitCardScreenState();
}

class _AdmitCardScreenState extends State<AdmitCardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AdmitCardViewModel>(context, listen: false)
          .getAdmitCard(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final admitVM = Provider.of<AdmitCardViewModel>(context);
    final data = admitVM.userData.data;
    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Admit Card", style: TextStyle(fontFamily: 'poppins')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
        ),
      ),
      body: SafeArea(
        child: Builder(builder: (context) {
          if (admitVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (admitVM.userData.status == Status.ERROR) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100,
                    child: BuildNoData(
                        MediaQuery.of(context).size,
                        admitVM.userData.message ?? "No Data Available",
                        Icons.do_not_disturb_alt)),
              ],
            );
          }

          if (data == null) {
            return const Center(
              child: Text(
                "Admit Card not available.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const Divider(thickness: 1),
                    _buildExamTitle(data),
                    const SizedBox(height: 10),
                    _buildStudentInfo(data),
                    const SizedBox(height: 20),
                    _buildSubjects(data.subjects ?? []),
                    const SizedBox(height: 24),
                    _buildInstructions(data.instructions ?? ""),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/lbef.png', height: 40),
            Image.asset('assets/images/apu.PNG', height: 60),
          ],
        ),
      ],
    );
  }

  // ===== EXAM TITLE =====
  Widget _buildExamTitle(AdmitCardModel data) {
    return Center(
      child: Text(
        "${data.examName}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  // ===== STUDENT INFO =====
  Widget _buildStudentInfo(AdmitCardModel data) {
    final venue = (data.venue ?? "").trim().isEmpty
        ? "Lord Buddha Education Foundation"
        : data.venue!;

    return Consumer<UserDataViewModel>(
      builder: (context, userDataViewModel, child) {
        final user = userDataViewModel.currentUser;

        String? image =
            "${BaseUrl.imageDisplay}/html/profiles/students/${user?.stuProfilePath}/${user?.stuPhoto}";
        var logger = Logger();
        logger.d(image);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Student Name", data.studentName ?? "", bold: true),
                  _infoRow("Student Roll No", user?.stuRollNo ?? "N/A"),
                  _infoRow("University Roll No", data.stuUnivRollNo ?? "N/A"),
                  _infoRow("Course", data.courseShortName ?? ""),
                  _infoRow("Semester", data.semesterName ?? ""),
                  _infoRow(
                      "Exam Start Date",
                      data.examStart != null
                          ? parseDate(data.examStart.toString())
                          : "Enquire with RTO Department"),
                  _infoRow("Venue", venue),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  width: 90,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CustomShimmerLoading(
                        width: 90,
                        height: 100,
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 90,
                    height: 100,
                    color: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.school,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  // ===== SUBJECTS =====
  Widget _buildSubjects(List<Subjects> subjects) {
    if (subjects.isEmpty) {
      return const Text(
        "No subjects found.",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Exam Schedule",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...subjects.map((sub) {
          String examDate = "TBA";
          String examTime = "TBA";

          switch (sub.examType?.toLowerCase()) {
            case "regular":
              examDate = sub.regularDate ?? "TBA";
              examTime = sub.regularTime ?? "TBA";
              break;
            case "retake":
            case "resit":
              examDate = sub.retakeDate ?? "TBA";
              examTime = sub.retakeTime ?? "TBA";
              break;
            case "referral":
              examDate = sub.referralDate ?? "TBA";
              examTime = sub.referralTime ?? "TBA";
              break;
            default:
              examDate = sub.regularDate ?? "TBA";
              examTime = sub.regularTime ?? "TBA";
              break;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${sub.subjectCode} - ${sub.subjectName}",
                  style: const TextStyle(fontSize:14,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                _detailRow("Exam Type", sub.examType ?? ""),
                _detailRow(
                  "Date",
                  (examDate.isNotEmpty && examDate.toLowerCase() != "tba")
                      ? parseDate(examDate)
                      : "TBA",
                ),
                _detailRow("Time", examTime),
                _detailRow("Room", sub.examRoom ?? ""),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text("$label:",
                style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(flex: 3, child: Text(value)),
      ],
    );
  }

  // ===== INSTRUCTIONS =====
  Widget _buildInstructions(String instructions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Important Instructions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          padding: const EdgeInsets.all(12),
          child: Text(
            (instructions.isEmpty)
                ? "No instructions provided."
                : instructions.trim(),
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            "Best of Luck!",
            style: TextStyle(
              color: Colors.green,
              fontStyle: FontStyle.italic,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}