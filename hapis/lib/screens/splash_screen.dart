import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/screens/configuration_screen.dart';
import 'package:hapis/utils/build_inner_logos.dart';

import '../constants.dart';
import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => Configuration()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HapisColors.accent,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 80.0),
                      child: Text(
                        'H',
                        style: TextStyle(
                          color: HapisColors.lgColor1,
                          fontSize: 80,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 50.0),
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: HapisColors.lgColor2,
                          fontSize: 80,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/HAPIS_Logo.png",
                      scale: 2.8,
                    ),
                    const Text(
                      'P',
                      style: TextStyle(
                        color: HapisColors.lgColor3,
                        fontSize: 80,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 50.0),
                      child: Text(
                        'I',
                        style: TextStyle(
                          color: HapisColors.lgColor1,
                          fontSize: 80,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Text(
                      'S',
                      style: TextStyle(
                        color: HapisColors.lgColor4,
                        fontSize: 80,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        "assets/images/LOGO LIQUID GALAXY-sq1000- OKnoline.png",
                        scale: 5),
                    Image.asset("assets/images/gsoc.png", scale: 3.5),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/EDU.png", scale: 3),
                    SizedBox(
                      width: 30,
                    ),
                    Image.asset("assets/images/LiquidGalaxyLab.png", scale: 3),
                    SizedBox(
                      width: 30,
                    ),
                    Image.asset("assets/images/3-removebg-preview.png",
                        scale: 2),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/WomenTech.png", scale: 4),
                    SizedBox(
                      width: 30,
                    ),
                    Image.asset(
                        "assets/images/Laboratoris_TIC_-agrobiotech-removebg-preview-removebg-preview.png",
                        scale: 5),
                    SizedBox(
                      width: 30,
                    ),
                    Image.asset(
                        "assets/images/Parc_AgrobioTech_Lleida-removebg-preview.png",
                        scale: 5)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/Android_robot.svg.png",
                      scale: 24,
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Image.asset(
                      "assets/images/Google-flutter-logo.svg.png",
                      scale: 22,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
