import 'package:flutter/material.dart';
import 'package:lbef/model/fee_model.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/theme_provider.dart';

class StatementDetailsContent extends StatelessWidget {
  final Dues note;
  final int serialNumber;

  const StatementDetailsContent({
    super.key,
    required this.note,
    required this.serialNumber,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildDetailRow('Serial Number', serialNumber.toString(), context,
            valueColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow('Particular',
            "${note.particular} ${note.description}" ?? '', context,
            valueColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow(
            'Date', parseDate(note.paymentDate.toString()) ?? '', context,
            valueColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow(
            'Debit',
            "${note.currencySymbol == "&#163;" ? decodeHtmlCurrencySymbol(note.currencySymbol ?? '') : note.currencySymbol} ${note.amount != null ? double.parse(note.amount ?? '').toInt() : "N/A"}" ??
                '',
            context,
            valueColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow(
            'Credit',
            "${note.currencySymbol == "&#163;" ? decodeHtmlCurrencySymbol(note.currencySymbol ?? '') : note.currencySymbol} ${note.amountPaid != null ? double.parse(note.amountPaid ?? '').toInt() : "N/A"}" ??
                '',
            context,
            valueColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow(
            'Balance',
            "${note.currencySymbol == "&#163;" ? decodeHtmlCurrencySymbol(note.currencySymbol ?? '') : note.currencySymbol} ${note.amount != null ? double.parse(note.amount ?? '0').toInt() - double.parse(note.amountPaid ?? '0').toInt() : "N/A"}" ??
                '' ??
                '',
            context,
            valueColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Status',
          note.status == "paid" ? 'Paid' : 'Unpaid',
          context,
          valueColor: note.status == "paid" ? Colors.green : Colors.red,
        ),
        const SizedBox(height: 12),
        Text(
          'Remarks',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
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
            "  ${note.remarks ?? ''} ${note.creditRemarks ?? ''}",
            style: const TextStyle(
                fontSize: 14,
                color: Colors.black87),
          ),
        ),
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
