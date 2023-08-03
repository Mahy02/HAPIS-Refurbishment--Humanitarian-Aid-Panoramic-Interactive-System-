import 'package:flutter/material.dart';

import '../constants.dart';

///This is a function [showDatePopUp] that calls [showDialog] built in function in flutter
///This is used for displayed a pop up to the user regarding sign up
///It returns an [AlertDialog]

Future<dynamic> showEditErrorPopUp(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          ' No editing allowed ! ',
          style: TextStyle(fontSize: 20, color: HapisColors.lgColor2),
        ),
        content: const Text(
            'There is a current donation in progress regarding this form',
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
      );
    },
  );
}
