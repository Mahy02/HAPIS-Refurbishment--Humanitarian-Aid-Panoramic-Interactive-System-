import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/main.dart';

///This is a customer elevated button which is reused in many views through our app
///[HapisElevatedButton] takes as parameters:
///   * [elevatedButtonContent] - A [String] for displaying the content of each elevated button
///   * [buttonColor] - A [Color] to display different colors for the buttons through the app
///   * [onpressed]  - A [Function] to be displayed when the button is pressed
///   * [height] - A [double] parameter for adjusting the height of the button
///   * [imagePath] - An optional [String] representing the image path, if a button requires an image

class HapisElevatedButton extends StatelessWidget {
  final String elevatedButtonContent;
  final Color buttonColor;
  final Function onpressed;
  final double height;
  final bool isPoly;
  double? imageHeight;
  double? imageWidth;
  String? imagePath;
  HapisElevatedButton({
    required this.elevatedButtonContent,
    required this.buttonColor,
    required this.onpressed,
    required this.height,
    this.imagePath,
    this.imageHeight,
    this.imageWidth,
    required this.isPoly,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        onPressed: () {
          onpressed();
        },
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: (imagePath != null && imagePath != '')
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isPoly
                      ?
                      //     ? Expanded(
                      //         child: ClipPolygon(
                      //           sides: 8,
                      //           borderRadius: 50,
                      //           child: Container(
                      //             width: imageWidth,
                      //             height: imageHeight,
                      //             decoration: BoxDecoration(
                      //               border: Border.all(
                      //                 color: Colors.black,
                      //                 width: 2,
                      //               ),
                      //             ),
                      //             child: Image.asset(
                      //               imagePath!,
                      //               // width: imageWidth,
                      //               // height: imageHeight,
                      //               //fit: BoxFit.cover,
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      // :
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HapisColors.primary,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Image.asset(
                            imagePath!, // Replace with your image path
                            height: imageHeight,
                            width: imageWidth,
                          ),
                        )
                      : Image.asset(
                          imagePath!, // Replace with your image path
                          height: imageHeight,
                          width: imageWidth,
                        ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      elevatedButtonContent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            : Text(
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
