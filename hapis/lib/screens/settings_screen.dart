import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/services/LG_functionalities.dart';
import 'package:provider/provider.dart';

import '../providers/ssh_provider.dart';
import '../reusable_widgets/app_bar.dart';
import '../utils/drawer.dart';
import '../reusable_widgets/hapis_elevated_button.dart';
import '../reusable_widgets/sub_text.dart';
import '../utils/pop_up_connection.dart';

///The settings page is the main page for the LG Tasks which are: Clear KML, Reboot LG, Relaunch LG and Shut Down LG
///Each of them is a custom elevated button [HapisElevatedButton] and on pressed, we call the appropriate [LgService] functionality
///after getting the ssh client data from [SSHprovider] Class

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
                      height: MediaQuery.of(context).size.height * 0.2,
                      isPoly: false,
                      onpressed: () async {
                        /// retrieving the ssh data from the `ssh provider`
                        final sshData = Provider.of<SSHprovider>(
                          context,
                          listen: false,
                        );

                        ///checking the connection status first
                        if (sshData.client != null) {
                          /// calling `clear kml` from [LGService]
                          LgService(sshData).clearKml(keepLogos: false);
                        } else {
                          ///Showing error message
                          showDialogConnection(context);
                        }
                      }),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Relaunch LG',
                      buttonColor: HapisColors.lgColor2,
                      height: MediaQuery.of(context).size.height * 0.2,
                      isPoly: false,
                      onpressed: () async {
                        /// retrieving the ssh data from the `ssh provider`
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        ///checking the connection status first
                        if (sshData.client != null) {
                          /// calling `relaunch` from `LGService`
                          LgService(sshData).relaunch();
                        } else {
                          ///Showing error message
                          showDialogConnection(context);
                        }
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HapisElevatedButton(
                      elevatedButtonContent: 'Reboot LG',
                      buttonColor: HapisColors.lgColor3,
                      height: MediaQuery.of(context).size.height * 0.2,
                      isPoly: false,
                      onpressed: () async {
                        /// retrieving the ssh data from the `ssh provider`
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        ///checking the connection status first
                        if (sshData.client != null) {
                          /// calling `reboot` from `LGService`
                          LgService(sshData).reboot();
                        } else {
                          ///Showing error message
                          showDialogConnection(context);
                        }
                      }),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Shut Down LG',
                      buttonColor: HapisColors.lgColor1,
                      height: MediaQuery.of(context).size.height * 0.2,
                      isPoly: false,
                      onpressed: () async {
                        /// retrieving the ssh data from the `ssh provider`
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        ///checking the connection status first
                        if (sshData.client != null) {
                          /// calling `shutdown` from `LGService`
                          LgService(sshData).shutdown();
                        } else {
                          ///Showing error message
                          showDialogConnection(context);
                        }
                      }),
                ],
              ),
            ],
          ),
        ));
  }
}
