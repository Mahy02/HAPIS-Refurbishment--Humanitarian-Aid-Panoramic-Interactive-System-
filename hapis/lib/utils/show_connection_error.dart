import 'package:flutter/material.dart';

import '../constants.dart';

///This is a function [showConnectionError] that calls [showDialog] built in function in flutter
///This is used for displayed a pop up to the user regarding the connection to the LG
///It returns an [AlertDialog]
///

Future<dynamic> showConnectionError(BuildContext context, String errorMessage) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Not connected to LG !! ',
            style: TextStyle(fontSize: 30, color: HapisColors.lgColor2),
          ),
          content:  Text( errorMessage,
              style: const TextStyle(fontSize: 25)),
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

