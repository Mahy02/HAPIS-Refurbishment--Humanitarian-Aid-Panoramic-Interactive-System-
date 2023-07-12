import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/screens/liquid_galaxy/seekers.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/db_models/users_model.dart';
import '../../models/liquid_galaxy/kml/KMLModel.dart';
import '../../models/liquid_galaxy/kml/look_at_model.dart';
import '../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../providers/liquid_galaxy/ssh_provider.dart';
import '../../providers/users_provider.dart';
import '../../reusable_widgets/app_bar.dart';
import '../../reusable_widgets/hapis_elevated_button.dart';
import '../../reusable_widgets/sub_text.dart';
import '../../services/liquid_galaxy/LG_balloon_services/city_balloon_service.dart';
import '../../services/liquid_galaxy/LG_balloon_services/users_pins_services.dart';
import '../../services/liquid_galaxy/LG_functionalities.dart';
import '../../utils/drawer.dart';
import 'givers.dart';

///This is the `users` class in a certain given `city` as input to the widget
///It consists of 2 buttons, `seekers` and `givers` from the [HapisElevatedButton] custom widget with an image provided

class Users extends StatefulWidget {
  final String city;
  const Users({super.key, required this.city});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  ///  `donors placemark` to define the donors placemark

  PlacemarkModel? _donorsPlacemark;

  PlacemarkModel? _seekersPlacemark;

  /// Views  `users pins` into the Google Earth
  void _viewPins(
      List<UsersModel> donors, List<UsersModel> seekers, BuildContext context,
      {double orbitPeriod = 2.8, bool updatePosition = true}) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    final UsersPinsService usersPinService = UsersPinsService();

    /// calling the `buildDonorsPlacemark` that returns the `donors placemark`
    final donorsPlacemarks = usersPinService.buildDonorsPlacemark(
      donors,
      orbitPeriod,
      lookAt: _donorsPlacemark != null && !updatePosition
          ? _donorsPlacemark!.lookAt
          : null,
      updatePosition: updatePosition,
    );

    for (PlacemarkModel placemark in donorsPlacemarks) {
      /// sending kml to slave where we send the `kml placemark`
      final kmlPlacemark = KMLModel(
        name: 'HAPIS-Donors-pin-${placemark.id}',
        content: placemark.pinOnlyTag,
      );

      try {
        await LgService(sshData)
            .sendKmlPins(kmlPlacemark.body, kmlPlacemark.name);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    /// calling the `buildSeekersPlacemark` that returns the `seeker placemark`
    final seekersPlacemarks = usersPinService.buildSeekersPlacemark(
      seekers,
      orbitPeriod,
      lookAt: _seekersPlacemark != null && !updatePosition
          ? _seekersPlacemark!.lookAt
          : null,
      updatePosition: updatePosition,
    );

    for (PlacemarkModel placemark in seekersPlacemarks) {
      /// sending kml to slave where we send the `kml placemark`
      final kmlPlacemark = KMLModel(
        name: 'HAPIS-Seekers-pin-${placemark.id}',
        content: placemark.pinOnlyTag,
      );

      try {
        await LgService(sshData)
            .sendKmlPins(kmlPlacemark.body, kmlPlacemark.name);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  // /// Views  `donors pins` into the Google Earth
  // void _viewDonorsPins(List<UsersModel> donors, BuildContext context,
  //     {double orbitPeriod = 2.8, bool updatePosition = true}) async {
  //   final sshData = Provider.of<SSHprovider>(context, listen: false);

  //   final UsersPinsService usersPinService = UsersPinsService();

  //   /// calling the `buildDonorsPlacemark` that returns the `donors placemark`
  //   final placemarks = usersPinService.buildDonorsPlacemark(
  //     donors,
  //     orbitPeriod,
  //     lookAt: _donorsPlacemark != null && !updatePosition
  //         ? _donorsPlacemark!.lookAt
  //         : null,
  //     updatePosition: updatePosition,
  //   );

  //   for (PlacemarkModel placemark in placemarks) {
  //     /// sending kml to slave where we send the `kml placemark`
  //     final kmlPlacemark = KMLModel(
  //       name: 'HAPIS-Donors-pin-${placemark.id}',
  //       content: placemark.pinOnlyTag,
  //     );

  //     try {
  //       await LgService(sshData)
  //           .sendKmlPins(kmlPlacemark.body, kmlPlacemark.name);
  //     } catch (e) {
  //       // ignore: avoid_print
  //       print(e);
  //     }
  //   }

  // }

  // /// Views  `seekers pins` into the Google Earth
  // void _viewSeekersPins(List<UsersModel> seekers, BuildContext context,
  //     {double orbitPeriod = 2.8, bool updatePosition = true}) async {
  //   final sshData = Provider.of<SSHprovider>(context, listen: false);

  //   final UsersPinsService usersPinService = UsersPinsService();

  //   /// calling the `buildSeekersPlacemark` that returns the `seeker placemark`
  //   final placemarks = usersPinService.buildSeekersPlacemark(
  //     seekers,
  //     orbitPeriod,
  //     lookAt: _seekersPlacemark != null && !updatePosition
  //         ? _seekersPlacemark!.lookAt
  //         : null,
  //     updatePosition: updatePosition,
  //   );

  //   for (PlacemarkModel placemark in placemarks) {
  //     /// sending kml to slave where we send the `kml placemark`
  //     final kmlPlacemark = KMLModel(
  //       name: 'HAPIS-Seekers-pin-${placemark.id}',
  //       content: placemark.pinOnlyTag,
  //     );

  //     try {

  //       await LgService(sshData)
  //           .sendKmlPins(kmlPlacemark.body, kmlPlacemark.name);
  //     } catch (e) {
  //       // ignore: avoid_print
  //       print(e);
  //     }

  //   }

  // }

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
                  padding: const EdgeInsets.only(top: 60.0, left: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubText(subTextContent: 'HAPIS Users in ${widget.city}'),
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Image.asset(
                                "assets/images/userspins.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.12,
                              ),
                              onTap: () async {
                                UserProvider userProvider =
                                    Provider.of<UserProvider>(context,
                                        listen: false);
                                List<UsersModel> seekers = userProvider.seekers;
                                List<UsersModel> givers = userProvider.givers;
                                final sshData = Provider.of<SSHprovider>(
                                    context,
                                    listen: false);
                                try {
                                  await LgService(sshData).clearKml();
                                } catch (e) {
                                  // ignore: avoid_print
                                  print(e);
                                }
                                _viewPins(givers, seekers, context);

                                //print("before view donors");
                                //_viewDonorsPins(givers, context);
                                //await Future.delayed(Duration(seconds: 10));
                                // print("before view seekers");
                                //_viewSeekersPins(seekers, context);
                                // print("after both");
                              },
                            ),
                            Text(' Show Users Pins ',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HapisElevatedButton(
                      elevatedButtonContent: 'Seekers',
                      buttonColor: HapisColors.lgColor2,
                      height: MediaQuery.of(context).size.height * 0.4,
                      imagePath: 'assets/images/seekers.png',
                      imageHeight: MediaQuery.of(context).size.height * 0.25,
                      imageWidth: MediaQuery.of(context).size.height * 0.25,
                      isPoly: false,
                      onpressed: () async {
                        ///retrieving the `list of seekers` from the `user provider` and saving them in `seekers`
                        UserProvider userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        List<UsersModel> seekers = userProvider.seekers;

                        // _viewSeekersPins(seekers, context);

                        /// navigating to the `Seekers` page with the `seekers` and the `city` from the widget input
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Seekers(
                                    seekersList: seekers, city: widget.city)));
                      }),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Donors',
                      buttonColor: HapisColors.lgColor4,
                      height: MediaQuery.of(context).size.height * 0.4,
                      imagePath: 'assets/images/giver.png',
                      imageHeight: MediaQuery.of(context).size.height * 0.25,
                      imageWidth: MediaQuery.of(context).size.height * 0.25,
                      isPoly: false,
                      onpressed: () {
                        ///retrieving the `list of givers` from the `user provider` and saving them in `givers`
                        UserProvider userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        List<UsersModel> givers = userProvider.givers;

                        //_viewDonorsPins(givers, context);

                        /// navigating to the `Givers` page with the `givers` and the `city` from the widget input
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Givers(
                                    giversList: givers, city: widget.city)));
                      }),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}