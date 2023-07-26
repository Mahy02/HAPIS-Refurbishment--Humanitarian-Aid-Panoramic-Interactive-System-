import 'package:flutter/material.dart';
import 'package:hapis/screens/sign_up_page.dart';

import '../constants.dart';
import '../screens/google_signup.dart';

///This is a function [showDialogConnection] that calls [showDialog] built in function in flutter
///This is used for displayed a pop up to the user regarding sign up
///It returns an [AlertDialog]
///

Future<dynamic> showDialogSignUp(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
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
      );
    },
  );
}
