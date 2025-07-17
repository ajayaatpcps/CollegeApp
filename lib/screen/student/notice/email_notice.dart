import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:lbef/utils/format_time.dart';
import 'package:provider/provider.dart';

import '../../../view_model/theme_provider.dart';

class EmailWidget extends StatelessWidget {
  final String subject;
  final String sentOn;
  final String mailToName;
  final String mailFromName;

  const EmailWidget({
    super.key,
    required this.subject,
    required this.sentOn,
    required this.mailToName,
    required this.mailFromName,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Split sentOn into date and time
    String date = 'N/A';
    String time = 'N/A';
    if (sentOn.isNotEmpty && sentOn.contains(' ')) {
      final parts = sentOn.split(' ');
      date = parseDate(parts[0]);
      time = formatTimeTo12Hour(parts[1]);
    }

    return
      Consumer<ThemeProvider>(builder: (context, provider, child) {
      return  Container(
        width: size.width,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: provider.isDarkMode?Colors.black:Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.email_outlined, size: 30, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject
                  Text(
                    subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Sent Date & Time
                  Text(
                    "Date: $date    Time: $time",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // From Name only
                  Text(
                    "From: $mailFromName",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      );});

  }
}