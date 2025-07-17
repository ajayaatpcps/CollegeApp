import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/fee_model.dart';
import '../../../../../view_model/theme_provider.dart';

Widget buildReceiptCard(Receipts note, BuildContext context) {
  final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

  return Card(
    color:themeProvider.isDarkMode?Colors.black: Colors.white,
    margin: const EdgeInsets.only(bottom: 10),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.receiptDate??'', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text("${note.fiscalYearName}/${note.receiptNo.toString()}"??'', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Amount: Rs. ${ double.parse(note.totalAmount ?? '0').toInt()}", style: const TextStyle(fontSize: 14)),
              Text("Tax: Rs. ${ double.parse(note.taxAmount ?? '0').toInt()}", style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    ),
  );
}