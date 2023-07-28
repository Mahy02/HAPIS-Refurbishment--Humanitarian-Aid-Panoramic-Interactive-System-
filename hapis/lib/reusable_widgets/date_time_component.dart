import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../providers/date_selection.dart';

/// The [DateTimeComponent] class that is a custom widget for displaying a [TextFormField] with the [DateSelectionModel] that shows the time picker
/// It takes [fontSize] and [iconSize] which are required for having responsive layout
/// It also has a required [dateModel]
///
class DateTimeComponent extends StatelessWidget {
  final double fontSize;
  final double? iconSize;
  const DateTimeComponent({
    super.key,
    required this.dateModel,
    required this.fontSize,
    this.iconSize,
  });

  final DateSelectionModel dateModel;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateModel.timeControllerStart,
      onTap: () => dateModel.showTimePickerStart(context),
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_month_outlined,
          color: HapisColors.lgColor3,
        ),
        labelText: 'Time',
        labelStyle: TextStyle(
          fontSize: fontSize,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          fontWeight: FontWeight.bold,
          color: HapisColors.lgColor1,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 5.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: HapisColors.lgColor3,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: const Color.fromARGB(156, 240, 240, 240),
        suffixIcon: const Text(
          '*',
          style: TextStyle(color: Colors.red, fontSize: 24),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
