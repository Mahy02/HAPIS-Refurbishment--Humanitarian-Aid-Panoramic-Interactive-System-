import 'package:flutter/material.dart';
import '../constants.dart';
import 'home.dart';


///This is a splash screen for displaying the logos and the name of the app for 3 seconds, then navigate to home page

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
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HapisColors.accent,
      body: Center(
        child: SingleChildScrollView(
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
                  const Text(
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
                  const SizedBox(
                    width: 30,
                  ),
                  Image.asset("assets/images/LiquidGalaxyLab.png", scale: 3),
                  const SizedBox(
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
                  const SizedBox(
                    width: 30,
                  ),
                  Image.asset(
                      "assets/images/Laboratoris_TIC_-agrobiotech-removebg-preview-removebg-preview.png",
                      scale: 5),
                  const SizedBox(
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
                  const SizedBox(
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
    );
  }
}
