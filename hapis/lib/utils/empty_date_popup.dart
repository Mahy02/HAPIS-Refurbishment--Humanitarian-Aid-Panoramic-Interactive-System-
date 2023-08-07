import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';

import '../constants.dart';

///This is a function [showDatePopUp] that calls [showDialog] built in function in flutter
///This is used for displayed a pop up to the user regarding sign up
///It returns an [AlertDialog]

Future<dynamic> showDatePopUp(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ResponsiveLayout(
          mobileBody: AlertDialog(
            title: const Text(
              'You haven\'t chosen any dates! ',
              style: TextStyle(fontSize: 20, color: HapisColors.lgColor2),
            ),
            content: const Text('Choose your preferred dates !',
                style: TextStyle(
                  fontSize: 18,
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          tabletBody: AlertDialog(
            title: const Text(
              'You haven\'t chosen any dates! ',
              style: TextStyle(fontSize: 35, color: HapisColors.lgColor2),
            ),
            content: const Text('Choose your preferred dates !',
                style: TextStyle(
                  fontSize: 28,
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK', style: TextStyle(fontSize: 28)),
              ),
            ],
          ));
    },
  );
}
