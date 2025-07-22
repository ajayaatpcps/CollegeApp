import 'package:flutter/material.dart';
import '../../../../resource/colors.dart';
import '../raw_data.dart';
import 'custom_remark.dart';

class StudentAttendanceCard extends StatelessWidget {
  final int index;
  final int? selectedStatus;
  final Function(int) onStatusChanged;
  final bool showRemarks;
  final VoidCallback onToggleRemarks;
  final TextEditingController remarksController;

  const StudentAttendanceCard({
    super.key,
    required this.index,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.showRemarks,
    required this.onToggleRemarks,
    required this.remarksController,
  });

  Color getBannerColor(int? statusIndex) {
    switch (statusIndex) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 25,
                  height: 50,
                  decoration: BoxDecoration(
                    color: getBannerColor(selectedStatus),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child: Image.network(
                                students[index]['image'] ?? 'https://via.placeholder.com/40',
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.person, color: Colors.grey),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 40,
                                  height: 40,
                                  color: AppColors.primary,
                                  child: const Icon(Icons.school, color: Colors.white, size: 24),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                students[index]['name']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                students[index]['id']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_bubble, color: AppColors.primary),
                        onPressed: onToggleRemarks,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatusButton("Present", 0, Colors.blue),
                  buildStatusButton("Leave", 1, Colors.green),
                  buildStatusButton("Late", 2, Colors.yellow[700]!),
                  buildStatusButton("Absent", 3, Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AnimatedOpacity(
              opacity: showRemarks ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: showRemarks
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomRemarksField(
                  hintText: "Enter remarks",
                  height: 50,
                  width: size.width,
                  borderColor: Colors.grey,
                  focusedColor: Colors.blue,
                  controller: remarksController,
                  onChanged: (val) {},
                  onTap: () {},
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusButton(String title, int statusIndex, Color activeColor) {
    final bool isSelected = selectedStatus == statusIndex;

    IconData getIcon(String status) {
      switch (status) {
        case "Present":
          return Icons.check_circle_outline;
        case "Leave":
          return Icons.beach_access;
        case "Late":
          return Icons.access_time;
        case "Absent":
          return Icons.cancel_outlined;
        default:
          return Icons.help_outline;
      }
    }

    return InkWell(
      onTap: () => onStatusChanged(statusIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: activeColor, width: 1.0),
        ),
        child: Row(
          children: [
            Icon(
              getIcon(title),
              color: isSelected ? Colors.white : activeColor,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : activeColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}