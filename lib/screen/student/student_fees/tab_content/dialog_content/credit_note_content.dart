import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/theme_provider.dart';

class CreditNoteContent extends StatelessWidget {
  final String date;
  final String noteNo;
  final String description;
  final String amount;
  final String status;

  const CreditNoteContent({
    super.key,
    required this.date,
    required this.noteNo,
    required this.description,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildDetailRow('Date', date,context,valueColor: themeProvider.isDarkMode?Colors.white:Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow('Note Number', noteNo,context,valueColor: themeProvider.isDarkMode?Colors.white:Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow('Amount', amount,context, valueColor: Colors.green.shade700),
        const SizedBox(height: 12),
        _buildDetailRow('Status', status,context, valueColor: Colors.green.shade700),
        const SizedBox(height: 12),
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Text(
           description ?? '',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value,BuildContext context, {Color? valueColor}) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: themeProvider.isDarkMode
                  ? Colors.white
                  : Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
