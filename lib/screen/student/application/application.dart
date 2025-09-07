import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/student/application/file_application.dart';
import 'package:lbef/screen/student/application/widgets/application_shimmer.dart';
import 'package:lbef/screen/student/application/widgets/view_application.dart';
import 'package:lbef/screen/student/application/widgets/application_widget.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:lbef/view_model/application_files/application_view_model.dart';
import 'package:lbef/widgets/no_data/no_data_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../../utils/navigate_to.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  var logger = Logger();

  void fetch() async {
    await Provider.of<ApplicationViewModel>(context, listen: false)
        .fetch(context);
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Applications",
          style: TextStyle(fontFamily: 'poppins', fontSize: 20),
        ),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                SlideRightRoute(page: const FileApplication()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                children: [
                  const Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.add_box_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Consumer<ApplicationViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: ApplicationShimmer(),
                  ),
                );
              }
              if (viewModel.applications!.isEmpty) {
                return BuildNoData(
                    size, 'No data available', Icons.disabled_visible_rounded);
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: viewModel.applications!.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final application = viewModel.applications![index];
                  Color getIconColor(String status) {
                    switch (status) {
                      case 'approved':
                        return Colors.blue;
                      case 'rejected':
                        return Colors.red;
                      case 'new':
                      default:
                        return Colors.green;
                    }
                  }

                  final startDate = application.appStartDate != null
                      ? parseDate(application.appStartDate.toString())
                      : "";
                  final endDate = application.appEndDate != null
                      ? parseDate(application.appEndDate.toString())
                      : "";
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        SlideRightRoute(
                          page: ViewApplicationPage(
                            applicationData: application,
                          ),
                        ),
                      );
                    },
                    child: ApplicationWidget(
                      iconColor:
                          getIconColor(application.applicationStatus ?? ''),
                      textColor: Colors.white,
                      btnColor:
                          getIconColor(application.applicationStatus ?? ''),
                      status: application.applicationStatus ?? '',
                      title: application.applicationType ?? '',
                      subBody: startDate,
                      endDate: endDate,
                      appdate: application.applicationDate != null
                          ? parseDate(application.applicationDate.toString())
                          : "",
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
