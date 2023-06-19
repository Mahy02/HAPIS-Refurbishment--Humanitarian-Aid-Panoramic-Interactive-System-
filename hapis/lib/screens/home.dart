import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/utils/drawer.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/kml/look_at_model.dart';
import '../providers/ssh_provider.dart';
import '../reusable_widgets/hapis_elevated_button.dart';
import '../reusable_widgets/sub_text.dart';
import '../services/LG_functionalities.dart';
import '../utils/pop_up_connection.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(appBarText: ''),
      drawer: buildDrawer(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 100.0, left: 80),
                  child: SubText(subTextContent: 'Welcome to HAPIS !'),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HapisElevatedButton(
                      elevatedButtonContent: 'Global Statistics',
                      buttonColor: HapisColors.lgColor1,
                      height: MediaQuery.of(context).size.height * 0.4,
                      imagePath: 'assets/images/growth.png',
                      onpressed: () {
                        //will show bubble on LG
                        ///TO DO:
                      }),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Cities',
                      buttonColor: HapisColors.lgColor3,
                      height: MediaQuery.of(context).size.height * 0.4,
                      imagePath: 'assets/images/architecture-and-city.png',
                      onpressed: () {
                        //will show cities
                        ///TO DO:
                      }),
                ],
              ),
            ),
            /////////////////JUST FOR TESTING, WILL NOT BE IN MAIN UI
            SizedBox(
              height: 40,
            ),
            HapisElevatedButton(
                elevatedButtonContent:
                    'Test fly to  (button will be removed later)',
                buttonColor: HapisColors.lgColor4,
                height: MediaQuery.of(context).size.height * 0.2,
                onpressed: () async {
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);
                  print("here");
                  if (sshData.client != null) {
                    print(sshData.client!.username);

                    print("here");
                    LgService(sshData).flyTo(LookAtModel(
                        longitude: -74.0060,
                        latitude: 40.7128,
                        altitude: 0,
                        range: '1492.66.0',
                        tilt: '45',
                        heading: '0'));
                  } else {
                    showDialogConnection(context);
                  }
                }),
            SizedBox(
              height: 40,
            ),
            // HapisElevatedButton(
            //     elevatedButtonContent:
            //         'Test orbit (button will be removed later)',
            //     buttonColor: HapisColors.lgColor4,
            //     height: MediaQuery.of(context).size.height * 0.2,
            //     onpressed: () {
            //       //testing orbit
            //     }),
            // SizedBox(
            //   height: 40,
            // ),
          ],
        ),
      ),
    );
  }
}
