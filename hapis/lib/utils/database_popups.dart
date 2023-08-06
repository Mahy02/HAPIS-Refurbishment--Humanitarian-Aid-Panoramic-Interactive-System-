import 'package:flutter/material.dart';

import '../constants.dart';

///This is a function [showDatabasePopup] that calls [showDialog] built in function in flutter
///This is used for displayed a pop up to the user regarding sign up
///It returns an [AlertDialog]

Future<dynamic> showDatabasePopup(BuildContext context, String db_error,
    {bool isError = true,
    bool isWarning = false,
    Function()? onOKPressed,
    bool isCancel = false}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: isError
            ? const Text(
                'Error ! ',
                style: TextStyle(fontSize: 20, color: HapisColors.lgColor2),
              )
            : isWarning
                ? Text(
                    'Warning ! ',
                    style: TextStyle(fontSize: 20, color: HapisColors.lgColor3),
                  )
                : Text(
                    'Info ! ',
                    style: TextStyle(fontSize: 20, color: HapisColors.lgColor4),
                  ),
        content: Text(db_error,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //navigate if exists
              if (onOKPressed != null) {
                onOKPressed(); // Call the custom function if provided
              }
            },
            child: const Text('OK', style: TextStyle(fontSize: 18)),
          ),
          if (isCancel)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('SKIP',
                  style: TextStyle(fontSize: 18, color: HapisColors.lgColor2)),
            ),
        ],
      );
    },
  );
}
