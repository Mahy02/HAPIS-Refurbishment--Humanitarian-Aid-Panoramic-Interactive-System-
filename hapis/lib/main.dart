import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/providers/connection_provider.dart';
import 'package:hapis/providers/icon_state_provider.dart';
import 'package:hapis/providers/ssh_provider.dart';
import 'package:hapis/screens/about_screen.dart';
import 'package:hapis/screens/configuration_screen.dart';
import 'package:hapis/screens/settings_screen.dart';
import 'package:hapis/screens/splash_screen.dart';

import 'package:hapis/services/LG_functionalities.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

///This is the main starting point of our application
///
///Our Home is the [SplashScreen]
///We call [LgService] Class to call setlogos using the ssh info from the [SSHprovider] at the start of the app
/// we have a [MultiProvider] for all our providers in our app

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Connectionprovider()),
        ChangeNotifierProvider(create: (_) => IconState()),
        ChangeNotifierProvider(create: (_) => SSHprovider()),
      ],
      child: const HAPIS(),
    ),
  );
}

class HAPIS extends StatelessWidget {
  const HAPIS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    int counter=1;
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    print("inside main ");
    LgService(sshData).setLogos();

    return
        // MultiProvider(
        //   providers: [
        //     ChangeNotifierProvider(create: (_) => Connectionprovider()),
        //     ChangeNotifierProvider(create: (_) => IconState()),
        //     ChangeNotifierProvider(create: (_) => SSHprovider()),
        //   ],
        // child:
        MaterialApp(
      theme: ThemeData(
          fontFamily: GoogleFonts.montserrat().fontFamily,
          primaryColor: HapisColors.primary),
      title: 'HAPIS',
       home: const SplashScreen(),
      //home: const Settings(),
      //initialRoute: ,
      routes: {
        // '/': (context) => const LogInPage1(),
        //  '/user/signup/null': (context) => NewPasswordPage(),
        '/settings': (context) => const Settings(),
        '/connections': (context) => const Configuration(),
        '/about': (context) => const About(),
      },
    );
    // );
  }
}
