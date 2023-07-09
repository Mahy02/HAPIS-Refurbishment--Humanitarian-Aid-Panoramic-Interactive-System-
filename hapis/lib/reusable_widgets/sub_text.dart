import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


///This is custom widget for the `subText` that is reused in different views through the app

class SubText extends StatelessWidget {
  final String subTextContent;
  const SubText({
    required this.subTextContent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      subTextContent,
      style: TextStyle(
          fontSize: 35,
          color: Colors.black,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          fontWeight: FontWeight.bold),
    );
  }
}
