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

import '../providers/ssh_provider.dart';
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

    // if (LgService(sshData).balloonScreen == LgService(sshData).logoScreen) {
    //   await LgService(sshData).setLogos(
    //     name: 'SVT-logos-balloon',
    //     content: '''
    //         <name>Logos-Balloon</name>
    //         ${placemark.balloonOnlyTag}
    //       ''',
    //   );
    //} else {
    LgService(sshData).clearKml();
    final kmlBalloon = KMLModel(
      name: 'HAPIS-balloon',
      content: placemark.balloonOnlyTag,
    );

    await LgService(sshData).sendKMLToSlave(
      LgService(sshData).balloonScreen,
      kmlBalloon.body,
    );
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
    print("hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print(widget.city);
    print(widget.country);
    return
        //Image.asset(imagePath!);

        HapisElevatedButton(
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
        int numberOfSeekers = cityDBServices().getNumberOfSeekers();
        int numberOfGivers = cityDBServices().getNumberOfGivers();
        List<String> seekers = cityDBServices().getListOfSeekers();
        List<String> givers = cityDBServices().getListOfGivers();
        int inProgressDonations =
            cityDBServices().getNumberOfInProgressDonations();
        int successfulDonations =
            cityDBServices().getNumberOfSuccessfulDonations();
        List<String> topThreeCategories =
            cityDBServices().getTopDonatedCategories();
        print(numberOfSeekers);
        print(widget.city);
        print(widget.country);
        final LatLng cityCoordinates = await getCoordinates(widget.city);
        print("city button trial");
        print(cityCoordinates);

        CityModel city = CityModel(
            id: '2',
            name: widget.city,
            seekers: seekers,
            givers: givers,
            numberOfSeekers: numberOfSeekers,
            numberOfGivers: numberOfGivers,
            inProgressDonations: inProgressDonations,
            successfulDonations: successfulDonations,
            topThreeCategories: topThreeCategories,
            cityCoordinates: cityCoordinates);

        final sshData = Provider.of<SSHprovider>(context, listen: false);
        print("inside city component on pressed ");
        // print(sshData.client.username);
        if (sshData.client != null) {
          print(sshData.client!.username);

          print("here");
          _viewCityStats(city, true, context);
        } else {
          showDialogConnection(context);
        }
      },
    );
  }
}