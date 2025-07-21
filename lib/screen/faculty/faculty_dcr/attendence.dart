import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_dcr/raw_data.dart';
import 'package:lbef/screen/faculty/faculty_dcr/widgets/attedence_card.dart';
import 'package:lbef/screen/faculty/faculty_dcr/widgets/attendenceCardHead.dart';
import 'package:lbef/screen/faculty/faculty_dcr/widgets/custom_search.dart';
import '../../../resource/colors.dart';
import '../../../widgets/form_widget/modern_btn_widget.dart';

class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  List<int?> selectedStatusIndices = List<int?>.filled(students.length, null);
  List<bool> showRemarksList = List<bool>.filled(students.length, false);
  List<TextEditingController> remarksControllers = [];
  final TextEditingController _searchController = TextEditingController();

  int presentCount = 0;
  int absentCount = 0;
  int lateCount = 0;
  int leaveCount = 0;

  @override
  void initState() {
    super.initState();
    remarksControllers = List.generate(
      students.length,
          (index) => TextEditingController(),
    );
  }

  void updateStats() {
    presentCount = selectedStatusIndices.where((status) => status == 0).length;
    leaveCount = selectedStatusIndices.where((status) => status == 1).length;
    lateCount = selectedStatusIndices.where((status) => status == 2).length;
    absentCount = selectedStatusIndices.where((status) => status == 3).length;
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var controller in remarksControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(fontFamily: 'poppins'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/pcpsLogo.png'),
            width: 70,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ModernButton(
                  icon: const Icon(Icons.check_circle_outline, size: 14),
                  text: "All Present",
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      selectedStatusIndices = List<int?>.filled(students.length, 0);
                      updateStats();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ModernButton(
                  icon: const Icon(Icons.cancel_outlined, size: 14),
                  text: "All Absent",
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      selectedStatusIndices = List<int?>.filled(students.length, 3);
                      updateStats();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ModernButton(
                  icon: const Icon(Icons.check, size: 14),
                  text: "Submit",
                  color: AppColors.primary,
                  onPressed: () {
                    for (int i = 0; i < students.length; i++) {
                      print(
                          'Student: ${students[i]['name']}, Status: ${selectedStatusIndices[i]}, Remarks: ${remarksControllers[i].text}');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const AttendenceCardHead(
              className: '2502 - Bsc. CSSE CIS013-RMET',
              image: "assets/images/mountain.jpg",
              classDate: "2025-01-15",
              time: "12:00AM - 2:00PM",
              subject: "",
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildCompactStat("Total Students", "40",Colors.blue ),
                      buildCompactStat("Present", presentCount.toString(), Colors.green),
                      buildCompactStat("Absent", absentCount.toString(), Colors.red),
                      buildCompactStat("Late", lateCount.toString(), Colors.orange),
                      buildCompactStat("Leave", leaveCount.toString(), Colors.purple),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomSearch(
              controller: _searchController,
              hintText: 'Search Students',
              outlinedColor: Colors.transparent,
              focusedColor: AppColors.primary,
              height: 50,
              width: double.infinity,
              onChanged: (value) {},
              onTap: () {},
              onReset: () {},
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return StudentAttendanceCard(
                      index: index,
                      selectedStatus: selectedStatusIndices[index],
                      onStatusChanged: (status) {
                        setState(() {
                          selectedStatusIndices[index] = status;
                          updateStats();
                        });
                      },
                      showRemarks: showRemarksList[index],
                      onToggleRemarks: () {
                        setState(() {
                          showRemarksList[index] = !showRemarksList[index];
                        });
                      },
                      remarksController: remarksControllers[index],
                    );
                  },
                ),
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
}
