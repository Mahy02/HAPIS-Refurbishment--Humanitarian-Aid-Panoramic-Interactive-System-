import 'package:flutter/material.dart';

import '../constants.dart';

///This is a function [showDialogConnection] that calls [showDialog] built in function in flutter
///This is used for displayed a pop up to the user regarding the connection to the LG
///It returns an [AlertDialog]
///

Future<dynamic> showDialogConnection(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Not connected to LG !! ',
            style: TextStyle(fontSize: 30, color: HapisColors.lgColor2),
          ),
          content: const Text('Please connect to LG first.',
              style: TextStyle(fontSize: 25)),
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

