import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/theme_provider.dart';

Widget BuildNoData(
  Size size,
  String message,
  IconData icon,
) {
  return Consumer<ThemeProvider>(builder: (context, provider, child) {
    return Container(
      width: size.width * 0.9,
      height: 90,
      decoration: BoxDecoration(
        color: provider.isDarkMode
            ? Colors.black26
            : const Color(0xFFE3F2FD), // Light bluish background
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.blue[200]!, width: 0.5),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  });
}
