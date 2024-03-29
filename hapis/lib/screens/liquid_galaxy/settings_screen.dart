import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/liquid_galaxy/connection_indicator.dart';
import 'package:provider/provider.dart';

import '../../providers/liquid_galaxy/connection_provider.dart';
import '../../providers/liquid_galaxy/ssh_provider.dart';
import '../../reusable_widgets/app_bar.dart';
import '../../reusable_widgets/back_button.dart';
import '../../reusable_widgets/hapis_elevated_button.dart';
import '../../reusable_widgets/sub_text.dart';
import '../../services/liquid_galaxy/LG_functionalities.dart';
import '../../utils/drawer.dart';
import '../../utils/pop_up_connection.dart';

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
          isLg: true,
        ),
        drawer: Drawer(
            // Drawer content goes here
            child: ResponsiveLayout(
                mobileBody: buildDrawer(context, true, 18, 16),
                tabletBody: buildDrawer(context, true, 24, 20))),
        body: ResponsiveLayout(
          mobileBody: buildMobileLayout(context),
          tabletBody: buildTabletLayout(context),
        ));
  }

  Widget buildMobileLayout(BuildContext context) {
    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BackButtonWidget(
          isTablet: false,
        ),
        ConnectionIndicator(isConnected: connection.isConnected),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 30),
          child: const SubText(
            subTextContent: 'LG Settings',
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HapisElevatedButton(
                isLoading: false,
                fontSize: 20,
                elevatedButtonContent: 'Clear KML',
                buttonColor: HapisColors.lgColor1,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.4,
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
                isLoading: false,
                fontSize: 20,
                elevatedButtonContent: 'Relaunch LG',
                buttonColor: HapisColors.lgColor2,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.4,
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HapisElevatedButton(
                isLoading: false,
                elevatedButtonContent: 'Reboot LG',
                buttonColor: HapisColors.lgColor3,
                height: MediaQuery.of(context).size.height * 0.2,
                fontSize: 20,
                width: MediaQuery.of(context).size.width * 0.4,
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
                isLoading: false,
                elevatedButtonContent: 'ShutDown LG',
                buttonColor: HapisColors.lgColor1,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.4,
                fontSize: 20,
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
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BackButtonWidget(
            isTablet: true,
          ),
          ConnectionIndicator(isConnected: connection.isConnected),
          const SubText(
            subTextContent: 'LG Settings',
            fontSize: 35,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HapisElevatedButton(
                  isLoading: false,
                  fontSize: 35,
                  elevatedButtonContent: 'Clear KML',
                  buttonColor: HapisColors.lgColor1,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
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
                  isLoading: false,
                  fontSize: 35,
                  elevatedButtonContent: 'Relaunch LG',
                  buttonColor: HapisColors.lgColor2,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HapisElevatedButton(
                  isLoading: false,
                  elevatedButtonContent: 'Reboot LG',
                  buttonColor: HapisColors.lgColor3,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fontSize: 35,
                  width: MediaQuery.of(context).size.width * 0.4,
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
                  isLoading: false,
                  elevatedButtonContent: 'Shut Down LG',
                  buttonColor: HapisColors.lgColor1,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
                  fontSize: 35,
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
    );
  }
}
