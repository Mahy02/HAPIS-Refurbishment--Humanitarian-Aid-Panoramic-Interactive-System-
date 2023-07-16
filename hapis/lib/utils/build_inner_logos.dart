import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

///This is a widget for  [buildTabletLogos] in the about Page, as well as the text in the about page
Widget buildTabletLogos() {
  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  for (var letter in 'HAPIS'.split(''))
                    TextSpan(
                      text: letter,
                      style: TextStyle(
                        fontSize: 80,
                        fontFamily: GoogleFonts.lato().fontFamily,
                        color: getColorForLetter(
                            letter), // Custom function to get color for each letter
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  for (var word
                      in 'Humanitarian Aid Panoramic Interactive System'
                          .split(' '))
                    TextSpan(
                      text: word.substring(
                          0, 1), // Get the first letter of the word
                      style: TextStyle(
                        fontSize: 60,
                        fontFamily: GoogleFonts.lato().fontFamily,
                        color: getColorForWord(
                            word), // Custom function to get color for each word
                      ),
                      children: [
                        TextSpan(
                          text: word.substring(
                              1), // Get the remaining letters of the word
                          style: TextStyle(
                            fontSize: 60,
                            fontFamily: GoogleFonts.lato().fontFamily,
                          ),
                        ),
                        const TextSpan(text: ' '),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        Image.asset(
          "assets/images/HAPIS_Logo.png",
          scale: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Contributor: Mahinour Elsarky',
              style: TextStyle(
                  fontSize: 28, fontFamily: GoogleFonts.lato().fontFamily),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Mentors: Claudia Diosan, Karine Pistili Rodrigues, Deniz Yuksel',
              style: TextStyle(
                  fontSize: 28, fontFamily: GoogleFonts.lato().fontFamily),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Liquid Galxy Project Admin: Andreu Ibáñez Perales',
              style: TextStyle(
                  fontSize: 28, fontFamily: GoogleFonts.lato().fontFamily),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'The main idea of HAPIS Refurbishment is to have a simple functional application that is able to connect those who need something with those willing to offer it through an android mobile application where the user can simply fill in a form or view the list of seekers & givers any place in the world. Things offered can fall in any category such as food, clothes, electronics, books...etc. We will use the technology of Liquid Galaxy in order to visualize all Humanitarian actions all around the world by viewing on the LG the number of people currently offering something, or seeking something as well as some statistics such as the number of successful donations that happened either locally or globally. Controlling the LG would be through an android tablet application.',
              style: TextStyle(
                  fontSize: 28, fontFamily: GoogleFonts.lato().fontFamily),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/LOGO LIQUID GALAXY-sq1000- OKnoline.png",
                scale: 3),
            Image.asset("assets/images/gsoc.png", scale: 2),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/EDU.png", scale: 2),
            const SizedBox(
              width: 30,
            ),
            Image.asset("assets/images/LiquidGalaxyLab.png", scale: 2),
            const SizedBox(
              width: 30,
            ),
            Image.asset("assets/images/3-removebg-preview.png", scale: 1),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/WomenTech.png", scale: 3),
            const SizedBox(
              width: 30,
            ),
            Image.asset(
                "assets/images/Laboratoris_TIC_-agrobiotech-removebg-preview-removebg-preview.png",
                scale: 4),
            const SizedBox(
              width: 30,
            ),
            Image.asset(
                "assets/images/Parc_AgrobioTech_Lleida-removebg-preview.png",
                scale: 4)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Android_robot.svg.png",
              scale: 20,
            ),
            const SizedBox(
              width: 100,
            ),
            Image.asset(
              "assets/images/Google-flutter-logo.svg.png",
              scale: 18,
            )
          ],
        ),
      ],
    ),
  );
}

Widget buildMobileLogos() {
  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  for (var letter in 'HAPIS'.split(''))
                    TextSpan(
                      text: letter,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: GoogleFonts.lato().fontFamily,
                        color: getColorForLetter(
                            letter), // Custom function to get color for each letter
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  for (var word
                      in 'Humanitarian Aid Panoramic Interactive System'
                          .split(' '))
                    TextSpan(
                      text: word.substring(
                          0, 1), // Get the first letter of the word
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: GoogleFonts.lato().fontFamily,
                        color: getColorForWord(
                            word), // Custom function to get color for each word
                      ),
                      children: [
                        TextSpan(
                          text: word.substring(
                              1), // Get the remaining letters of the word
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: GoogleFonts.lato().fontFamily,
                          ),
                        ),
                        const TextSpan(text: ' '),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        Image.asset(
          "assets/images/HAPIS_Logo.png",
          scale: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Contributor: Mahinour Elsarky',
              style: TextStyle(
                  fontSize: 18, fontFamily: GoogleFonts.lato().fontFamily),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Mentors: Claudia Diosan, Karine Pistili Rodrigues, Deniz Yuksel',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontFamily: GoogleFonts.lato().fontFamily),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Liquid Galxy Project Admin: Andreu Ibáñez Perales',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontFamily: GoogleFonts.lato().fontFamily),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'The main idea of HAPIS Refurbishment is to have a simple functional application that is able to connect those who need something with those willing to offer it through an android mobile application where the user can simply fill in a form or view the list of seekers & givers any place in the world. Things offered can fall in any category such as food, clothes, electronics, books...etc. We will use the technology of Liquid Galaxy in order to visualize all Humanitarian actions all around the world by viewing on the LG the number of people currently offering something, or seeking something as well as some statistics such as the number of successful donations that happened either locally or globally. Controlling the LG would be through an android tablet application.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontFamily: GoogleFonts.lato().fontFamily),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/LOGO LIQUID GALAXY-sq1000- OKnoline.png",
                scale: 8),
            const SizedBox(
              width: 30,
            ),
            Image.asset("assets/images/gsoc.png", scale: 6),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/EDU.png", scale: 6),
            // const SizedBox(
            //   width: 30,
            // ),
            Image.asset("assets/images/LiquidGalaxyLab.png", scale: 5),
            // const SizedBox(
            //   width: 30,
            // ),
            Image.asset("assets/images/3-removebg-preview.png", scale: 3),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/WomenTech.png", scale: 7),
            // const SizedBox(
            //   width: 30,
            // ),
            Image.asset(
                "assets/images/Laboratoris_TIC_-agrobiotech-removebg-preview-removebg-preview.png",
                scale: 7.5),
            // const SizedBox(
            //   width: 30,
            // ),
            Image.asset(
                "assets/images/Parc_AgrobioTech_Lleida-removebg-preview.png",
                scale: 7.5)
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Android_robot.svg.png",
              scale: 40,
            ),
            const SizedBox(
              width: 50,
            ),
            Image.asset(
              "assets/images/Google-flutter-logo.svg.png",
              scale: 30,
            )
          ],
        ),
      ],
    ),
  );
}
