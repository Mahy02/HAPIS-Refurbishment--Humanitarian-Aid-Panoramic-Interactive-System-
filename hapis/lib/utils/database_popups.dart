import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';

import '../constants.dart';

/// Display a dialog box to show database-related messages to the user.
/// The appearance of the dialog varies based on screen size and message type.
/// Returns a Future<dynamic> that resolves when the dialog is dismissed.
/// 
Future<dynamic> showDatabasePopup(BuildContext context, String db_error,
    {bool isError = true,
    bool isWarning = false,
    Function()? onOKPressed,
    bool isCancel = false}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ResponsiveLayout(
        mobileBody: AlertDialog(
          title: isError
              ? const Text(
                  'Error ! ',
                  style: TextStyle(fontSize: 20, color: HapisColors.lgColor2),
                )
              : isWarning
                  ? Text(
                      'Warning ! ',
                      style:
                          TextStyle(fontSize: 20, color: HapisColors.lgColor3),
                    )
                  : Text(
                      'Info ! ',
                      style:
                          TextStyle(fontSize: 20, color: HapisColors.lgColor4),
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
                    style:
                        TextStyle(fontSize: 18, color: HapisColors.lgColor2)),
              ),
          ],
        ),
        tabletBody: AlertDialog(
          title: isError
              ? const Text(
                  'Error ! ',
                  style: TextStyle(fontSize: 40, color: HapisColors.lgColor2),
                )
              : isWarning
                  ? Text(
                      'Warning ! ',
                      style:
                          TextStyle(fontSize: 40, color: HapisColors.lgColor3),
                    )
                  : Text(
                      'Info ! ',
                      style:
                          TextStyle(fontSize: 40, color: HapisColors.lgColor4),
                    ),
          content: Text(db_error,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 28,
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
              child: const Text('OK', style: TextStyle(fontSize: 28)),
            ),
            if (isCancel)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('SKIP',
                    style:
                        TextStyle(fontSize: 28, color: HapisColors.lgColor2)),
              ),
          ],
        ),
      );
    },
  );
}
