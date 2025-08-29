import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_attendence/raw_data.dart';
import 'package:lbef/screen/faculty/faculty_attendence/widgets/attedence_card.dart';
import 'package:lbef/screen/faculty/faculty_attendence/widgets/attendenceCardHead.dart';
import 'package:lbef/screen/faculty/faculty_attendence/widgets/custom_search.dart';
import '../../../resource/colors.dart';
import '../../../widgets/form_widget/modern_btn_widget.dart';

class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  List<int?> selectedStatusIndices = [];
  List<bool> showRemarksList = [];
  List<TextEditingController?> remarksControllers = [];
  final TextEditingController _searchController = TextEditingController();

  int presentCount = 0;
  int absentCount = 0;
  int lateCount = 0;
  int leaveCount = 0;

  @override
  void initState() {
    super.initState();
    // Direct initialization instead of post-frame
    selectedStatusIndices = List<int?>.filled(students.length, null);
    showRemarksList = List<bool>.filled(students.length, false);
    remarksControllers = List<TextEditingController?>.filled(students.length, null);
  }

  void updateStats() {
    presentCount = selectedStatusIndices.where((status) => status == 0).length;
    leaveCount = selectedStatusIndices.where((status) => status == 1).length;
    lateCount = selectedStatusIndices.where((status) => status == 2).length;
    absentCount = selectedStatusIndices.where((status) => status == 3).length;
    setState(() {}); // Direct call is safe here
  }

  TextEditingController getOrCreateController(int index) {
    if (index >= remarksControllers.length) {
      remarksControllers.addAll(
        List.generate(index - remarksControllers.length + 1, (_) => null),
      );
    }
    if (remarksControllers[index] == null) {
      remarksControllers[index] = TextEditingController();
    }
    return remarksControllers[index]!;
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var controller in remarksControllers.where((c) => c != null)) {
      controller!.dispose();
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
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              bool isSmall = width < 400; // breakpoint for smaller devices
              double btnWidth = isSmall ? width * 0.28 : width * 0.3;
              double fontSize = isSmall ? 12 : 14;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: btnWidth,
                    child: ModernButton(
                      text: "All Present",
                      color: Colors.green,
                      fontSize: fontSize,
                      onPressed: () {
                        setState(() {
                          selectedStatusIndices =
                          List<int?>.filled(students.length, 0);
                          updateStats();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: btnWidth,
                    child: ModernButton(
                      text: "All Absent",
                      color: Colors.red,
                      fontSize: fontSize,
                      onPressed: () {
                        setState(() {
                          selectedStatusIndices =
                          List<int?>.filled(students.length, 3);
                          updateStats();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: btnWidth,
                    child: ModernButton(
                      text: "Submit",
                      color: AppColors.primary,
                      fontSize: fontSize,
                      onPressed: () {
                        for (int i = 0; i < students.length; i++) {
                          print(
                              'Student: ${students[i]['name']}, Status: ${selectedStatusIndices[i]}, Remarks: ${remarksControllers[i]?.text ?? ''}');
                        }
                      },
                    ),
                  ),
                ],
              );
            },
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
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    buildCompactStat("Total", students.length.toString(), Colors.blue),
                    buildCompactStat("Present", presentCount.toString(), Colors.green),
                    buildCompactStat("Absent", absentCount.toString(), Colors.red),
                    buildCompactStat("Late", lateCount.toString(), Colors.orange),
                    buildCompactStat("Leave", leaveCount.toString(), Colors.purple),
                  ],
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
              child: students.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                cacheExtent: 1000,
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return StudentAttendanceCard(
                    key: ValueKey(students[index]['id']),
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
                        if (showRemarksList[index]) {
                          getOrCreateController(index);
                        }
                      });
                    },
                    remarksController: getOrCreateController(index),
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
}
