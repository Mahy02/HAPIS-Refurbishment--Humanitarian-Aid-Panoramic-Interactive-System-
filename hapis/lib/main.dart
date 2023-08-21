import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/providers/date_selection.dart';
import 'package:hapis/providers/drop_down_state.dart';
import 'package:hapis/providers/filter_provider.dart';
import 'package:hapis/providers/form_provider.dart';
import 'package:hapis/providers/icon_state_provider.dart';
import 'package:hapis/providers/liquid_galaxy/connection_provider.dart';
import 'package:hapis/providers/liquid_galaxy/ssh_provider.dart';
import 'package:hapis/providers/liquid_galaxy/users_provider.dart';
import 'package:hapis/providers/user_provider.dart';
import 'package:hapis/screens/splash_screen.dart';
import 'package:hapis/services/liquid_galaxy/LG_functionalities.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'helpers/lg_connection_shared_preferences.dart';
import 'helpers/login_session_shared_preferences.dart';
import 'helpers/sql_db.dart';
import 'models/liquid_galaxy/ssh_model.dart';
import 'package:responsive_framework/responsive_framework.dart';

///This is the main starting point of our application
///
///Our Home is the [SplashScreen]
///We call [LgService] Class to call setlogos using the ssh info from the [SSHprovider] at the start of the app
///we have a [MultiProvider] for all our providers in our app
///At the beginning of our [main] function we initialize [SqlDb] instance to create the database or simply retrieve it if already existing
/// We Create a [Timer] that calls the reconnectClient() function every 30 seconds as client loses connection after some time


/// This is the main starting point of the HAPIS application
void main() async {

  /// Initialize the app
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize shared preferences for login session and LG connection
  await LoginSessionSharedPreferences.init();
  await LgConnectionSharedPref.init();
  await dotenv.load(fileName: ".env");


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Connectionprovider()),
        ChangeNotifierProvider(create: (_) => IconState()),
        ChangeNotifierProvider(create: (_) => SSHprovider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserAppProvider()),
        ChangeNotifierProvider(create: (_) => FormProvider()),
        ChangeNotifierProvider(create: (_) => DropdownState()),
        ChangeNotifierProvider(create: (_) => DateSelectionModel()),
        ChangeNotifierProvider(create: (_) => FilterSettingsModel()),
      ],
      child: const HAPIS(),
    ),
  );

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    final sshData =
        Provider.of<SSHprovider>(navigatorKey.currentContext!, listen: false);

    Connectionprovider connection = Provider.of<Connectionprovider>(
        navigatorKey.currentContext!,
        listen: false);

    String? result = await sshData.reconnectClient(
        SSHModel(
          username: LgConnectionSharedPref.getUserName() ?? '',
          host: LgConnectionSharedPref.getIP() ?? '',
          passwordOrKey: LgConnectionSharedPref.getPassword() ?? '',
          port: int.parse(LgConnectionSharedPref.getPort() ?? '22'),
        ),
        navigatorKey.currentContext!);
    if (result == 'fail' || result != '') {
      connection.isConnected = false;
    } else {
      connection.isConnected = true;
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


/// The root widget of the HAPIS application.
class HAPIS extends StatelessWidget {
  const HAPIS({super.key});

  @override
  Widget build(BuildContext context) {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    LgService(sshData).setLogos();

    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
          fontFamily: GoogleFonts.montserrat().fontFamily,
          primaryColor: HapisColors.primary),
      title: 'HAPIS',
      home: OrientationBuilder(
        builder: (context, orientation) {
         /// Get the device's screen size and aspect ratio
          final screenSize = MediaQuery.of(context).size;
          final screenAspectRatio = screenSize.width / screenSize.height;

          /// If the device is a tablet (large screen size and square or landscape aspect ratio)
          if (screenSize.shortestSide >= 600 && screenAspectRatio >= 1) {
            /// Lock the screen orientation to landscape mode
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          } else {
            /// Allow the screen orientation to be determined by the device's physical orientation
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          }

          return const SplashScreen();
         
        },
      ),
      navigatorKey: navigatorKey,
    );
  }
}
