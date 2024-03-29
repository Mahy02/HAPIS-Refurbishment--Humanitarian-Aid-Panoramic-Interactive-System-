import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';

import 'package:provider/provider.dart';

import '../../models/liquid_galaxy/balloon_models/city_ballon_model.dart';
import '../../models/liquid_galaxy/kml/KMLModel.dart';
import '../../models/liquid_galaxy/kml/look_at_model.dart';
import '../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../providers/liquid_galaxy/ssh_provider.dart';
import '../../providers/liquid_galaxy/users_provider.dart';
import '../../screens/liquid_galaxy/users.dart';
import '../../services/db_services/city_db_services.dart';
import '../../services/liquid_galaxy/LG_placemarks_services/city_balloon_service.dart';
import '../../services/liquid_galaxy/LG_functionalities.dart';
import '../../utils/extract_geocoordinates.dart';
import '../../utils/pop_up_connection.dart';
import '../hapis_elevated_button.dart';

/// This represents the `CityComponent` where for each city it has the name [city], color [buttonColor], Country [country]
/// It also has [fontSize], [imageHeight] and [imageWidth] to adapt to different layouts and be responsive
class CityComponent extends StatefulWidget {
  final String city;
  final Color buttonColor;
  final String country;
  final double fontSize;
  final double imageHeight;
  final double imageWidth;
  const CityComponent(
      {super.key,
      required this.city,
      required this.buttonColor,
      required this.country,
      required this.fontSize,
      required this.imageHeight,
      required this.imageWidth});

  @override
  State<CityComponent> createState() => _CityComponentState();
}

class _CityComponentState extends State<CityComponent> {
  ///  `city placemark` to define the city placemark for orbiting, balloons
  PlacemarkModel? _cityPlacemark;

  /// Views a `city stats` into the Google Earth in a Balloon and Fly to the city.
  void _viewCityStats(CityModel city, bool showBalloon, BuildContext context,
      {double orbitPeriod = 2.8, bool updatePosition = true}) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    final CityBalloonService cityService = CityBalloonService();

    /// calling the `buildCityPlacemark` that returns the `city placemark`
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

    /// defining the `kml balloon` content and name
    final kmlBalloon = KMLModel(
      name: 'HAPIS-City-balloon',
      content: placemark.balloonOnlyTag,
    );

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
        latitude: city.cityCoordinates.latitude,
        longitude: city.cityCoordinates.longitude,
        altitude: 0,
        range: '10000',
        tilt: '45',
        heading: '0',
      ));
    }
  }

  bool isLoadingCity = false;

  @override
  Widget build(BuildContext context) {
    final imagePath = countryMap[widget.country];
    final buttonContent = '${widget.city}\n${widget.country}';

    return HapisElevatedButton(
      isLoading: isLoadingCity,
      fontSize: widget.fontSize,
      buttonColor: widget.buttonColor,
      elevatedButtonContent: isLoadingCity ? 'Loading...' : buttonContent,
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.1,
      imageHeight: widget.imageHeight,
      imageWidth: widget.imageWidth,
      imagePath: imagePath,
      isPoly: false,
      onpressed: () async {
        setState(() {
          isLoadingCity = true;
        });

        /// retrieving all city data from the database
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

        ///clearing seekers and givers list first:
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.clearData();

        await cityDBServices().getSeekersInfo(widget.city, context);

        await cityDBServices().getGiversInfo(widget.city, context);

        /// Hide the loading indicator and navigate to the new page
        setState(() {
          isLoadingCity = false;
        });
        try {
          /// retrieving  `city coordinates`
          final LatLng cityCoordinates = await getCoordinates(widget.city);

          ///defining a new city instance for `cityModel` with all the retrieved data from the database
          CityModel city = CityModel(
              id: widget.city,
              name: widget.city,
              numberOfSeekers: numberOfSeekers,
              numberOfGivers: numberOfGivers,
              inProgressDonations: inProgressDonations,
              successfulDonations: successfulDonations,
              topThreeCategories: topThreeCategories,
              cityCoordinates: cityCoordinates);

          // ignore: use_build_context_synchronously
          final sshData = Provider.of<SSHprovider>(context, listen: false);

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
