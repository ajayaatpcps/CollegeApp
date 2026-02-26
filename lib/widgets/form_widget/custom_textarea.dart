import 'package:flutter/material.dart';
import 'package:lbef/view_model/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomTextArea extends StatefulWidget {
  final String label;
  final String hintText;
  final String? helperText;
  final Color outlinedColor;
  final Color focusedColor;
  final double width;
  final int? maxLines;
  final TextEditingController? textController;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const CustomTextArea({
    super.key,
    required this.hintText,
    required this.outlinedColor,
    required this.focusedColor,
    required this.width,
    required this.label,
    this.textController,
    this.keyboardType,
    this.onChanged,
    this.helperText,
    this.maxLines = 5,
  });

  @override
  State<CustomTextArea> createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);

        return SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: widget.textController,
                onChanged: widget.onChanged,
                keyboardType: widget.keyboardType ?? TextInputType.multiline,
                maxLines: widget.maxLines,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  filled: true,
                  helperText: widget.helperText,
                  fillColor: provider.isDarkMode ? Colors.black : Colors.white,
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: widget.outlinedColor,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: widget.focusedColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
