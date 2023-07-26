import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hapis/helpers/login_session_shared_preferences.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/screens/app_home.dart';
import 'package:hapis/screens/sign_up_page.dart';

import '../helpers/google_signin_api.dart';
import '../reusable_widgets/text_form_field.dart';
import '../services/db_services/users_services.dart';
import '../utils/color_utils.dart';

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
        padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
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
              height: MediaQuery.of(context).size.height * 0.002,
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
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormFieldWidget(
              key: const ValueKey("email"),
              fillColor: Color.fromARGB(0, 255, 255, 255),
              textController: _emailController,
              hint: 'Enter your Email',
              isHidden: false,
              isSuffixRequired: true,
              label: 'Email',
              fontSize: 16,
            ),
            TextFormFieldWidget(
              fillColor: Color.fromARGB(0, 255, 255, 255),
              key: const ValueKey("pass"),
              textController: _passController,
              hint: 'Enter your password',
              isHidden: true,
              isSuffixRequired: true,
              label: 'Password',
              fontSize: 16,
            ),
            ElevatedButton(
              onPressed: () => signIn(false),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  )),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
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
              height: MediaQuery.of(context).size.height * 0.02,
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

  Future signIn(bool isGoogleUser) async {
    if (isGoogleUser) {
      try {
        final user = await GoogleSignInApi.login();

        if (user == Null) {
        } else {
          final userExists =
              await UserServices().doesGoogleUserExist(user.id, user.email);
          if (userExists != 0) {
            //get authentication access token:
            final GoogleSignInAuthentication googleAuth =
                await user.authentication;
            //set the expiration time in seconds (e.g. 2 hours)
            final int expirationTimeSeconds = 7200;
            final DateTime expiryTime =
                DateTime.now().add(Duration(seconds: expirationTimeSeconds));
            final String? accessToken = googleAuth.accessToken;
            print(accessToken);
            //save it in shared preferences:
            await LoginSessionSharedPreferences.saveToken(
                accessToken!, expiryTime);
            // ignore: use_build_context_synchronously
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AppHomePage()));
          } else {
            //user doesnt exist message, check email and password
            print(userExists);
          }
        }
      } on Exception catch (e) {
        // Handle the sign-in error.
        print('Sign-in error: $e');
      }
    } else {
      String pass = _passController.text;
      String email = _emailController.text;
      final userID = await UserServices().doesNormalUserExist(pass, email);
      if (userID.isNotEmpty) {
        //save ID
        LoginSessionSharedPreferences.setNormalUserID(userID);
        //set login to tryue
        LoginSessionSharedPreferences.setLoggedIn(true);
         // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AppHomePage()));
      } else {
        //user doesnt exist message, check email and password
        print(userID);
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
                      user: user,
                    )));
      }
    } on Exception catch (e) {
      // Handle the sign-in error.
      print('Sign-in error: $e');
    }
  }
}

/*
 // final GoogleSignInAuthentication googleAuth = await user.authentication;
          // final String? accessToken = googleAuth.accessToken;
          // print(accessToken);

 // if (googleAuth.idToken != null) {
        //   final String idToken = googleAuth.idToken!;
        // } else {
        //   print('id null');
        //   throw Exception('Google Sign-In error: ID token is null');
        // }
*/
