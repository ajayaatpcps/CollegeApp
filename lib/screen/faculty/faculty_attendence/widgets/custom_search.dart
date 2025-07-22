import 'package:flutter/material.dart';

import '../../../../resource/colors.dart';

class CustomSearch extends StatefulWidget {
  final String hintText;
  final TextStyle? hintStyle;
  final Color outlinedColor;
  final bool? obscureText;
  final Color focusedColor;
  final double height;
  final double width;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap, onReset;

  const CustomSearch({
    super.key,
    required this.hintText,
    required this.outlinedColor,
    this.obscureText,
    required this.focusedColor,
    required this.height,
    required this.width,
    this.keyboardType,
    required this.onChanged,
    this.hintStyle,
    this.controller,
    this.onTap,
    this.onReset,
  });

  @override
  State<CustomSearch> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomSearch> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(() {
      setState(() {}); // Rebuild to update clear icon visibility
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Material(
        elevation: 3.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
        child: TextField(
          controller: _internalController,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText ?? false,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: widget.outlinedColor,
                width: 1.8,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Clear icon (shown when text is present)
                  if (_internalController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _internalController.clear();
                        widget.onReset?.call();
                        widget.onChanged(''); // Notify parent of cleared text
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                        size: 22,
                      ),
                    ),
                  if (_internalController.text.isNotEmpty)
                    const SizedBox(width: 8), // Space between icons
                  // Search icon
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle, // Changed to circular shape
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: widget.focusedColor,
                width: 1.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}