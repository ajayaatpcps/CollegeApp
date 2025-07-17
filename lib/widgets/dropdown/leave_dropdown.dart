import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resource/colors.dart';
import '../../view_model/theme_provider.dart';

class LeaveDropdown extends StatefulWidget {
  final String label;
  final double wid;
  final TextEditingController? controller; // Nullable controller parameter
  final String? initialValue; // New initialValue parameter
  final Function(String?) onChanged; // onChanged callback

  const LeaveDropdown({
    super.key,
    required this.label,
    required this.wid,
    this.controller,
    this.initialValue, // Optional initialValue
    required this.onChanged,
  });

  final border = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 1.5,
      color: Colors.grey,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  @override
  State<LeaveDropdown> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<LeaveDropdown> {
  final List<String> items = ['Leave Application', 'Fees Application'];
  String? selectedRegion;

  @override
  void initState() {
    super.initState();
    // Prioritize initialValue if provided, otherwise use controller
    if (widget.initialValue != null && items.contains(widget.initialValue)) {
      selectedRegion = widget.initialValue;
      if (widget.controller != null) {
        widget.controller!.text = widget.initialValue!;
      }
    } else if (widget.controller?.text.isNotEmpty == true &&
        items.contains(widget.controller?.text)) {
      selectedRegion = widget.controller!.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider=   Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(0),
          width: widget.wid,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: themeProvider.isDarkMode?Colors.black: Colors.white,
              enabledBorder: widget.border,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: AppColors.primary,
                  style: BorderStyle.solid,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)
                ),
              ),
            ),
            value: selectedRegion,
            hint: const Text('Application Type'),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedRegion = newValue;
              });
              if (widget.controller != null) {
                widget.controller!.text = newValue ?? '';
              }
              widget.onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }
}