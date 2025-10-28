import 'package:flutter/material.dart';
import 'package:lbef/screen/student/student_fees/tab_content/balance.dart';
import 'package:lbef/screen/student/student_fees/tab_content/fees_skeleton.dart';
import 'package:lbef/screen/student/student_fees/tab_content/payment_method.dart';
import 'package:lbef/screen/student/student_fees/tab_content/receipts.dart';
import 'package:lbef/screen/student/student_fees/tab_content/statements.dart';
import 'package:lbef/view_model/college_fees/college_fee_view_model.dart';
import 'package:lbef/widgets/no_data/no_data_widget.dart';
import 'package:provider/provider.dart';
import '../../../view_model/theme_provider.dart';
class StudentFees extends StatefulWidget {
  const StudentFees({super.key});

  @override
  State<StudentFees> createState() => _StudentFeesState();
}

class _StudentFeesState extends State<StudentFees> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  fetch() async {
    await Provider.of<CollegeFeeViewModel>(context, listen: false)
        .fetch(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "College Fees",
            style: TextStyle(
              fontFamily: 'poppins',
            ),
          ),
          actions: const [
            Image(
              image: AssetImage('assets/images/pcpsLogo.png'),
              width: 70,
              height: 50,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 14),
          ],
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: Colors.blue,
            indicatorColor: Colors.blue,
            labelStyle: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'poppins'), // optional
            tabs: [
              Tab(text: 'Statement'),
              Tab(text: 'Balance'),
              Tab(text: 'Receipts'),
              Tab(text: 'Pay Now'),
            ],
          ),


        ),
        body: Consumer<CollegeFeeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const StatementsShimmer();
            }
            if (viewModel.currentDetails == null) {
              return TabBarView(
                children: [
                  SizedBox(
                    height: 100,
                    child: BuildNoData(size, "No settlements available!",
                        Icons.do_not_disturb),
                  ),
                  SizedBox(
                    height: 100,
                    child: BuildNoData(
                        size, "No balance available!", Icons.do_not_disturb),
                  ),
                  SizedBox(
                    height: 100,
                    child: BuildNoData(
                        size, "No receipts available!", Icons.do_not_disturb),
                  ),
                ],
              );
            }
            return TabBarView(
              children: [
                Statements(dues: viewModel.currentDetails?.dues ?? []),
                Balance(
                  dues: viewModel.currentDetails?.dues ?? [],
                  credit: viewModel.currentDetails?.creditNotes ?? [],
                  refund: viewModel.currentDetails?.creditNotesRefund ?? [],
                ),
                ReceiptsPage(
                    receipts: viewModel.currentDetails?.receipts ?? []),
                const PaymentMethod()
              ],
            );
          },
        ),
      ),
    );
  }
}
