import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hapis/screens/app_home.dart';

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
        child: SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
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
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      TextSpan(
                        text: "Sign Up!",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();
    print(user);
  }
}
