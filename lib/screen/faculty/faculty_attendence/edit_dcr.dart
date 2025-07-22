import 'package:flutter/material.dart';
import 'package:lbef/screen/faculty/faculty_attendence/raw_data.dart';
import 'package:lbef/screen/faculty/faculty_attendence/widgets/attedence_card.dart';
import 'package:lbef/screen/faculty/faculty_attendence/widgets/custom_search.dart';

import '../../../resource/colors.dart';
import '../../../widgets/form_widget/custom_label_textfield.dart';
import '../../../widgets/form_widget/modern_btn_widget.dart';
import 'edit_dcr_widget/edit_dcr_widget.dart';

class EditDcr extends StatefulWidget {
  const EditDcr({super.key});

  @override
  State<EditDcr> createState() => _EditDcrState();
}

class _EditDcrState extends State<EditDcr> {
  final TextEditingController _taught = TextEditingController();
  final TextEditingController _assignment = TextEditingController();
  final TextEditingController _activity = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  int selectedTabIndex = 0;

  List<int?> selectedStatusIndices = [];
  List<bool> showRemarksList = [];
  List<TextEditingController?> remarksControllersList = [];

  int totalPresent = 0;
  int totalAbsent = 0;
  int totalLate = 0;
  int totalLeave = 0;

  @override
  void initState() {
    super.initState();
    selectedStatusIndices = List<int?>.filled(students.length, null);
    showRemarksList = List<bool>.filled(students.length, false);
    remarksControllersList = List<TextEditingController?>.filled(students.length, null);
  }

  TextEditingController getOrCreateController(int index) {
    remarksControllersList[index] ??= TextEditingController();
    return remarksControllersList[index]!;
  }

  void updateStats() {
    int present = 0;
    int absent = 0;
    int late = 0;
    int leave = 0;

    for (var status in selectedStatusIndices) {
      switch (status) {
        case 0:
          present++;
          break;
        case 1:
          absent++;
          break;
        case 2:
          late++;
          break;
        case 3:
          leave++;
          break;
      }
    }

    setState(() {
      totalPresent = present;
      totalAbsent = absent;
      totalLate = late;
      totalLeave = leave;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit DCR", style: TextStyle(fontFamily: 'poppins')),
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
      bottomNavigationBar: buildBottomButtons(),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            const EditDcrHead(
              shift: 'Morning',
              mode: 'Full Class Mode',
              roomno: 'A-204',
              section: 'A',
              teacher: 'Nujan Shrestha',
              image: "assets/images/mountain.jpg",
              className: '2502 - Bsc. CSSE CIS013-RMET',
              classDate: "2025-01-15",
              time: "12:00AM - 2:00PM",
            ),
            const SizedBox(height: 10),
            // Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildTabButton("Information", 0),
                  _buildTabButton("Attendance", 1),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Content
            Expanded(
              child: selectedTabIndex == 0 ? buildFormTab(size) : buildAttendanceTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedTabIndex = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontFamily: 'poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormTab(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomLabelTextfield(
            textController: _taught,
            hintText: "Taught in Class",
            text: "Taught in Class",
            outlinedColor: Colors.grey,
            focusedColor: AppColors.primary,
            width: size.width,
          ),
          const SizedBox(height: 10),
          CustomLabelTextfield(
            textController: _activity,
            hintText: "Activity in Class",
            text: "Activity in Class",
            outlinedColor: Colors.grey,
            focusedColor: AppColors.primary,
            width: size.width,
          ),
          const SizedBox(height: 10),
          CustomLabelTextfield(
            textController: _assignment,
            hintText: "Assignment Given in Class",
            text: "Assignment Given in Class",
            outlinedColor: Colors.grey,
            focusedColor: AppColors.primary,
            width: size.width,
          ),
        ],
      ),
    );
  }

  Widget buildAttendanceTab() {
    return Column(
      children: [
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
                buildCompactStat("Present", totalPresent.toString(), Colors.green),
                buildCompactStat("Absent", totalAbsent.toString(), Colors.red),
                buildCompactStat("Late", totalLate.toString(), Colors.orange),
                buildCompactStat("Leave", totalLeave.toString(), Colors.purple),
              ],
            ),
          ),
        ),
        CustomSearch(
          controller: _searchController,
          hintText: 'Search Students',
          outlinedColor: Colors.transparent,
          focusedColor: AppColors.primary,
          height: 50,
          width: double.infinity,
          onChanged: (value) {},
          onTap: () {},
          onReset: () {
            _searchController.clear();
          },
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemExtent: 100,
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

  Widget buildBottomButtons() {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ModernButton(
                icon: const Icon(Icons.check, size: 14),
                text: "Submit",
                color: AppColors.primary,
                onPressed: () {
                  // Handle submission
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
