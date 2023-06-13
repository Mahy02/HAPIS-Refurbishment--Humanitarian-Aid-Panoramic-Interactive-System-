import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import '../reusable_widgets/app_bar.dart';
import '../reusable_widgets/hapis_elevated_button.dart';
import '../reusable_widgets/sub_text.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HAPISAppBar(
          appBarText: 'Settings',
        ),
        drawer: const Drawer(
            // Drawer content goes here
            ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SubText(subTextContent: 'LG Settings'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  HapisElevatedButton(
                      elevatedButtonContent: 'Clear KML',
                      buttonColor: HapisColors.lgColor1),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Relaunch LG',
                      buttonColor: HapisColors.lgColor2),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  HapisElevatedButton(
                      elevatedButtonContent: 'Reboot LG',
                      buttonColor: HapisColors.lgColor3),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Shut Down LG',
                      buttonColor: HapisColors.lgColor1),
                ],
              ),
            ],
          ),
        ));
  }
}
