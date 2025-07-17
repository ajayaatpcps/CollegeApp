import 'package:flutter/material.dart';
import 'package:lbef/model/fee_model.dart';
import 'package:lbef/screen/student/student_fees/tab_content/widgets/receipt_card.dart';

import '../../../../widgets/no_data/no_data_widget.dart';

class ReceiptsPage extends StatefulWidget {
  final List<Receipts>? receipts;
  const ReceiptsPage({super.key, required this.receipts});

  @override
  State<ReceiptsPage> createState() => _ReceiptsState();
}

class _ReceiptsState extends State<ReceiptsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Receipts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          if (widget.receipts == null || widget.receipts!.isEmpty) ...[
            SizedBox(
              height: 100,
              child: BuildNoData(
                  size, "No receipts available!", Icons.do_not_disturb),
            )
          ] else ...[
            ...widget.receipts!.map((note) => buildReceiptCard(note,context)),
          ]

        ],
      ),
    );
  }
}
