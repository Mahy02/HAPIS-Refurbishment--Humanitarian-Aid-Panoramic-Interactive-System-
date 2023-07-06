import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/models/balloon_models/city_ballon_model.dart';
import 'package:hapis/models/db_models/users_model.dart';
import 'package:hapis/models/kml/KMLModel.dart';
import 'package:hapis/models/kml/look_at_model.dart';
import 'package:hapis/models/kml/placemark_model.dart';
import 'package:hapis/reusable_widgets/hapis_elevated_button.dart';
import 'package:hapis/services/LG_balloon_services/city_balloon_service.dart';
import 'package:hapis/services/LG_functionalities.dart';
import 'package:provider/provider.dart';

import '../providers/connection_provider.dart';
import '../providers/ssh_provider.dart';
import '../providers/users_provider.dart';
import '../screens/users.dart';
import '../services/db_services/city_db_services.dart';
import '../services/db_services/users_services.dart';
import '../utils/extract_geocoordinates.dart';
import '../utils/pop_up_connection.dart';

class CityComponent extends StatefulWidget {
  final String city;
  final Color buttonColor;
  final String country;
  const CityComponent(
      {super.key,
      required this.city,
      required this.buttonColor,
      required this.country});

  @override
  State<CityComponent> createState() => _CityComponentState();
}

class _CityComponentState extends State<CityComponent> {
  PlacemarkModel? _cityPlacemark;

  /// Views a `city stats` into the Google Earth.
  void _viewCityStats(CityModel city, bool showBalloon, BuildContext context,
      {double orbitPeriod = 2.8, bool updatePosition = true}) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    print("here");
    final CityBalloonService cityService = CityBalloonService();
    print("inside view city");
    print(sshData.client!.username);
    print(cityService);
    final placemark = cityService.buildCityPlacemark(
      city,
      showBalloon,
      orbitPeriod,
      lookAt: _cityPlacemark != null && !updatePosition
          ? _cityPlacemark!.lookAt
          : null,
      updatePosition: updatePosition,
    );

    setState(() {
      _cityPlacemark = placemark;
    });

    try {
      await LgService(sshData).clearKml();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    final kmlBalloon = KMLModel(
      name: 'HAPIS-City-balloon',
      content: placemark.balloonOnlyTag,
    );

    try {
      await LgService(sshData).sendKMLToSlave(
        LgService(sshData).balloonScreen,
        kmlBalloon.body,
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    //  }

    if (updatePosition) {
      await LgService(sshData).flyTo(LookAtModel(
        latitude: city.cityCoordinates.latitude,
        longitude: city.cityCoordinates.longitude,
        altitude: 0,
        range: '13000',
        tilt: '0',
        heading: '0',
      ));
    }
    final orbit = cityService.buildOrbit(city);
    await LgService(sshData).sendTour(orbit, 'Orbit');
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = countryMap[widget.country];
    final buttonContent = '${widget.city}\n${widget.country}';

    return HapisElevatedButton(
      buttonColor: widget.buttonColor,
      elevatedButtonContent: buttonContent,
      height: MediaQuery.of(context).size.height * 0.2,
      imageHeight: MediaQuery.of(context).size.height * 0.15,
      imageWidth: MediaQuery.of(context).size.height * 0.15,
      imagePath: imagePath,
      isPoly: true,
      onpressed: () async {
        //here we should do 2 things
        //first navigate to users page for each city
        //then we should show bubble on LG with the city stats
        //but check connectivity first

        print("inside a city");
        int numberOfSeekers =
            await cityDBServices().getNumberOfSeekers(widget.city);
        int numberOfGivers =
            await cityDBServices().getNumberOfGivers(widget.city);
        int inProgressDonations =
            await cityDBServices().getNumberOfInProgressDonations(widget.city);
        int successfulDonations =
            await cityDBServices().getNumberOfSuccessfulDonations(widget.city);
        List<String> topThreeCategories =
            await cityDBServices().getTopDonatedCategories(widget.city);

        //clear before:
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.clearData();

        await cityDBServices().getSeekersInfo(widget.city, context);

        await cityDBServices().getGiversInfo(widget.city, context);

        try {
          final LatLng cityCoordinates = await getCoordinates(widget.city);

          print("city button trial");
          print(cityCoordinates);

          print("inside city component on pressed ");
          print("number of seekers: $numberOfSeekers");
          print("number of givers: $numberOfGivers");
          print("in progress donations: $inProgressDonations");
          print("succ donations: $successfulDonations");
          print("top 3 cat: $topThreeCategories");

          CityModel city = CityModel(
              id: widget.city,
              name: widget.city,
              //seekers: seekers,
              // givers: givers,
              numberOfSeekers: numberOfSeekers,
              numberOfGivers: numberOfGivers,
              inProgressDonations: inProgressDonations,
              successfulDonations: successfulDonations,
              topThreeCategories: topThreeCategories,
              cityCoordinates: cityCoordinates);

          // ignore: use_build_context_synchronously
          final sshData = Provider.of<SSHprovider>(context, listen: false);
            final connection = Provider.of<Connectionprovider>(context,
                                  listen: false);
final socket = await SSHSocket.connect(connection.connectionFormData.ip, connection.connectionFormData.port);

          if (sshData.client != null) {
            // ignore: use_build_context_synchronously
            _viewCityStats(city, true, context);

            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Users(city: widget.city)));
          } else {
            // ignore: use_build_context_synchronously
            showDialogConnection(context);
          }
        } catch (e) {
          // ignore: avoid_print
          print(e);
        }
      },
    );
  }
}











// print(seekers);
        // print(givers);

        // List<UsersModel> seekers = userProvider.seekers;
        // List<UsersModel> givers = userProvider.givers;

        // for (UsersModel seeker in seekers) {
        //   print('Seeker: ${seeker.firstName} ${seeker.lastName}');
        //   print('ID: ${seeker.userID}');
        //   print('City: ${seeker.city}');
        // }
        // for (UsersModel giver in givers) {
        //   print('giver: ${giver.firstName} ${giver.lastName}');
        //   print('ID: ${giver.userID}');
        //   print('City: ${giver.city}');
        // }
