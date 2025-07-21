import 'package:flutter/material.dart';
import '../../../../resource/colors.dart';

class CustomRemarksField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;
  final double height;
  final double width;
  final Color borderColor;
  final Color focusedColor;

  const CustomRemarksField({
    super.key,
    required this.hintText,
    this.controller,
    required this.onChanged,
    this.onTap,
    required this.height,
    required this.width,
    required this.borderColor,
    required this.focusedColor,
  });

  @override
  State<CustomRemarksField> createState() => _CustomRemarksFieldState();
}

class _CustomRemarksFieldState extends State<CustomRemarksField> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(() {
      setState(() {}); // Update UI when text changes
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
        elevation: 2.5,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(6),
        child: TextField(
          controller: _internalController,
          onChanged: widget.onChanged,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: widget.focusedColor, width: 1.5),
            ),

            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_internalController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _internalController.clear();
                        widget.onChanged('');
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  if (_internalController.text.isNotEmpty)
                    const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
