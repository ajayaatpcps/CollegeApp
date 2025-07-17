import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/fee_model.dart';
import '../../../../../utils/parse_date.dart';
import '../../../../../view_model/theme_provider.dart';

class StatementCard extends StatelessWidget {
  final Dues note;
  final int index;
  final VoidCallback onTap;

  const StatementCard({
    super.key,
    required this.note,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 300 + (index * 100)),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode?Colors.black: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SN: $index',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: note.status == 'paid'
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: note.status == 'paid'
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          note.status == 'paid' ? 'Paid' : 'Unpaid',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: note.status == 'paid'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${note.particular} ${note.description}" ?? '',
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:themeProvider.isDarkMode? Colors.white: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    parseDate(note.paymentDate.toString()) ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn(
                          'Debit',
                          "${note.currencySymbol == "&#163;" ? decodeHtmlCurrencySymbol(note.currencySymbol ?? '') : note.currencySymbol} ${note.amount != null ? double.parse(note.amount ?? '').toInt() : "N/A"}" ??
                              '',context),
                      _buildInfoColumn(
                          'Credit',
                          "${note.currencySymbol == "&#163;" ? decodeHtmlCurrencySymbol(note.currencySymbol ?? '') : note.currencySymbol} ${note.amountPaid != null ? double.parse(note.amountPaid ?? '').toInt() : "N/A"}" ??
                              '',context),
                      _buildInfoColumn(
                          'Balance',
                          "${note.currencySymbol == "&#163;" ? decodeHtmlCurrencySymbol(note.currencySymbol ?? '') : note.currencySymbol} ${note.amount != null ? double.parse(note.amount ?? '0').toInt() - double.parse(note.amountPaid ?? '0').toInt() : "N/A"}" ??
                              '' ??
                              '',context),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Remarks: ${note.remarks ?? ''} ${note.creditRemarks ?? ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Tap to view details!!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value,BuildContext context) {
    final themeProvider=  Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style:  TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color:themeProvider.isDarkMode? Colors.white: Colors.black87,
          ),
        ),
      ],
    );
  }
}
