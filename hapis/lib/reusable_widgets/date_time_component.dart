import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../providers/date_selection.dart';

class DateTimeComponent extends StatelessWidget {
  const DateTimeComponent({
    super.key,
    required this.dateModel,
  });

  final DateSelectionModel dateModel;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateModel.timeControllerStart,
      onTap: () => dateModel.showTimePickerStart(context),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_month_outlined,
          color: HapisColors.lgColor3,
        ),
        labelText: 'Time',
        labelStyle: TextStyle(
          fontSize: 16,
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
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
        filled: true,
        fillColor: const Color.fromARGB(156, 240, 240, 240),
     
        suffixIcon: Text(
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
