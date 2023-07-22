import 'package:flutter/material.dart';

import '../reusable_widgets/login_signup_resuable_widgets.dart';
import '../utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            // hexStringToColor("CB2B93"),
            // hexStringToColor("9546C4"),
            // hexStringToColor("5E61F4")
            hexStringToColor('FF90B5D1'),
            hexStringToColor('FF8CCBE5'),
            hexStringToColor('FFB7D990'),

            // hexStringToColor("7f7d9cd5"),
            // hexStringToColor("7fc0523f"),
            // hexStringToColor("7ff6d21b"),
            //   hexStringToColor("537DC0"),
            // hexStringToColor("E54E3E"),
            // hexStringToColor("F6B915"),
            // hexStringToColor("4CB15F")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                // firebaseUIButton(context, "Sign Up", () {
                //   FirebaseAuth.instance
                //       .createUserWithEmailAndPassword(
                //           email: _emailTextController.text,
                //           password: _passwordTextController.text)
                //       .then((value) {
                //     print("Created New Account");
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => HomeScreen()));
                //   }).onError((error, stackTrace) {
                //     print("Error ${error.toString()}");
                //   });
                // })
              ],
            ),
          ))),
    );
  }
}
