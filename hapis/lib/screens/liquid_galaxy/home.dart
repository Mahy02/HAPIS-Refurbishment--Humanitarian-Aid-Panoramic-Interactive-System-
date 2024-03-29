import 'package:flutter/material.dart';

import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/screens/liquid_galaxy/cities.dart';
import 'package:hapis/services/liquid_galaxy/tour_services.dart';

import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/liquid_galaxy/balloon_models/global_stats_model.dart';
import '../../models/liquid_galaxy/kml/KMLModel.dart';
import '../../models/liquid_galaxy/kml/look_at_model.dart';
import '../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../providers/liquid_galaxy/connection_provider.dart';
import '../../providers/liquid_galaxy/ssh_provider.dart';
import '../../responsive/responsive_layout.dart';
import '../../reusable_widgets/back_button.dart';
import '../../reusable_widgets/hapis_elevated_button.dart';
import '../../reusable_widgets/liquid_galaxy/connection_indicator.dart';
import '../../reusable_widgets/sub_text.dart';
import '../../services/db_services/global_db_services.dart';
import '../../services/liquid_galaxy/LG_placemarks_services/global_balloon_service.dart';
import '../../services/liquid_galaxy/LG_functionalities.dart';
import '../../utils/drawer.dart';
import '../../utils/pop_up_connection.dart';

///This is our Home page. It has 2 main buttons=> Global statistics and Cities from the custom [HapisElevatedButton]

class LgHomePage extends StatefulWidget {
  const LgHomePage({super.key});

  @override
  State<LgHomePage> createState() => _LgHomePageState();
}

class _LgHomePageState extends State<LgHomePage> {
  ///  `_globePlacemark` to define the city placemark for orbiting, balloons
  PlacemarkModel? _globePlacemark;

  /// Views a `global stats` into the Google Earth in a Balloon and Fly to the city.
  void _viewGlobeStats(GlobeModel globe, bool showBalloon, BuildContext context,
      {double orbitPeriod = 2.8, bool updatePosition = true}) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    final GlobalBalloonService globeService = GlobalBalloonService();

    /// calling the `buildGlobalPlacemark` that returns the `globe placemark`
    final placemark = globeService.buildGlobalPlacemark(
      globe,
      showBalloon,
      orbitPeriod,
      lookAt: _globePlacemark != null && !updatePosition
          ? _globePlacemark!.lookAt
          : null,
      updatePosition: false,
    );

    setState(() {
      _globePlacemark = placemark;
    });

    try {
      await LgService(sshData).clearKml();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    /// defining the `kml balloon` content and name
    final kmlBalloon = KMLModel(
      name: 'HAPIS-Global-balloon',
      content: placemark.balloonOnlyTag,
    );

    //await Future.delayed(Duration(seconds: 3));

    try {
      /// sending kml to slave where we send to `balloon screen` and send the `kml balloon ` body
      await LgService(sshData).sendKMLToSlave(
        LgService(sshData).balloonScreen,
        kmlBalloon.body,
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    ///  `updating postion` to fly to certain city
    if (updatePosition) {
      await LgService(sshData).flyTo(LookAtModel(
        longitude: -45.4518936,
        latitude: 0.0000101,
        range: '31231212.86',
        tilt: '0',
        altitude: 50000.1097385,
        heading: '0',
        altitudeMode: 'relativeToSeaFloor',
      ));
    }

    await Future.delayed(Duration(seconds: 3));

    ///building the orbit
    final orbit = globeService.buildOrbit();

    try {
      ///Sending Tour with `orbit details` where the tour would be `Orbit`
      await LgService(sshData).sendTour(orbit, 'Orbit');
      await Future.delayed(Duration(seconds: 5));
      await LgService(sshData).startTour('Orbit');
      await Future.delayed(Duration(seconds: 20));
      await LgService(sshData).stopTour();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  bool isLoadingGlobalStats = false;
  bool isLoadingHAPISTour = false;
  bool isLoadingCity = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(
        appBarText: '',
        isLg: true,
      ),
      drawer: ResponsiveLayout(
          mobileBody: buildDrawer(context, true, 18, 16),
          tabletBody: buildDrawer(context, true, 24, 20)),
      backgroundColor: Colors.white,
      body: ResponsiveLayout(
        mobileBody: buildMobileLayout(context),
        tabletBody: buildTabletLayout(context),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          BackButtonWidget(
            isTablet: false,
          ),
          ConnectionIndicator(
            isConnected: connection.isConnected,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SubText(
                      subTextContent: 'Welcome to HAPIS !',
                      fontSize: 20,
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            // padding: EdgeInsets.only(top: screenSize.height * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HapisElevatedButton(
                    //elevatedButtonContent: 'Global Statistics',
                    elevatedButtonContent: isLoadingGlobalStats
                        ? 'Loading...'
                        : 'Global Statistics',
                    isLoading: isLoadingGlobalStats,
                    buttonColor: HapisColors.lgColor1,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.65,
                    imagePath: 'assets/images/growth.png',
                    imageHeight: MediaQuery.of(context).size.height * 0.1,
                    imageWidth: MediaQuery.of(context).size.height * 0.1,
                    fontSize: 20,
                    isPoly: false,
                    onpressed: () async {
                      setState(() {
                        isLoadingGlobalStats = true;
                      });

                      /// retrieving all globe data from the database
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

                      ///defining a new globe instance for `GlobeModel`` with all the retrieved data from the database
                      GlobeModel globe = GlobeModel(
                          id: 'Globe',
                          numberOfSeekers: numberOfSeekers,
                          numberOfGivers: numberOfGivers,
                          inProgressDonations: inProgressDonations,
                          successfulDonations: successfulDonations,
                          topThreeCategories: topThreeCategories,
                          topThreeCities: topThreeCities);

                      setState(() {
                        isLoadingGlobalStats = false;
                      });
                      final sshData =
                          // ignore: use_build_context_synchronously
                          Provider.of<SSHprovider>(context, listen: false);

                      if (sshData.client != null) {
                        // ignore: use_build_context_synchronously
                        _viewGlobeStats(globe, true, context);

                        //TourService.viewGlobe(globe, true, context);
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialogConnection(context);
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    HapisElevatedButton(
                        isLoading: isLoadingCity,
                        elevatedButtonContent: 'Cities',
                        buttonColor: HapisColors.lgColor3,
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.65,
                        imagePath: 'assets/images/architecture-and-city.png',
                        imageHeight: MediaQuery.of(context).size.height * 0.1,
                        imageWidth: MediaQuery.of(context).size.height * 0.1,
                        fontSize: 20,
                        isPoly: false,
                        onpressed: () async {
                          // setState(() {
                          //   isLoadingCity = true;
                          // });

                          // // Perform any necessary loading or asynchronous tasks
                          // await Future.delayed(Duration(seconds: 5));

                          // // Hide the loading indicator and navigate to the new page
                          // setState(() {
                          //   isLoadingCity = false;
                          // });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CitiesPage()));
                        }),
                    if (isLoadingCity)
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors
                              .white, // Customize the color of the indicator
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                HapisElevatedButton(
                    isLoading: isLoadingHAPISTour,
                    elevatedButtonContent:
                        isLoadingHAPISTour ? 'Loading...' : 'HAPIS Tour',
                    // elevatedButtonContent: 'HAPIS Tour',
                    buttonColor: HapisColors.lgColor2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.65,
                    imagePath: 'assets/images/earth.png',
                    imageHeight: MediaQuery.of(context).size.height * 0.1,
                    imageWidth: MediaQuery.of(context).size.height * 0.1,
                    fontSize: 20,
                    isPoly: false,
                    onpressed: () async {
                      //TourService().tourKML;
                      setState(() {
                        isLoadingHAPISTour = true;
                      });
                      print('tourr');
                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      if (sshData.client != null) {
                        try {
                          await LgService(sshData).clearKml();
                          String tourKmlContent =
                              await TourService().generateTourKMLContent();
                          setState(() {
                            isLoadingHAPISTour = false;
                          });
                          await LgService(sshData)
                              .sendTour(tourKmlContent, 'Hapis-Tour');
                        } catch (e) {
                          // ignore: avoid_print
                          print(e);
                        }
                      } else {
                        setState(() {
                          isLoadingHAPISTour = false;
                        });
                        showDialogConnection(context);
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: HapisColors.lgColor4,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: GestureDetector(
                        child: Icon(
                          Icons.play_arrow,
                          size: 30,
                          color: HapisColors.lgColor1,
                        ),
                        onTap: () async {
                          final sshData =
                              Provider.of<SSHprovider>(context, listen: false);

                          if (sshData.client != null) {
                            try {
                              await LgService(sshData).startTour('Hapis-Tour');
                            } catch (e) {
                              // ignore: avoid_print
                              print(e);
                            }
                          } else {
                            showDialogConnection(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: HapisColors.lgColor2,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: GestureDetector(
                        child: Icon(
                          Icons.pause_circle,
                          size: 30,
                          color: HapisColors.lgColor1,
                        ),
                        onTap: () async {
                          final sshData =
                              Provider.of<SSHprovider>(context, listen: false);

                          if (sshData.client != null) {
                            try {
                              await LgService(sshData).stopTour();
                            } catch (e) {
                              // ignore: avoid_print
                              print(e);
                            }
                          } else {
                            showDialogConnection(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          BackButtonWidget(
            isTablet: true,
          ),
          ConnectionIndicator(
            isConnected: connection.isConnected,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 80, right: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SubText(
                      subTextContent: 'Welcome to HAPIS !',
                      fontSize: 35,
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            // padding: EdgeInsets.only(top: screenSize.height * 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HapisElevatedButton(
                    isLoading: isLoadingGlobalStats,
                    elevatedButtonContent: isLoadingGlobalStats
                        ? 'Loading...'
                        : 'Global Statistics',
                    //elevatedButtonContent: 'Global Statistics',
                    buttonColor: HapisColors.lgColor1,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.3,
                    imagePath: 'assets/images/growth.png',
                    imageHeight: MediaQuery.of(context).size.height * 0.2,
                    imageWidth: MediaQuery.of(context).size.height * 0.2,
                    fontSize: 35,
                    isPoly: false,
                    onpressed: () async {
                      setState(() {
                        isLoadingGlobalStats = true;
                      });

                      /// retrieving all globe data from the database
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

                      ///defining a new globe instance for `GlobeModel`` with all the retrieved data from the database
                      GlobeModel globe = GlobeModel(
                          id: 'Globe',
                          numberOfSeekers: numberOfSeekers,
                          numberOfGivers: numberOfGivers,
                          inProgressDonations: inProgressDonations,
                          successfulDonations: successfulDonations,
                          topThreeCategories: topThreeCategories,
                          topThreeCities: topThreeCities);

                      setState(() {
                        isLoadingGlobalStats = false;
                      });

                      final sshData =
                          // ignore: use_build_context_synchronously
                          Provider.of<SSHprovider>(context, listen: false);

                      if (sshData.client != null) {
                        // ignore: use_build_context_synchronously
                        _viewGlobeStats(globe, true, context);

                        //TourService.viewGlobe(globe, true, context);
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialogConnection(context);
                      }
                    }),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    HapisElevatedButton(
                        isLoading: isLoadingCity,
                        elevatedButtonContent: 'Cities',
                        buttonColor: HapisColors.lgColor3,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.3,
                        imagePath: 'assets/images/architecture-and-city.png',
                        imageHeight: MediaQuery.of(context).size.height * 0.2,
                        imageWidth: MediaQuery.of(context).size.height * 0.2,
                        fontSize: 35,
                        isPoly: false,
                        onpressed: () async {
                          setState(() {
                            isLoadingCity = true;
                          });

                          // Perform any necessary loading or asynchronous tasks
                          await Future.delayed(Duration(seconds: 5));

                          // Hide the loading indicator and navigate to the new page
                          setState(() {
                            isLoadingCity = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CitiesPage()));
                        }),
                    if (isLoadingCity)
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors
                              .white, // Customize the color of the indicator
                        ),
                      ),
                  ],
                ),
                HapisElevatedButton(
                    isLoading: isLoadingHAPISTour,
                    elevatedButtonContent:
                        isLoadingHAPISTour ? 'Loading...' : 'HAPIS Tour',
                    //elevatedButtonContent: 'HAPIS Tour',
                    buttonColor: HapisColors.lgColor2,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.3,
                    imagePath: 'assets/images/earth.png',
                    imageHeight: MediaQuery.of(context).size.height * 0.2,
                    imageWidth: MediaQuery.of(context).size.height * 0.2,
                    fontSize: 35,
                    isPoly: false,
                    onpressed: () async {
                      //TourService().tourKML;

                      setState(() {
                        isLoadingHAPISTour = true;
                      });

                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      if (sshData.client != null) {
                        try {
                          await LgService(sshData).clearKml();
                          String tourKmlContent =
                              await TourService().generateTourKMLContent();
                          setState(() {
                            isLoadingHAPISTour = false;
                          });
                          await LgService(sshData)
                              .sendTour(tourKmlContent, 'Hapis-Tour');
                        } catch (e) {
                          // ignore: avoid_print
                          print(e);
                        }
                      } else {
                        setState(() {
                          isLoadingHAPISTour = false;
                        });
                        showDialogConnection(context);
                      }
                    }),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: HapisColors.lgColor4,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: GestureDetector(
                    child: Icon(
                      Icons.play_arrow,
                      size: 80,
                      color: HapisColors.lgColor1,
                    ),
                    onTap: () async {
                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      if (sshData.client != null) {
                        try {
                          await LgService(sshData).stopTour();
                          await LgService(sshData).startTour('Hapis-Tour');
                        } catch (e) {
                          // ignore: avoid_print
                          print(e);
                        }
                      } else {
                        showDialogConnection(context);
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: HapisColors.lgColor2,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: GestureDetector(
                    child: Icon(
                      Icons.pause_circle,
                      size: 80,
                      color: HapisColors.lgColor1,
                    ),
                    onTap: () async {
                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      if (sshData.client != null) {
                        try {
                          await LgService(sshData).stopTour();
                        } catch (e) {
                          // ignore: avoid_print
                          print(e);
                        }
                      } else {
                        showDialogConnection(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
