import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';

import '../constants.dart';

///This is a function [showEditErrorPopUp] that calls [showDialog] built in function in flutter
///This is used for displayed a pop up to the user regarding editing or deleting
///It returns an [AlertDialog]

Future<dynamic> showEditErrorPopUp(BuildContext context, String editOrDelete) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResponsiveLayout(
          mobileBody: AlertDialog(
            title: Text(
              ' No $editOrDelete allowed ! ',
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
          ),
          tabletBody: AlertDialog(
            title: Text(
              ' No $editOrDelete allowed ! ',
              style: TextStyle(fontSize: 35, color: HapisColors.lgColor2),
            ),
            content: const Text(
                'There is a current donation in progress regarding this form',
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
          ),
        );
      });
}
