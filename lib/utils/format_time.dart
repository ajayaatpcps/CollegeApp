import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

String formatTimeRange(String start, String end) {
  try {
    final inputFormat = DateFormat("HH:mm"); // Matches "06:30"
    final outputFormat = DateFormat("h:mm a"); // e.g., "6:30 AM"

    final startTime = inputFormat.parse(start);
    final endTime = inputFormat.parse(end);

    return "${outputFormat.format(startTime)} - ${outputFormat.format(endTime)}";
  } catch (e) {
    return 'Invalid time'; // fallback in case of bad input
  }
}

String stripHtmlTags(String htmlText) {
  return htmlText
      .replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<\s*/?\s*p\s*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'&nbsp', caseSensitive: false), '')

      .trim();
}

String formatTimeTo12Hour(String time) {
  try {
    // Split the time string into hours, minutes, seconds
    List<String> parts = time.split(':');
    if (parts.length != 3) {
      return 'Invalid time';
    }

    // Parse hours, minutes, seconds
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // Determine AM/PM
    String period = hours >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    int displayHours = hours % 12;
    displayHours = displayHours == 0 ? 12 : displayHours; // Handle midnight/noon

    // Format with leading zeros
    String formattedTime = '${displayHours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')} $period';

    return formattedTime;
  } catch (e) {
    return 'Invalid time';
  }
}
String formatTimeTo12HourSimple(String time) {
  try {
    List<String> parts = time.split(':');
    if (parts.length != 2) {
      return 'Invalid time';
    }

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    String period = hours >= 12 ? 'PM' : 'AM';

    int displayHours = hours % 12;
    displayHours = displayHours == 0 ? 12 : displayHours;

    return '${displayHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
  } catch (e) {
    return 'Invalid time';
  }
}