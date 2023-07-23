import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/screens/app_home.dart';
import 'package:hapis/screens/sign_up_page.dart';

import '../helpers/google_signin_api.dart';
import '../utils/color_utils.dart';

class GoogleSignUp extends StatefulWidget {
  const GoogleSignUp({super.key});

  @override
  State<GoogleSignUp> createState() => _GoogleSignUpState();
}

class _GoogleSignUpState extends State<GoogleSignUp> {
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
        padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
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
              height: MediaQuery.of(context).size.height * 0.05,
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
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            ElevatedButton(
              onPressed: signIn,
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
              height: MediaQuery.of(context).size.height * 0.05,
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
        padding: EdgeInsets.fromLTRB(40, 50, 20, 0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back,
                    size: 40,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppHomePage()));
              },
            ),
            Image.asset("assets/images/HAPIS_Logo.png", scale: 3.5),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hey there! \nWelcome Back \n',
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                )),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your account to continue',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(
              onPressed: signIn,
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
                      height: 40.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
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
                          fontSize: 35.0,
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

  Future signIn() async {
    try {
      final user = await GoogleSignInApi.login();
      print(user);
      print(user.displayName);
      //here we should check if user exists in databse or not
      //if exist then sign in is complete and he can access all pages

      if (user == Null) {
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AppHomePage()));
      }
    } on Exception catch (e) {
      // Handle the sign-in error.
      print('Sign-in error: $e');
    }
  }

  Future signUp() async {
    try {
      await GoogleSignInApi.login();
      await GoogleSignInApi.logout();
      final user = await GoogleSignInApi.login();
      print(user);
      print(user.displayName);
      //here we should check if user exists in databse or not
      //if exist then sign in is complete and he can access all pages

      if (user == Null) {
      } else {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpPage(
                      user: user,
                    )));
      }
    } on Exception catch (e) {
      // Handle the sign-in error.
      print('Sign-in error: $e');
    }
  }
}
