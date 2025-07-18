import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:provider/provider.dart';

import '../../view_model/theme_provider.dart';

class Alert extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;
  final String buttonText;

  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;

  const Alert({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    this.onOkPressed,
    this.onCancelPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return AlertDialog(
        backgroundColor: provider.isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                  fontSize: 22,
                  color: provider.isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
        content: Text(
          content,
          style: TextStyle(
              fontSize: 16,
              color: provider.isDarkMode ? Colors.white : Colors.black),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(buttonText),
          ),
        ],
      );
    });
  }
}
