import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../view_model/user_view_model/current_user_model.dart';
import '../../../widgets/custom_shimmer.dart';

class StudentIdCard extends StatefulWidget {
  const StudentIdCard({super.key});

  @override
  State<StudentIdCard> createState() => _StudentIdCardState();
}

class _StudentIdCardState extends State<StudentIdCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Identity Card",
          style: TextStyle(fontFamily: 'poppins'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
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
      ),


      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<UserDataViewModel>(builder: (context, viewModel, _) {
            final user = viewModel.currentUser;
            final image =
                "${BaseUrl.imageDisplay}/html/profiles/students/${user?.stuProfilePath}/${user?.stuPhoto}";

            return Container(
              width: size.width,
              padding: const EdgeInsets.all(12),
              child: Card(
                color:  Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Image(
                        image: AssetImage("assets/images/pcpsLogo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: BarcodeWidget(
                                    barcode: Barcode.code128(),
                                    data: user?.stuRollNo ?? "",
                                    width: 300,
                                    drawText: true,
                                    style: const TextStyle(
                                      fontSize: 20, // Increased font size
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  image,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CustomShimmerLoading(
                                        width: 220,
                                        height: 200,
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: Icon(
                                        Icons.school,
                                        color: AppColors.primary,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "${user!.stuFirstname} ${user.stuLastname}",
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,

                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${user.courseShortName} ${user.semesterName}",
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.black,

                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Expiry Date: 2026-01-15",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,

                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      maxLines: null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              "assets/images/bedsLogo.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Image.asset(
                                    "assets/images/sign.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Signature",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,

                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: const Column(
                        children: [
                          Text(
                            "Kupondole, Lalitpur, Nepal  01-5181033",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "patancollege.edu.np",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
