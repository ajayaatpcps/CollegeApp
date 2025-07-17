import 'package:flutter/material.dart';

class PasswordTextfield extends StatefulWidget {
  final String text;
  final String hintText;
  final Color outlinedColor;
  final bool obscureText; // Required for password fields
  final Color focusedColor;
  final String? helper;
  final TextStyle? helperStyle;
  final double width;
  final TextEditingController? textController;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const PasswordTextfield({
    super.key,
    required this.hintText,
    required this.outlinedColor,
    this.obscureText = false, // Default value for non-password fields
    required this.focusedColor,
    required this.width,
    required this.text,
    this.textController,
    this.keyboardType,
    this.onChanged,
    this.helper,
    this.helperStyle,
  });

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  late bool isPasswordVisible; // Tracks the visibility state

  @override
  void initState() {
    super.initState();
    isPasswordVisible = widget.obscureText; // Initialize with the passed value
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
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
          const SizedBox(height: 4),
          TextField(
            controller: widget.textController,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            obscureText: isPasswordVisible,
            style: const TextStyle(
                fontFamily: 'poppins', fontSize: 15), // Toggle visibility
            decoration: InputDecoration(
              helperText: widget.helper,
              helperStyle: widget.helperStyle,
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
              suffixIcon:
              widget.obscureText // Show toggle only for password fields
                  ? IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
