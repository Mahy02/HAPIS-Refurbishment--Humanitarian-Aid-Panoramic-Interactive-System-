import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
import '../services/db_services/global_db_services.dart';
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

    try{
    await LgService(sshData).clearKml();
     } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    final kmlBalloon = KMLModel(
      name: 'HAPIS-Global-balloon',
      content: placemark.balloonOnlyTag,
    );
     
     try{
    await LgService(sshData).sendKMLToSlave(
      LgService(sshData).balloonScreen,
      kmlBalloon.body,
    );
     } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    if (updatePosition) {
      await LgService(sshData).flyTo(LookAtModel(
        longitude: -45.4518936,
        latitude: 0.0000101,
        // range: '90000000000',
        range: '31231212.86',
        //tilt: '0',
        tilt: '0',
        //altitude: 0,
        //altitude: 25540.1097385,
        altitude: 50000.1097385,
        heading: '0',
        altitudeMode: 'relativeToSeaFloor',
      ));
    }
    final orbit = globeService.buildOrbit();
    //await LgService(sshData).clearKml();

    try {
      await LgService(sshData).sendTour(orbit, 'Orbit');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    //await LgService(sshData).startTour('Orbit');
    // print("end of global function");
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
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, left: 80, right: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SubText(subTextContent: 'Welcome to HAPIS !'),
                      Column(
                        children: [
                          GestureDetector(
                            child: Image.asset(
                              'assets/images/orbit.png',
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            onTap: () async {
                              final sshData = Provider.of<SSHprovider>(context,
                                  listen: false);

                              if (sshData.client != null) {
                                try {
                                  await LgService(sshData).startTour('Orbit');
                                  print("awaiting orbit");
                                } catch (e) {
                                  // ignore: avoid_print
                                  print(e);
                                }
                              } else {
                                showDialogConnection(context);
                              }
                            },
                          ),
                          Text(' Orbit ',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ))
                        ],
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
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
                      onpressed: () async {
                        //will show bubble on LG
                        ///TO DO:

                        int numberOfSeekers =
                            await globalDBServices().getNumberOfSeekers();
                        int numberOfGivers =
                            await globalDBServices().getNumberOfGivers();

                        int inProgressDonations = await globalDBServices()
                            .getNumberOfInProgressDonations();
                        int successfulDonations = await globalDBServices()
                            .getNumberOfSuccessfulDonations();
                        List<String> topThreeCategories =
                            await globalDBServices().getTopDonatedCategories();
                        List<String> topThreeCities =
                            await globalDBServices().getTopCities();

                        print("number of seekers: $numberOfSeekers");
                        print("number of givers: $numberOfGivers");
                        print("in progress donations: $inProgressDonations");
                        print("succ donations: $successfulDonations");
                        print("top 3 cat: $topThreeCategories");
                        print("top 3 cities: $topThreeCities");

                        GlobeModel globe = GlobeModel(
                            id: 'Globe',
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
            //         'Test orbit (button will be removed later)',
            //     buttonColor: HapisColors.lgColor4,
            //     height: MediaQuery.of(context).size.height * 0.2,
            //     imageHeight: MediaQuery.of(context).size.height * 0.25,
            //     imageWidth: MediaQuery.of(context).size.height * 0.25,
            //     isPoly: false,
            //     onpressed: () async {
            //       final sshData =
            //           Provider.of<SSHprovider>(context, listen: false);

            //       if (sshData.client != null) {
            //         try {
            //           await LgService(sshData).startTour('Orbit');
            //           print("awaiting orbit");
            //         } catch (e) {
            //           // ignore: avoid_print
            //           print(e);
            //         }

            //       } else {
            //         showDialogConnection(context);
            //       }
            //     }),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
