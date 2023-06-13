import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/providers/connection_provider.dart';
import 'package:hapis/screens/configuration_screen.dart';
import 'package:hapis/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

void main() {
  runApp(const HAPIS());
}

class HAPIS extends StatelessWidget {
  const HAPIS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Connectionprovider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: GoogleFonts.montserrat().fontFamily,
            primaryColor: HapisColors.primary),
        title: 'HAPIS',
        home: const Configuration(),
        //home: const Settings(),
        //initialRoute: ,
        routes: {
          // '/': (context) => const LogInPage1(),
          //  '/user/signup/null': (context) => NewPasswordPage(),
          '/settings': (context) => const Settings(),
          '/connections': (context) => const Configuration(),
        },
      ),
    );
  }
}
