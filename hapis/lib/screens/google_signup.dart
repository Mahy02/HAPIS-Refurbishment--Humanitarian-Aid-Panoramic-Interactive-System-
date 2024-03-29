import 'package:flutter/material.dart';
import 'package:hapis/helpers/login_session_shared_preferences.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/screens/app_home.dart';
import 'package:hapis/screens/sign_up_page.dart';
import '../helpers/google_signin_api.dart';
import '../services/db_services/users_services.dart';
import '../utils/colors.dart';
import '../utils/database_popups.dart';

class GoogleSignUp extends StatefulWidget {
  const GoogleSignUp({super.key});

  @override
  State<GoogleSignUp> createState() => _GoogleSignUpState();
}

class _GoogleSignUpState extends State<GoogleSignUp> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor('FF90B5D1'),
            hexStringToColor('FF8CCBE5'),
            hexStringToColor('FFB7D990'),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: ResponsiveLayout(
              mobileBody: buildMobileLayout(),
              tabletBody: buildTabletLayout())),
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_back)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppHomePage()));
              },
            ),
            Image.asset("assets/images/HAPIS_Logo.png"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hey there! \nWelcome Back \n',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your account to continue',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            ElevatedButton(
              onPressed: () => signIn(true),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Image(
                      image: AssetImage("assets/images/google.png"),
                      height: 24.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        signUp();
                      },
                      child: const Text(
                        "Sign Up!",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_back)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppHomePage()));
              },
            ),
            Image.asset(
              "assets/images/HAPIS_Logo.png",
              scale: 2.8,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.001,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hey there! \nWelcome Back \n',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                )),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your account to continue',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            ElevatedButton(
              onPressed: () => signIn(true),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Image(
                      image: AssetImage("assets/images/google.png"),
                      height: 30.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                    ),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        signUp();
                      },
                      child: const Text(
                        "Sign Up!",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 28.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signIn(bool isGoogleUser) async {
    if (isGoogleUser) {
      try {
        await GoogleSignInApi.login();
        await GoogleSignInApi.logout();
        final user = await GoogleSignInApi.login();

        if (user == Null) {
        } else {
          final userExists =
              await UserServices().doesGoogleUserExist(user.id, user.email);
          if (userExists != 0) {
            //save ID
            LoginSessionSharedPreferences.setUserID(user.id);
            //set login to tryue
            LoginSessionSharedPreferences.setLoggedIn(true);
            // ignore: use_build_context_synchronously
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AppHomePage()));
          } else {
            showDatabasePopup(context,
                'User doesn\'t exist \n \nPlease check your credentials again or try signing up if you are new to HAPIS.');
            return;
          }
        }
      } on Exception catch (e) {
        // Handle the sign-in error.
        print('Sign-in error: $e');
        showDatabasePopup(context, 'There was a problem signing in. ${e.toString()}');
        return;
      }
    }
  }

  Future signUp() async {
    try {
      await GoogleSignInApi.login();
      await GoogleSignInApi.logout();

      final user = await GoogleSignInApi.login();

      if (user == Null) {
      } else {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpPage(
                      googleUser: user,
                      update: false,
                      isGoogle: true,
                    )));
      }
    } on Exception catch (e) {
      // Handle the sign-in error.
      print('Sign-in error: $e');
       showDatabasePopup(context, 'There was a problem signing in. ${e.toString()}');
      return;
    }
  }
}
