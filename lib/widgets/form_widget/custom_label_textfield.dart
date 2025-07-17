import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/theme_provider.dart';

class CustomLabelTextfield extends StatefulWidget {
  final String text;
  final String hintText;
  final Color outlinedColor;
  final bool? obscureText;
  final Color focusedColor;
  final double width;
  final Icon? suffixicon;
  final String? helper;
  final TextStyle? helperStyle;
  final Icon? prefixicon;
  final Widget? suffixText;
  final TextEditingController? textController;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const CustomLabelTextfield({
    super.key,
    required this.hintText,
    required this.outlinedColor,
    this.obscureText,
    required this.focusedColor,
    required this.width,
    required this.text,
    this.textController,
    this.keyboardType,
    this.onChanged,
    this.suffixicon,
    this.prefixicon,
    this.helper,
    this.helperStyle,
    this.suffixText,
  });

  @override
  State<CustomLabelTextfield> createState() => _CustomLabelTextfieldState();
}

class _CustomLabelTextfieldState extends State<CustomLabelTextfield> {
  @override
  Widget build(BuildContext context) {
    return  Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
         return SizedBox(
            // height: 100,
            width: widget.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: widget.textController,
                    onChanged: widget.onChanged,
                    keyboardType: widget.keyboardType,
                    style: const TextStyle(fontFamily: 'poppins', fontSize: 15),
                    decoration: InputDecoration(
                        helperText: widget.helper,
                        helperStyle: widget.helperStyle,
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'poppins',
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
                        suffixIcon: widget.prefixicon,
                        prefixIcon: widget.prefixicon,
                        suffix: widget.suffixText),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
