import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/screens/app_home.dart';
import '../constants.dart';

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
    await Future.delayed(const Duration(seconds: 5));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const AppHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ResponsiveLayout(
            mobileBody: buildMobileLayout(), tabletBody: buildTabletLayout()));
  }

  Widget buildMobileLayout() {
    return Center(child: Image.asset('assets/images/LG logos.jpg'));
    // return Center(
    //   child: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Image.asset(
    //           "assets/images/HAPIS_Logo.png",
    //           scale: 8,
    //         ),
    //         const SizedBox(
    //           height: 30,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Image.asset(
    //                 "assets/images/LOGO LIQUID GALAXY-sq1000- OKnoline.png",
    //                 scale: 8),
    //             Image.asset("assets/images/gsoc.png", scale: 6.5),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 30,
    //         ),
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Image.asset("assets/images/EDU.png", scale: 5),
    //             Image.asset("assets/images/LiquidGalaxyLab.png", scale: 5),
    //             Image.asset("assets/images/3-removebg-preview.png", scale: 3),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 30,
    //         ),
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Image.asset("assets/images/WomenTech.png", scale: 6),
    //             Image.asset(
    //                 "assets/images/Laboratoris_TIC_-agrobiotech-removebg-preview-removebg-preview.png",
    //                 scale: 7),
    //             Image.asset(
    //                 "assets/images/Parc_AgrobioTech_Lleida-removebg-preview.png",
    //                 scale: 7)
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 30,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Image.asset(
    //               "assets/images/Android_robot.svg.png",
    //               scale: 30,
    //             ),
    //             const SizedBox(
    //               width: 20,
    //             ),
    //             Image.asset(
    //               "assets/images/Google-flutter-logo.svg.png",
    //               scale: 28,
    //             )
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget buildTabletLayout() {
    return Center(child: Image.asset('assets/images/LG logos.jpg'));
  }
}
