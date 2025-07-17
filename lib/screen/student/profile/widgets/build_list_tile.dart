import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/theme_provider.dart';

Widget buildListTile(
    IconData icon, String title, BuildContext context, Function() onPressed) {
  return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
    return ListTile(
      leading: Icon(icon, color:themeProvider.isDarkMode ? Colors.white :  Colors.black, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      trailing:  Icon(Icons.chevron_right, color:themeProvider.isDarkMode ? Colors.white :  Colors.grey, size: 24),
      onTap: onPressed,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: themeProvider.isDarkMode ? Colors.black : Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  });
}
