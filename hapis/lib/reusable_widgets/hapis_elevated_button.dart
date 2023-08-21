// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///This is a customer elevated button which is reused in many views through our app
///[HapisElevatedButton] takes as parameters:
///   * [elevatedButtonContent] - A [String] for displaying the content of each elevated button
///   * [buttonColor] - A [Color] to display different colors for the buttons through the app
///   * [onpressed]  - A [Function] to be displayed when the button is pressed
///   * [height] - A [double] parameter for adjusting the height of the button
///   * [imagePath] - An optional [String] representing the image path, if a button requires an image
///   * [isLoading]  - An optional indicator of loading
class HapisElevatedButton extends StatelessWidget {
  final String elevatedButtonContent;
  final Color buttonColor;
  final Function onpressed;
  final double height;
  final bool isPoly;
  final double fontSize;
  final double width;
  double? imageHeight;
  double? imageWidth;
  String? imagePath;
  bool isLoading = false;
  HapisElevatedButton({
    required this.elevatedButtonContent,
    required this.buttonColor,
    required this.onpressed,
    required this.height,
    required this.width,
    required this.fontSize,
    this.imagePath,
    this.imageHeight,
    this.imageWidth,
    required this.isLoading,
    required this.isPoly,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () {
          onpressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Stack(
          children: [
            if (isLoading)
              Positioned.fill(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            (imagePath != null && imagePath != '')
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isPoly
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: buttonColor,
                                  width: 0.0,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Image.asset(
                                imagePath!,
                                height: imageHeight,
                                width: imageWidth,
                              ),
                            )
                          : Image.asset(
                              imagePath!,
                              height: imageHeight,
                              width: imageWidth,
                            ),
                      const SizedBox(height: 20),
                      Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            elevatedButtonContent,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Text(
                      elevatedButtonContent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
