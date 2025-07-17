import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/theme_provider.dart';

class CalenderWidget extends StatelessWidget {
  final String date, dateTime, title, organizerName, location;
  final Color color;

  const CalenderWidget({
    super.key,
    required this.title,
    required this.organizerName,
    required this.date,
    required this.color,
    required this.dateTime,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return
      Consumer<ThemeProvider>(
        builder: (context, provider, child)
    {
return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            width: size.width,
            decoration: BoxDecoration(
              color: provider.isDarkMode?Colors.black:Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.chrome_reader_mode_rounded,
                  color: color,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      if (organizerName != '') ...[
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: color,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                organizerName,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      if (location != '') ...[
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: color,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}