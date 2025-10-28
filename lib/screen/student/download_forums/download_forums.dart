import 'package:flutter/material.dart';
import 'package:lbef/screen/student/daily_class_report/shimmer/class_card_shimmer.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:lbef/view_model/download_forms/download_forms_view_model.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../resource/colors.dart';
import '../../../utils/permission.dart';
import '../../../view_model/theme_provider.dart';
import '../../../widgets/no_data/no_data_widget.dart';

class DownloadForums extends StatefulWidget {
  const DownloadForums({super.key});

  @override
  State<DownloadForums> createState() => _DownloadForumsState();
}

class _DownloadForumsState extends State<DownloadForums> {
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    await Provider.of<DownloadFormsViewModel>(context, listen: false)
        .fetch(context);
  }

  Future<void> downloadFile(String fileName, String fileLink) async {
    bool permissionGranted =
        await PermissionUtils.requestStoragePermission(context);
    if (!permissionGranted) {
      _logger.w("Storage permission not granted, cannot download file");
      return;
    }
    if (fileLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid file URL")),
      );
      return;
    }

    try {
      final dio = Dio();
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to access storage directory")),
        );
        return;
      }

      final fullPath = '${dir.path}/$fileName';
      await dio.download(
        fileLink,
        fullPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _logger.i("${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Downloaded $fileName to $fullPath")),
      );
    } catch (e) {
      _logger.e("Failed to download file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to download file")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Download Forms",
          style: TextStyle(fontFamily: 'poppins', fontSize: 18),
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
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Consumer<DownloadFormsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return GridView.count(
                  physics: const AlwaysScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.85,
                  children: List.generate(
                    (size.height / 240).ceil(),
                    (index) => const Padding(
                      padding: EdgeInsets.all(4),
                      child: ClassCardShimmer(),
                    ),
                  ),
                );
              }

              if (viewModel.downloadsList.isEmpty) {
                return SizedBox(
                  height: 100,
                  child: BuildNoData(
                    size,
                    'No forms available',
                    Icons.disabled_visible_rounded,
                  ),
                );
              }

              return GridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
                children: viewModel.downloadsList.map((report) {
                  return Consumer<ThemeProvider>(
                    builder: (context, provider, child) {
                      return GestureDetector(
                        onTap: () => downloadFile(
                          report.documentName ?? 'Untitled',
                          report.fileLink ?? '',
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: provider.isDarkMode
                                ? Colors.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                report.fileLink?.endsWith('.pdf') ?? false
                                    ? Icons.picture_as_pdf
                                    : Icons.description,
                                color:
                                    report.fileLink?.endsWith('.pdf') ?? false
                                        ? Colors.red
                                        : Colors.blue,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                report.documentName ?? 'Untitled',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: provider.isDarkMode
                                      ? Colors.white38
                                      : Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                report.description ??
                                    report.documentName ??
                                    'No description',
                                style: TextStyle(
                                  color: provider.isDarkMode
                                      ? Colors.white60
                                      : Colors.grey[800],
                                  fontSize: 11,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                'Published: ${report.publishOn != null && report.publishOn!.isNotEmpty ? parseDate(report.publishOn!) : "Unknown"}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(Icons.download,
                                    color: Colors.grey, size: 20),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
