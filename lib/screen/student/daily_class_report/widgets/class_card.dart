import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../view_model/theme_provider.dart';
import 'dcr_card_image.dart';

class ClassCard extends StatelessWidget {
  final String text, code,faculty,session,section,semester;
  const ClassCard({
    super.key,
    required this.text,
    required this.code, required this.faculty, required this.session, required this.section, required this.semester,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return
      Consumer<ThemeProvider>(
        builder: (context, provider, child) {
        return  Container(
            width: size.width,
            decoration: BoxDecoration(
              color: provider.isDarkMode? Colors.black: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DcrCardImage(session: text, semester: semester, section: section,),
                const SizedBox(height: 6),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Subject Code : $code",
                                    overflow: TextOverflow.ellipsis, // prevents overflow
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    faculty,
                                    overflow: TextOverflow.ellipsis, // prevents overflow
                                    textAlign: TextAlign.end, // keep aligned to right
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
       });
  }
}
