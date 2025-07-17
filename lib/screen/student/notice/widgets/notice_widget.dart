import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/theme_provider.dart';

class NoticeWidget extends StatelessWidget {
  final String published, body, subBody;

  const NoticeWidget({
    super.key,
    required this.subBody,
    required this.published,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return Container(

              padding: const EdgeInsets.all(8),
              width: size.width,
              decoration: BoxDecoration(
                color: provider.isDarkMode? Colors.black:Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.chrome_reader_mode_rounded,
                    color: provider.isDarkMode?Colors.white:AppColors.primary,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width:double.infinity,
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: provider.isDarkMode? Colors.black:Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            subBody,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Published on : ${published!=null||published!=''?parseDate(published):""}",
                          style: TextStyle(color: AppColors.primary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.primary,
                  //     borderRadius: BorderRadius.circular(5),
                  //     border: Border.all(color: Colors.transparent),
                  //   ),
                  //   child: Text(
                  //     published,
                  //     style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 10,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );

          },
        ),
      ],
    );
  }

  String _shortenText(String text, int limit) {
    if (text.length <= limit) return text;
    return text.substring(0, limit);
  }
}
