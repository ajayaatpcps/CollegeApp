import 'package:flutter/material.dart';
import 'package:lbef/utils/utils.dart';
import 'package:lbef/view_model/application_files/application_view_model.dart';
import 'package:lbef/widgets/dropdown/leave_dropdown.dart';
import 'package:lbef/widgets/form_widget/custom_button.dart';
import 'package:lbef/widgets/form_widget/custom_textarea.dart';
import 'package:provider/provider.dart';
import '../../../resource/colors.dart';
import '../../../view_model/theme_provider.dart';
import '../../../widgets/form_widget/btn/outlned_btn.dart';

class EditApplication extends StatefulWidget {
  final String applicationType, id;
  final String startDate;
  final String endDate;
  final String reason;

  const EditApplication({
    super.key,
    required this.applicationType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.id,
  });

  @override
  State<EditApplication> createState() => _EditApplicationState();
}

class _EditApplicationState extends State<EditApplication> {
  final TextEditingController reasonController = TextEditingController();
  String? applicationType;
  DateTime? startDate;
  DateTime? endDate;
  String error = '';

  @override
  void initState() {
    super.initState();
    applicationType = widget.applicationType;
    reasonController.text = widget.reason;

    try {
      if (widget.startDate.isNotEmpty && widget.startDate != "0000-00-00") {
        startDate = DateTime.parse(widget.startDate);
      }
    } catch (_) {}

    try {
      if (widget.endDate.isNotEmpty && widget.endDate != "0000-00-00") {
        endDate = DateTime.parse(widget.endDate);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

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

  Future<bool?> showUpdateConfirmationDialog(BuildContext context) async {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text('Update Application'),
          ],
        ),
        content: const Text(
          'Are you sure you want to update this application?',
          style: TextStyle(fontSize: 16),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          CustomOutlineButton(
            onPressed: () => Navigator.of(context).pop(false),
            labelText: 'Cancel',
            width: size.width * 0.2,
            height: size.height * 0.05,
            buttonColor: Colors.red,
            textColor: Colors.red,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Application",
            style: TextStyle(fontFamily: 'poppins')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Image(
              image: AssetImage('assets/images/lbef.png'),
              width: 70,
              height: 50),
          SizedBox(width: 14),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeaveDropdown(
              label: 'Application Type',
              wid: size.width,
              initialValue: applicationType,
              onChanged: (value) => setState(() => applicationType = value),
            ),
            const SizedBox(height: 10),

            // Start Date
            const Text("Start Date",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Note: Please select the date when your leave begins',
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  borderRadius: BorderRadius.circular(4)),
              child: ListTile(
                title: Text(startDate != null
                    ? formatDate(startDate)
                    : 'Select when your leave starts'),
                trailing: const Icon(Icons.calendar_month),
                onTap: () => pickStartDate(context),
              ),
            ),

            const SizedBox(height: 10),

            // End Date
            const Text("End Date",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
                'Note: Please select the date when your leave ends (optional)',
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  borderRadius: BorderRadius.circular(4)),
              child: ListTile(
                title: Text(endDate != null
                    ? formatDate(endDate)
                    : 'Select when your leave ends'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => pickEndDate(context),
              ),
            ),

            const SizedBox(height: 10),

            // Reason
            CustomTextArea(
              hintText: 'Enter reason',
              outlinedColor: Colors.black,
              focusedColor: AppColors.primary,
              width: size.width,
              label: 'Reason',
              textController: reasonController,
            ),

            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(error,
                    style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Update',
              isLoading: false,
              onPressed: () async {
                final reason = reasonController.text.trim();
                final start = formatDate(startDate);
                final end = formatDate(endDate);

                if (applicationType == null) {
                  setState(() => error = "Select an application type");
                  Utils.flushBarErrorMessage(
                      "Select an application type", context);
                  return;
                }
                if (start.isEmpty) {
                  setState(() => error = "Start date required");
                  Utils.flushBarErrorMessage("Start date required", context);
                  return;
                }
                if (reason.isEmpty) {
                  setState(() => error = "Reason cannot be empty");
                  Utils.flushBarErrorMessage("Reason cannot be empty", context);
                  return;
                }

                final confirmUpdate =
                    await showUpdateConfirmationDialog(context);
                if (confirmUpdate != true || !context.mounted) return;

                final payload = {
                  "application_id": widget.id,
                  "app_start_date": start,
                  "app_end_date": end.isEmpty ? "0000-00-00" : end,
                  "application_type": applicationType,
                  "application_request": reason,
                };

                final success = await Provider.of<ApplicationViewModel>(context,
                        listen: false)
                    .updateApplication(payload, context);

                if (success) {
                  await Provider.of<ApplicationViewModel>(context,
                          listen: false)
                      .fetch(context);
                  await Provider.of<ApplicationViewModel>(context,
                          listen: false)
                      .getApplicationDetails(widget.id, context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
