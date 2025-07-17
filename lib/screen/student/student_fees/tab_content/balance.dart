import 'package:flutter/material.dart';
import 'package:lbef/model/fee_model.dart';
import 'package:lbef/screen/student/student_fees/pay_khalti.dart';
import 'package:lbef/screen/student/student_fees/tab_content/widgets/balance_card.dart';
import 'package:lbef/screen/student/student_fees/tab_content/widgets/buildCreditSettlement.dart';
import 'package:lbef/screen/student/student_fees/tab_content/widgets/credit_notes.dart';
import 'package:lbef/widgets/no_data/no_data_widget.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/theme_provider.dart';

class Balance extends StatefulWidget {
  final List<CreditNotes>? credit;
  final List<CreditSettlementModel>? refund;
  final List<Dues>? dues;

  const Balance({super.key, this.credit, this.refund, this.dues});

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  Map<String, double> calculateTotals() {
    double totalDueNPR = 0.0;
    double totalPaidNPR = 0.0;
    double totalDueGBP = 0.0;
    double totalPaidGBP = 0.0;

    if (widget.dues != null) {
      for (var due in widget.dues!) {
        double amount = double.tryParse(due.amount ?? '0.0') ?? 0.0;
        double amountPaid = double.tryParse(due.amountPaid ?? '0.0') ?? 0.0;

        if (due.currency == 'NPR') {
          totalDueNPR += amount;
          totalPaidNPR += amountPaid;
        } else if (due.currency == 'GBP') {
          totalDueGBP += amount;
          totalPaidGBP += amountPaid;
        }
      }
    }

    return {
      'totalDueNPR': totalDueNPR,
      'totalPaidNPR': totalPaidNPR,
      'totalDueGBP': totalDueGBP,
      'totalPaidGBP': totalPaidGBP,
      'balanceNPR': totalDueNPR - totalPaidNPR,
      'balanceGBP': totalDueGBP - totalPaidGBP,
    };
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final totals = calculateTotals();
    final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            'Your Balance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: buildBalanceCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Total Due',
                  amountRs: 'Rs. ${totals['totalDueNPR']!.toStringAsFixed(0)}',
                  amountPound: '£ ${totals['totalDueGBP']!.toStringAsFixed(0)}',
                  color: Colors.red[100], context: context,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: buildBalanceCard(
                  icon: Icons.payment,
                  context: context,
                  title: 'Total Paid',
                  amountRs: 'Rs. ${totals['totalPaidNPR']!.toStringAsFixed(0)}',
                  amountPound: '£ ${totals['totalPaidGBP']!.toStringAsFixed(0)}',
                  color: Colors.green[100],
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: buildBalanceCard(
                  icon: Icons.account_balance,
                  context: context,
                  title: 'Balance',
                  amountRs: 'Rs. ${totals['balanceNPR']!.toStringAsFixed(0)}',
                  amountPound: '£ ${totals['balanceGBP']!.toStringAsFixed(0)}',
                  color: Colors.blue[100],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Your Credit Notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (widget.credit == null || widget.credit!.isEmpty) ...[
            BuildNoData(
                size, "No credit notes available!", Icons.do_not_disturb)
          ] else ...[
            buildCreditNotesSection(widget.credit ?? [], context),
          ],
          const SizedBox(height: 20),
          const Text(
            'Your Credit Settlements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (widget.refund == null || widget.refund!.isEmpty) ...[
            BuildNoData(
                size, "No credit settlement available!", Icons.do_not_disturb)
          ] else ...[
            buildCreditSettlement(widget.refund ?? [], context),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}