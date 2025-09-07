import 'package:flutter/material.dart';
import 'package:lbef/model/fee_model.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:provider/provider.dart';

import '../../../../../resource/colors.dart';
import '../../../../../view_model/theme_provider.dart';
import '../../../../../widgets/display_dialog/display_dialog.dart';
import '../../../../../widgets/no_data/no_data_widget.dart';
import '../dialog_content/credit_note_content.dart';

Widget buildCreditNotesSection(List<CreditNotes> note, BuildContext context) {
  final size = MediaQuery.of(context).size;
  final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

  return Column(
    children: note.map((note) {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DisplayDialog(
              text: 'Credit Note Details',
              show: CreditNoteContent(
                date: parseDate(note.issueDate.toString()),
                noteNo: note.creditNoteNo.toString(),
                description: "${note.particular} ",
                amount: "Rs. ${double.parse(note.amount ?? '0').toInt()}" ?? '',
                status: note.status!,
              ),
            ),
          );
        },
        child: Card(
          color:themeProvider.isDarkMode?Colors.black: Colors.white,
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(parseDate(note.issueDate.toString()),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('${note.fiscalYearName}/${note.creditNoteNo.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Text("${note.particular}"),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rs. ${double.parse(note.amount ?? '0').toInt()}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(note.status ?? '',
                          style: const TextStyle(color: Colors.green)),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   Text('Click to view details!!',style: TextStyle(fontSize: 12,
                     fontWeight: FontWeight.bold,
                     color: Colors.blue.shade700,),)
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );
}
