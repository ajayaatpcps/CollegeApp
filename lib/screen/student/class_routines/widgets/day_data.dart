import 'package:flutter/material.dart';
import 'package:lbef/model/routine_model.dart';
import 'package:lbef/screen/student/class_routines/widgets/no_class_routine.dart';
import 'package:lbef/widgets/no_data/no_data_widget.dart';
import 'table_row.dart';

class DayDetails extends StatelessWidget {
  final String day;
  final List<Times> times;
  final List<DayItem> days;
  final Map<String, dynamic> detail;

  const DayDetails({
    super.key,
    required this.day,
    required this.times,
    required this.days,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // If this day doesn't exist in the list
    if (!days.any((dayItem) => dayItem.day == day)) {
      return BuildNoData(
        size,
        "No class routine available for this day",
        Icons.calendar_month,
      );
    }

    final dayDetails = detail[day] as Map<String, dynamic>?;

    if (times.isEmpty || dayDetails == null || dayDetails.isEmpty) {
      return _buildNoDataView(
        size,
        day == 'Saturday' ? "No class routine for today!" : "No Routine available",
      );
    }

    return Column(
      children: [
        _buildTableHeader(),
        const SizedBox(height: 20),
        ..._buildRoutineRows(dayDetails),
      ],
    );
  }

  Widget _buildTableHeader() {
    return const Row(
      children: [
        SizedBox(
          width: 80,
          child: Center(
            child: Text(
              "Time",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              "Courses",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoDataView(Size size, String message) {
    return SizedBox(); // Replace with custom no data widget if needed
  }

  List<Widget> _buildRoutineRows(Map<String, dynamic> dayDetails) {
    final nonEmptyEntries = times
        .where((time) {
      final timeKey = "${time.startTime}-${time.endTime}";
      final detailString = dayDetails[timeKey] as String?;
      return detailString != null && detailString.isNotEmpty;
    })
        .toList();

    final List<Color> rowColors = [
      const Color(0xff97E793), // Green
      const Color(0xffE0E0E0), // Light Grey
      const Color(0xffAED9E0), // Light Blue
    ];

    return times.asMap().entries.map((entry) {
      final index = entry.key;
      final time = entry.value;
      final timeKey = "${time.startTime}-${time.endTime}";
      final detailString = dayDetails[timeKey] as String?;

      if (detailString == null || detailString.isEmpty) {
        return const SizedBox();
      }

      final parts = detailString.split('<br>');
      final course = parts.isNotEmpty ? parts[0] : 'Unknown Course';
      final teacher = parts.length > 1 ? parts[1] : 'Unknown Teacher';
      final room = parts.length > 2 ? parts[2] : 'Unknown Room';

      final nonEmptyIndex = nonEmptyEntries.indexOf(time);

      final Color rowColor = nonEmptyEntries.length == 1
          ? rowColors[0] // Just use green if only one
          : rowColors[nonEmptyIndex % rowColors.length]; // Cycle through 3 colors

      return TableData(
        timeStart: time.startTime,
        timeEnd: time.endTime,
        title: course,
        lecture: '',
        room: room,
        teacher: teacher,
        color: rowColor,
        textColor: Colors.black,
      );
    }).toList();
  }
}
