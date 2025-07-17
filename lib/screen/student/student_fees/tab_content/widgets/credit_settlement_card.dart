import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/theme_provider.dart';

class CreditSettlementCard extends StatelessWidget {
  final String date;
  final String cNoteNo;
  final String fiscal;

  final String type;
  final String amount;

  const CreditSettlementCard({
    super.key,
    required this.date,
    required this.amount,
    required this.cNoteNo,
    required this.type,
    required this.fiscal,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildDetailRow('Date', date, context,
            valueColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow('Note Number', "$fiscal/$cNoteNo", context,
            valueColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow('Settlement Type', type, context,
            valueColor: Colors.green.shade700),
        const SizedBox(height: 12),
        _buildDetailRow('Amount', amount, context,
            valueColor: Colors.green.shade700),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context,
      {Color? valueColor}) {
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
              fontWeight: FontWeight.w700,
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
