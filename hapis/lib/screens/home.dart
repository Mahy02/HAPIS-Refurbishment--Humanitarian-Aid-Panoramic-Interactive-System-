import 'package:flutter/material.dart';
import 'package:hapis/models/balloon_models/global_stats_model.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/screens/cities.dart';
import 'package:hapis/services/LG_balloon_services/global_balloon_service.dart';
import 'package:hapis/utils/drawer.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/kml/KMLModel.dart';
import '../models/kml/look_at_model.dart';
import '../models/kml/placemark_model.dart';
import '../providers/ssh_provider.dart';
import '../reusable_widgets/hapis_elevated_button.dart';
import '../reusable_widgets/sub_text.dart';
import '../services/LG_functionalities.dart';
import '../utils/pop_up_connection.dart';

///This is our Home page. It has 2 main buttons=> Global statistics and Cities

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlacemarkModel? _globePlacemark;

  /// Views a `globe stats` into the Google Earth.
  void _viewGlobeStats(GlobeModel globe, bool showBalloon, BuildContext context,
      {double orbitPeriod = 2.8, bool updatePosition = true}) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    print("here");
    final GlobalBalloonService globeService = GlobalBalloonService();
    print("inside view globe");

    final placemark = globeService.buildGlobalPlacemark(
      globe,
      showBalloon,
      orbitPeriod,
      lookAt: _globePlacemark != null && !updatePosition
          ? _globePlacemark!.lookAt
          : null,
      updatePosition: false,
    );
    //print(placemark.orbitTag);
    //print(placemark.lookAt);

    setState(() {
      _globePlacemark = placemark;
    });

    // LgService(sshData).clearKml();

    final kmlBalloon = KMLModel(
      name: 'HAPIS-Global-balloon',
      content: placemark.balloonOnlyTag,
    );

    await LgService(sshData).sendKMLToSlave(
      LgService(sshData).balloonScreen,
      kmlBalloon.body,
    );

    // if (updatePosition) {
    //   await LgService(sshData).flyTo(LookAtModel(
    //       longitude: 0,
    //       latitude: 0,
    //       range: '800000',
    //       tilt: '0',
    //       altitude: 30683.86,
    //       heading: '0'));
    // }
    final orbit = globeService.buildOrbit();
    await LgService(sshData).sendTour(orbit, 'Orbit');
    await LgService(sshData).startTour('Orbit');
  }

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
                      imageHeight: MediaQuery.of(context).size.height * 0.25,
                      imageWidth: MediaQuery.of(context).size.height * 0.25,
                      isPoly: false,
                      onpressed: () {
                        //will show bubble on LG
                        ///TO DO:
                        int numberOfSeekers = 30;
                        int numberOfGivers = 20;

                        int inProgressDonations = 4;
                        int successfulDonations = 2;
                        List<String> topThreeCategories = [
                          'Food',
                          'Clothing',
                          'Pet supplies'
                        ];
                        List<String> topThreeCities = [
                          'Cairo',
                          'Tokyo',
                          'llieda'
                        ];
                        // int numberOfSeekers =
                        //     globeDBServices().getNumberOfSeekers();
                        // int numberOfGivers =
                        //     globeDBServices().getNumberOfGivers();

                        // int inProgressDonations =
                        //     globeDBServices().getNumberOfInProgressDonations();
                        // int successfulDonations =
                        //     globeDBServices().getNumberOfSuccessfulDonations();
                        // List<String> topThreeCategories =
                        //     globeDBServices().getTopDonatedCategories();
                        // List<String> topThreeCities =
                        //     globeDBServices().getTopDonatedCategories();
                        print(numberOfSeekers);

                        GlobeModel globe = GlobeModel(
                            id: '4',
                            numberOfSeekers: numberOfSeekers,
                            numberOfGivers: numberOfGivers,
                            inProgressDonations: inProgressDonations,
                            successfulDonations: successfulDonations,
                            topThreeCategories: topThreeCategories,
                            topThreeCities: topThreeCities);

                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);
                        print("inside globe on pressed ");

                        if (sshData.client != null) {
                          print(sshData.client!.username);

                          print("here");
                          _viewGlobeStats(globe, true, context);
                        } else {
                          showDialogConnection(context);
                        }
                      }),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Cities',
                      buttonColor: HapisColors.lgColor3,
                      height: MediaQuery.of(context).size.height * 0.4,
                      imagePath: 'assets/images/architecture-and-city.png',
                      imageHeight: MediaQuery.of(context).size.height * 0.25,
                      imageWidth: MediaQuery.of(context).size.height * 0.25,
                      isPoly: false,
                      onpressed: () {
                        //will show cities
                        ///TO DO:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CitiesPage()));
                      }),
                ],
              ),
            ),
            /////////////////JUST FOR TESTING, WILL NOT BE IN MAIN UI
            SizedBox(
              height: 40,
            ),
            // HapisElevatedButton(
            //     elevatedButtonContent:
            //         'Test fly to  (button will be removed later)',
            //     buttonColor: HapisColors.lgColor4,
            //     height: MediaQuery.of(context).size.height * 0.2,
            //     imageHeight: MediaQuery.of(context).size.height * 0.25,
            //     imageWidth: MediaQuery.of(context).size.height * 0.25,
            //     isPoly: false,
            //     onpressed: () async {
            //       final sshData =
            //           Provider.of<SSHprovider>(context, listen: false);
            //       print("here");
            //       if (sshData.client != null) {
            //         print(sshData.client!.username);

            //         print("here");
            //         LgService(sshData).flyTo(LookAtModel(
            //             longitude: -74.0060,
            //             latitude: 40.7128,
            //             altitude: 0,
            //             range: '1492.66.0',
            //             tilt: '45',
            //             heading: '0'));
            //       } else {
            //         showDialogConnection(context);
            //       }
            //     }),
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
