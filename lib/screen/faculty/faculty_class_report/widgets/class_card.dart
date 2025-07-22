import 'package:flutter/material.dart';
import 'dcr_card_image.dart';

class FacultyClassCard extends StatelessWidget {
  final String text, code,faculty,session,section,semester;
  const FacultyClassCard({
    super.key,
    required this.text,
    required this.code, required this.faculty, required this.session, required this.section, required this.semester,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DcrCardImage(session: session, semester: semester, section: section,),
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
                        text,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Class Code : $code",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            faculty,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}