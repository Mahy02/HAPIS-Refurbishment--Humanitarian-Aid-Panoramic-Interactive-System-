import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';

import '../constants.dart';
import '../screens/google_signup.dart';

///This is a function [showDialogSignUp] that calls [showDialog] built in function in flutter
///This is used for displayed a pop up to the user regarding sign up
///It returns an [AlertDialog]

Future<dynamic> showDialogSignUp(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ResponsiveLayout(
          mobileBody: AlertDialog(
            title: const Text(
              'You are not signed in to your account! ',
              style: TextStyle(fontSize: 20, color: HapisColors.lgColor2),
            ),
            content: const Text('Sign In now to enjoy HAPIS !',
                style: TextStyle(
                  fontSize: 18,
                )),
            actions: [
              TextButton(
                onPressed: () {
                  //  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GoogleSignUp()));
                },
                child: const Text('SIGN IN', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          tabletBody: AlertDialog(
            title: const Text(
              'You are not signed in to your account! ',
              style: TextStyle(fontSize: 35, color: HapisColors.lgColor2),
            ),
            content: const Text('Sign In now to enjoy HAPIS !',
                style: TextStyle(
                  fontSize: 28,
                )),
            actions: [
              TextButton(
                onPressed: () {
                  //  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GoogleSignUp()));
                },
                child: const Text('SIGN IN', style: TextStyle(fontSize: 28)),
              ),
            ],
          ));
    },
  );
}
