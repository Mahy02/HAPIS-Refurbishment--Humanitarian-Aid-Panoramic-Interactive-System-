import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:intl/intl.dart';


/// function `formatDate` that takes in a [DateTime] `date` and returns a [String] of the formatted date in specefic format
String formatDate(DateTime date) {
  final formatter = DateFormat('EEEE d MMMM, h:mm a');
  return formatter.format(date);
}

/// Function that returns the widget for the `AlertDialog` of the date popup in mobile layout
/// It takes a list of `dates` to show in the pop up
Widget buildMobileLayout(BuildContext context, List<String> dates) {
  return AlertDialog(
    title: Row(
      children: [
        const Icon(
          Icons.calendar_month_outlined,
          size: 20,
          color: Colors.grey,
        ),
        Text(
          'Available Dates',
          style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: HapisColors.lgColor1),
        ),
      ],
    ),
    content: SingleChildScrollView(
      child: Column(
        children: dates.map((dateStr) {
          final date = DateTime.parse(dateStr);
          return Text(formatDate(date),
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  color: Colors.black));
        }).toList(),
      ),
    ),
    actions: [
      ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                HapisColors.lgColor1), // Change the color to your desired one
          ),
          child: Text('Close',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  color: Colors.white))),
    ],
  );
}



/// Function that returns the widget for the `AlertDialog` of the date popup in tablet layout
/// It takes a list of `dates` to show in the pop up

Widget buildTabletLayout(BuildContext context, List<String> dates) {
  return AlertDialog(
    title: Row(
      children: [
        const Icon(
          Icons.calendar_month_outlined,
          size: 40,
          color: Colors.grey,
        ),
        Text(
          'Available Dates',
          style: TextStyle(
              fontSize: 35,
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: HapisColors.lgColor1),
        ),
      ],
    ),
    content: SingleChildScrollView(
      child: Column(
        children: dates.map((dateStr) {
          final date = DateTime.parse(dateStr);
          return Text(formatDate(date),
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  color: Colors.black));
        }).toList(),
      ),
    ),
    actions: [
      ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                HapisColors.lgColor1), // Change the color to your desired one
          ),
          child: Text('Close',
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  color: Colors.white))),
    ],
  );
}

/// Function to display the pop-up dialog that shows the formatted dates 
void showDatesDialog(List<String> dates, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ResponsiveLayout(
          mobileBody: buildMobileLayout(context, dates),
          tabletBody: buildTabletLayout(context, dates));
    },
  );
}
