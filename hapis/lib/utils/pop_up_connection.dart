import 'package:flutter/material.dart';

import '../constants.dart';

Future<dynamic> showDialogConnection(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Not connected to LG !! ',
            style: TextStyle(fontSize: 30, color: HapisColors.lgColor2),
          ),
          content: Text('Please connect to LG first.',
              style: TextStyle(fontSize: 25)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK', style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

