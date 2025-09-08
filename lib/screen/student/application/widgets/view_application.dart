import 'package:flutter/material.dart';
import 'package:lbef/model/application_model.dart';
import 'package:lbef/screen/student/application/edit_application.dart';
import 'package:lbef/widgets/form_widget/btn/outlned_btn.dart';
import 'package:lbef/widgets/form_widget/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../../resource/colors.dart';
import '../../../../utils/navigate_to.dart';
import '../../../../utils/utils.dart';
import '../../../../view_model/application_files/application_view_model.dart';
import '../../../../view_model/theme_provider.dart';

class ViewApplicationPage extends StatefulWidget {
  final ApplicationModel applicationData;

  const ViewApplicationPage({super.key, required this.applicationData});

  @override
  State<ViewApplicationPage> createState() => _ViewApplicationPageState();
}

class _ViewApplicationPageState extends State<ViewApplicationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  void fetch() async {
    final id = widget.applicationData.applicationId?.toString();
    if (id == null || id.isEmpty) {
      if (context.mounted) {
        Utils.flushBarErrorMessage("Invalid application ID", context);
      }
      return;
    }
    await Provider.of<ApplicationViewModel>(context, listen: false)
        .getApplicationDetails(id, context);
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
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
            Icon(Icons.delete, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Delete Application'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this application?',
          style: TextStyle(fontSize: 16),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          CustomOutlineButton(
            onPressed: () => Navigator.of(context).pop(false),
            labelText: 'Cancel',
            width: deviceWidth * 0.2,
            height: deviceHeight * 0.05,
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
            child: const Text('Delete'),
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
        title: const Text(
          "Application Details",
          style: TextStyle(fontFamily: 'poppins'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/lbef.png'),
            width: 70,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Consumer<ApplicationViewModel>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                // Show shimmer loading while data is loading
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.currentDetails?.applicationType ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.date_range, "Start Date",
                      provider.currentDetails?.appStartDate ?? '',
                      valueColor: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  _buildDetailRow(Icons.date_range_sharp, "End Date",
                      provider.currentDetails?.appEndDate ?? '',
                      valueColor: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  _buildDetailRow(Icons.label, "Status",
                      provider.currentDetails?.applicationStatus ?? '',
                      valueColor: _getStatusColor(
                          provider.currentDetails?.applicationStatus ?? '')),
                  const Divider(height: 32),
                  const Text(
                    "Application Request",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.currentDetails?.applicationRequest ?? '',
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 15),
                  if (widget.applicationData.applicationStatus == 'new') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: 'Edit',
                          isLoading: false,
                          btnwid: size.width / 2.5,
                          onPressed: () {
                            Navigator.of(context).push(
                              SlideRightRoute(
                                page: EditApplication(
                                  id: provider.currentDetails?.applicationId
                                          .toString() ??
                                      '',
                                  applicationType: provider
                                          .currentDetails?.applicationType ??
                                      '',
                                  startDate:
                                      provider.currentDetails?.appStartDate ??
                                          '',
                                  endDate:
                                      provider.currentDetails?.appEndDate ?? '',
                                  reason: provider
                                          .currentDetails?.applicationRequest ??
                                      '',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Text(
            "$label : ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'new':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
