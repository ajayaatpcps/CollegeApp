import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lbef/model/fee_model.dart';
import 'package:lbef/screen/student/student_fees/tab_content/dialog_content/statement_dialog.dart';
import 'package:lbef/screen/student/student_fees/tab_content/widgets/statement_card.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/theme_provider.dart';
import '../../../../widgets/display_dialog/display_dialog.dart';
import '../../../../widgets/no_data/no_data_widget.dart';

class Statements extends StatefulWidget {
  final List<Dues>? dues;
  const Statements({super.key, required this.dues});

  @override
  State<Statements> createState() => _StatementsState();
}

class _StatementsState extends State<Statements> {



  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Your Statement',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode?Colors.white: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.dues == null || widget.dues!.isEmpty) ...[
            SizedBox(
              height: 100,
              child: BuildNoData(
                  size, "No statements available!", Icons.do_not_disturb),
            )
          ] else ...[
            Expanded(
              child: ScrollConfiguration(
                behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  itemCount: widget.dues!.length ,
                  itemBuilder: (context, index) {
                    final duesData=widget.dues![index];
                    return StatementCard(
                      note: duesData,
                      index: index+1,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => DisplayDialog(
                            text: 'Statement Details',
                            show: StatementDetailsContent(
                              note:duesData,
                              serialNumber:index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}



