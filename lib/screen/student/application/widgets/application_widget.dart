import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/theme_provider.dart';

class ApplicationWidget extends StatelessWidget {
  final Color iconColor, textColor,btnColor;
  final String status, title, subBody,endDate,appdate;
  const ApplicationWidget({super.key, required this.iconColor, required this.textColor, required this.btnColor, required this.status, required this.title, required this.subBody, required this.endDate, required this.appdate});

  @override
  Widget build(BuildContext context) {
    final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(appdate),
          const SizedBox(height: 4,),
          Container(
            padding: const EdgeInsets.all(8),
            width: size.width,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode?Colors.black:Colors.white,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.chrome_reader_mode_rounded,
                  color: iconColor,
                  size: 30,
                ),
                const SizedBox(width: 8),
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Start Date :$subBody",
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "End Date : $endDate",
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),

                      Text(
                        "Click to view application",
                        style: TextStyle(fontSize: 11,color:AppColors.primary,fontStyle: FontStyle.italic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: btnColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child:  Text(
                    status,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
