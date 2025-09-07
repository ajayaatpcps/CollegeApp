import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/theme_provider.dart';

Widget buildBalanceCard({
  required IconData icon,
  required String title,
  required String amountRs,
  required String amountPound,
  required BuildContext context,
  Color? color,
}) {
  final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

  return Card(
    color: (themeProvider.isDarkMode?Colors.black:color) ?? Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, size: 30, color: themeProvider.isDarkMode?Colors.white: Colors.black54),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(amountRs, style: const TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );
}
