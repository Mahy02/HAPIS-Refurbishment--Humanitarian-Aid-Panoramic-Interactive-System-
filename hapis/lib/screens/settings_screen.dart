import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/services/LG_functionalities.dart';
import 'package:provider/provider.dart';
import '../models/kml/look_at_model.dart';
import '../providers/ssh_provider.dart';
import '../reusable_widgets/app_bar.dart';
import '../reusable_widgets/drawer.dart';
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
        drawer: Drawer(
            // Drawer content goes here
            child: buildDrawer(context)),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SubText(subTextContent: 'LG Settings'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HapisElevatedButton(
                      elevatedButtonContent: 'Clear KML',
                      buttonColor: HapisColors.lgColor1,
                      onpressed: () {
                        //for now we woul d just try the fly to function
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);
                        print("inside clear KML ");
                        print(sshData.client.username);
                        LgService(sshData).flyTo(LookAtModel(
                            longitude: -74.0060,
                            latitude: 40.7128,
                            altitude: 0,
                            range: '1492.66.0',
                            tilt: '45',
                            heading: '0'));
                      }),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Relaunch LG',
                      buttonColor: HapisColors.lgColor2,
                      onpressed: () {
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);
                        print("inside relaunch ");
                        print(sshData.client.username);
                        LgService(sshData).relaunch();
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HapisElevatedButton(
                      elevatedButtonContent: 'Reboot LG',
                      buttonColor: HapisColors.lgColor3,
                      onpressed: () {
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);
                        print("inside rebootr ");
                        print(sshData.client.username);
                        LgService(sshData).reboot();
                      }),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Shut Down LG',
                      buttonColor: HapisColors.lgColor1,
                      onpressed: () {
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);
                        print("inside shut down ");
                        print(sshData.client.username);
                        LgService(sshData).shutdown();
                      }),
                ],
              ),
            ],
          ),
        ));
  }
}
