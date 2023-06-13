import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HapisElevatedButton extends StatelessWidget {
  final String elevatedButtonContent;
  final Color buttonColor;
  const HapisElevatedButton({
    required this.elevatedButtonContent,
    required this.buttonColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary:buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          elevatedButtonContent,
          style: TextStyle(
            fontSize: 35,
            fontFamily: GoogleFonts.montserrat().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}