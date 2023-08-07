import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/liquid_galaxy/kml/KMLModel.dart';
import '../../../models/liquid_galaxy/kml/look_at_model.dart';
import '../../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../../providers/liquid_galaxy/ssh_provider.dart';

import '../../models/liquid_galaxy/balloon_models/users_model.dart';
import '../../models/liquid_galaxy/balloon_models/city_ballon_model.dart';
import '../../models/liquid_galaxy/balloon_models/global_stats_model.dart';
import 'LG_placemarks_services/city_balloon_service.dart';
import 'LG_placemarks_services/global_balloon_service.dart';
import 'LG_functionalities.dart';
import 'LG_placemarks_services/user_balloon_service.dart';

class TourService {
  String tourKMLContent = '''
    <gx:Tour>
      <name>Play me</name>
      <gx:Playlist>
 
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <!-- bounce is the default flyToMode -->
          <LookAt>
            <longitude>-119.748584</longitude>
            <latitude>33.736266</latitude>
            <altitude>0</altitude>
            <heading>-9.295926</heading>
            <tilt>84.0957450</tilt>
            <range>4469.850414</range>
            <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:AnimatedUpdate>
          <!-- the default duration is 0.0 -->
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="underwater1">
                <gx:balloonVisibility>1</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:Wait>
          <gx:duration>4.0</gx:duration>
        </gx:Wait>

        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="underwater1">
                <gx:balloonVisibility>0</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>-119.782630</longitude>
            <latitude>33.862855</latitude>
            <altitude>0</altitude>
            <heading>-19.314858</heading>
            <tilt>84.117317</tilt>
            <range>6792.665540</range>
            <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="underwater2">
                <gx:balloonVisibility>1</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:Wait>
          <gx:duration>4.0</gx:duration>
        </gx:Wait>

        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="underwater2">
                <gx:balloonVisibility>0</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>-119.849578</longitude>
            <latitude>33.968515</latitude>
            <altitude>0</altitude>
            <heading>-173.948935</heading>
            <tilt>23.063392</tilt>
            <range>3733.666023</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="onland">
                <gx:balloonVisibility>1</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:Wait>
          <gx:duration>4.0</gx:duration>
        </gx:Wait>

      </gx:Playlist>
    </gx:Tour>

    <Placemark id="underwater1">
      <name>Underwater off the California Coast</name>
      <description>
        The tour begins near the Santa Cruz Canyon, 
        off the coast of California, USA.
      </description>
      <Point>
        <gx:altitudeMode>clampToSeaFloor</gx:altitudeMode>
        <coordinates>-119.749531,33.715059,0</coordinates>
      </Point>
    </Placemark>

    <Placemark id="underwater2">
      <name>Still swimming...</name>
      <description>We're about to leave the ocean, and visit the coast...</description>
      <Point>
        <gx:altitudeMode>clampToSeaFloor</gx:altitudeMode>
        <coordinates>-119.779550,33.829268,0</coordinates>
      </Point>
    </Placemark>

    <Placemark id="onland">
      <name>The end</name>
      <description>
        <![CDATA[The end of our simple tour. 
        Use <gx:balloonVisibility>1</gx:balloonVisibility> 
        to show description balloons.]]>
      </description>
      <Point>
        <coordinates>-119.849578,33.968515,0</coordinates>
      </Point>
    </Placemark>
''';
}






/*

 static void viewGlobe(
    GlobeModel globe,
    bool showBalloon,
    BuildContext context, {
    double orbitPeriod = 2.8,
    bool updatePosition = true,
  }) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    final GlobalBalloonService globeService = GlobalBalloonService();

    PlacemarkModel? _globePlacemark;

    final placemark = globeService.buildGlobalPlacemark(
      globe,
      showBalloon,
      orbitPeriod,
      lookAt: _globePlacemark != null && !updatePosition
          ? _globePlacemark.lookAt
          : null,
      updatePosition: false,
    );

    try {
      await LgService(sshData).clearKml();
    } catch (e) {
      print(e);
    }

    final kmlBalloon = KMLModel(
      name: 'HAPIS-Global-balloon',
      content: placemark.balloonOnlyTag,
    );

    try {
      await LgService(sshData).sendKMLToSlave(
        LgService(sshData).balloonScreen,
        kmlBalloon.body,
      );
    } catch (e) {
      print(e);
    }

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
  }

  void viewCity(CityModel city, bool showBalloon, BuildContext context,
      {double orbitPeriod = 2.8, bool updatePosition = true}) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    final CityBalloonService cityService = CityBalloonService();
    PlacemarkModel? _cityPlacemark;

    /// calling the `buildCityPlacemark` that returns the `city placemark`
    final placemark = cityService.buildCityPlacemark(
      city,
      showBalloon,
      orbitPeriod,
      lookAt: _cityPlacemark != null && !updatePosition
          ? _cityPlacemark.lookAt
          : null,
      updatePosition: updatePosition,
    );

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
        // range: '13000',
        range: '5000',
        tilt: '0',
        heading: '0',
      ));
    }
  }

  void viewUser(
      UsersModel user, bool showBalloon, BuildContext context, String type,
      {double orbitPeriod = 2.8, bool updatePosition = true}) async {
    PlacemarkModel? _userPlacemark;
    bool seeker = false;

    if (type == 'seeker') {
      seeker = true;
    }
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    final UserBalloonService userService = UserBalloonService();

    final placemark = userService.buildUserPlacemark(
      user,
      showBalloon,
      seeker, //if seeker then true
      orbitPeriod,
      lookAt: _userPlacemark != null && !updatePosition
          ? _userPlacemark.lookAt
          : null,
      updatePosition: updatePosition,
    );

    try {
      await LgService(sshData).clearKml();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    // according to user if seeker or giver
    final kmlBalloon = KMLModel(
      name: 'HAPIS-USER-balloon',
      content: placemark.balloonOnlyTag,
    );

    await Future.delayed(Duration(seconds: 3));
    try {
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
        latitude: user.userCoordinates!.latitude,
        longitude: user.userCoordinates!.longitude,
        altitude: 0,
        range: '300',
        tilt: '0',
        heading: '0',
      ));
    }

    await Future.delayed(Duration(seconds: 5));
    String query = 'echo "exittour=true" > /tmp/query.txt ';
    try {
      await sshData.execute(query);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    final orbit = userService.buildOrbit(user);
    try {
      await LgService(sshData).sendTour(orbit, 'Orbit');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // hapisTour(
  //     GlobeModel globe,
  //     bool showBalloon,
  //     BuildContext context,
  //     List<CityModel> cities,
  //     List<UsersModel> users,
  //     Duration delayBetweenUsers) async {
  //    viewGlobe(globe, showBalloon, context);

  //   for (final city in cities) {
  //      viewCity(city, showBalloon, context);
  //     for (final user in users) {
  //       if (user.cityId == city.id) {
  //          viewUser(user, showBalloon, context, delayBetweenUsers);
  //       }
  //     }
  //   }
  // }

*/