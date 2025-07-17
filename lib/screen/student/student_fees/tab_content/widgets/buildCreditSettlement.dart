import 'package:flutter/material.dart';
import 'package:lbef/model/fee_model.dart';
import 'package:lbef/screen/student/student_fees/tab_content/widgets/credit_settlement_card.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/theme_provider.dart';
import '../../../../../widgets/display_dialog/display_dialog.dart';
import '../../../../../widgets/no_data/no_data_widget.dart';

Widget buildCreditSettlement(List<CreditSettlementModel>? note, BuildContext context) {
  final size = MediaQuery.of(context).size;
  final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

  return Column(
    children: note!.map((note) {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DisplayDialog(
              text: 'Credit Note Details',
              show: CreditSettlementCard(
                date: parseDate(note.settlementDate.toString()),
                cNoteNo: note.creditNoteNo.toString(),
                amount: "Rs. ${note.amount}" ?? '',
                fiscal: note.fiscalYearName??'',
                type: note.settleType??'',
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
                Text(parseDate(note.settlementDate.toString()),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('${note.fiscalYearName}/${note.creditNoteNo.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Text("Settlement Type : ${note.settleType}"),
                const SizedBox(height: 8),
                Text("Rs. ${ double.parse(note.amount ?? '0').toInt()}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
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
