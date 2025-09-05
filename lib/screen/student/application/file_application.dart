import 'package:flutter/material.dart';
import 'package:lbef/utils/utils.dart';
import 'package:lbef/view_model/application_files/application_view_model.dart';
import 'package:lbef/widgets/dropdown/leave_dropdown.dart';
import 'package:lbef/widgets/form_widget/custom_button.dart';
import 'package:lbef/widgets/form_widget/custom_textarea.dart';
import 'package:provider/provider.dart';
import '../../../resource/colors.dart';

class FileApplication extends StatefulWidget {
  const FileApplication({super.key});

  @override
  State<FileApplication> createState() => _FileApplicationState();
}

class _FileApplicationState extends State<FileApplication> {
  final TextEditingController reasonController = TextEditingController();
  String? applicationType;
  DateTime? startDate;
  DateTime? endDate;
  String error = '';

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("File Application",
            style: TextStyle(fontFamily: 'poppins')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
        ),
        actions: const [
          Image(
              image: AssetImage('assets/images/pcpsLogo.png'),
              width: 70,
              height: 50),
          SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeaveDropdown(
                label: 'Application Type',
                wid: size.width,
                onChanged: (value) => setState(() => applicationType = value),
              ),
              const SizedBox(height: 10),
              const Text(
                "Start Date",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Start Date
              const SizedBox(height: 4),
              const Text(
                'Note: Please select the date when your leave begins',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ListTile(
                  title: Text(startDate != null
                      ? formatDate(startDate)
                      : 'Select when your leave starts'),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () => pickStartDate(context),
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "End Date",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              // End Date
              const SizedBox(height: 4),
              const Text(
                'Note: Please select the date when your leave ends (optional)',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ListTile(
                  title: Text(endDate != null
                      ? formatDate(endDate)
                      : 'Select when your leave ends'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => pickEndDate(context),
                ),
              ),
              const SizedBox(height: 4),

              CustomTextArea(
                hintText: 'Enter reason',
                outlinedColor: Colors.black,
                focusedColor: AppColors.primary,
                width: size.width,
                label: 'Reason',
                textController: reasonController,
              ),
              const SizedBox(height: 10),

              if (error.isNotEmpty)
                Text(error,
                    style: const TextStyle(color: Colors.red, fontSize: 12)),

              const SizedBox(height: 20),
              CustomButton(
                text: 'Submit',
                isLoading: false,
                onPressed: () async {
                  final reason = reasonController.text.trim();
                  final start = formatDate(startDate);
                  final end = formatDate(endDate);

                  if (applicationType == null) {
                    Utils.flushBarErrorMessage(
                        "Select an application type", context);
                    return;
                  }
                  if (start.isEmpty) {
                    Utils.flushBarErrorMessage("Start date required", context);
                    return;
                  }

                  if (reason.isEmpty) {
                    Utils.flushBarErrorMessage(
                        "Reason cannot be empty", context);
                    return;
                  }

                  final payload = {
                    "app_start_date": start,
                    "app_end_date": end.isEmpty ? "0000-00-00" : end,
                    "application_type": applicationType,
                    "application_request": reason,
                  };

                  final check = await Provider.of<ApplicationViewModel>(context,
                          listen: false)
                      .createApplication(payload, context);
                  if (check) {
                    await Provider.of<ApplicationViewModel>(context,
                            listen: false)
                        .fetch(context);
                    reasonController.text = '';
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
