import 'package:hapis/models/liquid_galaxy/tour_models/userlocation_model.dart';

import '../../models/liquid_galaxy/balloon_models/city_ballon_model.dart';
import '../../models/liquid_galaxy/balloon_models/global_stats_model.dart';
import '../../models/liquid_galaxy/balloon_models/users_model.dart';
import '../../models/liquid_galaxy/tour_models/city_model.dart';
import '../../models/liquid_galaxy/tour_models/country_model.dart';
import '../../utils/extract_geocoordinates.dart';
import '../db_services/city_db_services.dart';
import '../db_services/global_db_services.dart';
import '../db_services/tour_db_services.dart';

class TourService {
  Future<String> generateTourKMLContent() async {
    print('here');
    List<CountryModel> countries = await TourDBServices().getCountries();

    CityModel? cityM;
    UsersModel user = UsersModel();

    String kmlContent = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>HAPIS Tour Doc</name>
    <open>1</open>
    <Folder>
      <gx:Tour>
        <name>Hapis-Tour</name>
        <gx:Playlist>
''';
    print('here1');
// Set initial FlyTo for the globe
    kmlContent += generateInitialFlyTo();
    print('after initial fly to');

    // // Generate balloon for the globe
    // int numberOfSeekers = await globalDBServices().getNumberOfSeekers();
    // int numberOfGivers = await globalDBServices().getNumberOfGivers();

    // int inProgressDonations =
    //     await globalDBServices().getNumberOfInProgressDonations();
    // int successfulDonations =
    //     await globalDBServices().getNumberOfSuccessfulDonations();
    // List<String> topThreeCategories =
    //     await globalDBServices().getTopDonatedCategories();
    // List<String> topThreeCities = await globalDBServices().getTopCities();

    // ///defining a new globe instance for `GlobeModel`` with all the retrieved data from the database
    // GlobeModel globe = GlobeModel(
    //     id: 'Globe',
    //     numberOfSeekers: numberOfSeekers,
    //     numberOfGivers: numberOfGivers,
    //     inProgressDonations: inProgressDonations,
    //     successfulDonations: successfulDonations,
    //     topThreeCategories: topThreeCategories,
    //     topThreeCities: topThreeCities);

    // kmlContent += generatePlacemarkwithID('Globe');
    // // kmlContent += showBalloon(globe.balloonContent());
    // kmlContent += generateWait(4);
    // kmlContent += hidePlacemarkwithID('Globe');
    for (var country in countries) {
      kmlContent += generateCountryFlyTo(country);

      for (var city in country.cities) {
        kmlContent += generateCityFlyTo(city);

        // kmlContent += generatePlacemarkwithID(city.name);

        // Add a wait time between cities
        kmlContent += generateWait(4);

        // //for city:
        // int numberOfSeekers =
        //     await cityDBServices().getNumberOfSeekers(city.name);
        // int numberOfGivers =
        //     await cityDBServices().getNumberOfGivers(city.name);
        // int inProgressDonations =
        //     await cityDBServices().getNumberOfInProgressDonations(city.name);
        // int successfulDonations =
        //     await cityDBServices().getNumberOfSuccessfulDonations(city.name);
        // List<String> topThreeCategories =
        //     await cityDBServices().getTopDonatedCategories(city.name);
        // LatLng coordsCity = LatLng(city.latitude, city.longitude);

        ///defining a new city instance for `cityModel` with all the retrieved data from the database
        // cityM = CityModel(
        //     id: city.name,
        //     name: city.name,
        //     numberOfSeekers: numberOfSeekers,
        //     numberOfGivers: numberOfGivers,
        //     inProgressDonations: inProgressDonations,
        //     successfulDonations: successfulDonations,
        //     topThreeCategories: topThreeCategories,
        //     cityCoordinates: coordsCity);

        for (var userLocation in city.userLocations) {
          // user.email = userLocation.email;
          // user.firstName = userLocation.firstName;
          // user.lastName = userLocation.lastName;
          // user.phoneNum = userLocation.phoneNum;
          kmlContent += generateUserLocationFlyTo(userLocation);
          //kmlContent += generatePlacemarkwithID(userLocation.userName);

          kmlContent += generateWait(2);
          kmlContent +=
              generateUserLocationOrbit(userLocation); // Add orbit animation
          // Add a wait time between user locations
        }
      }
    }
    print('here before placemakrs');
    kmlContent += '''
        </gx:Playlist>
      </gx:Tour>
      <!-- Placemark definitions for underwater and onland locations go here -->
''';
    // kmlContent += generateBalloonPlacemark(
    //     globe.balloonContent(), LatLng(-60.4518936, -47.0000101));
    // kmlContent += generateBalloonPlacemark(
    //     cityM!.balloonContent(), cityM.cityCoordinates);
    // kmlContent += generateBalloonPlacemark(
    //     user.tourUserBalloonContent(), user.userCoordinates!);

//we dont want it at all
//     kmlContent += '''
//         </gx:Playlist>
//       </gx:Tour>
//       <!-- Placemark definitions for underwater and onland locations go here -->
//     </Folder>
//   </Document>
// </kml>
// ''';

    kmlContent += '''
    </Folder>
  </Document>
</kml>
''';

    print(kmlContent);

    return kmlContent;
  }

  String generateInitialFlyTo() {
    return '''
      <!-- Initial FlyTo for the globe -->
      <gx:FlyTo>
        <gx:duration>5.0</gx:duration>
        <LookAt>
          <longitude>-60.4518936</longitude>
          <latitude>-47.0000101</latitude>
          <altitude>50000.1097385</altitude>
          <range>31231212.86</range>
        </LookAt>
      </gx:FlyTo>
    ''';
  }

  String generateCountryFlyTo(CountryModel country) {
    return '''
      <!-- FlyTo for ${country.name} -->
      <gx:FlyTo>
        <gx:duration>5.0</gx:duration>
        <LookAt>
          <longitude>${country.longitude}</longitude>
          <latitude>${country.latitude}</latitude>
          <altitude>0</altitude>
          <range>400000</range>
          <tilt>0</tilt>
          
        
        </LookAt>
      </gx:FlyTo>
    ''';
  }

  String generateCityFlyTo(CityModelTour city) {
    return '''
      <!-- FlyTo for ${city.name} -->
      <gx:FlyTo>
        <gx:duration>8</gx:duration>
        <gx:flyToMode>smooth</gx:flyToMode>
        <LookAt>
          <longitude>${city.longitude}</longitude>
          <latitude>${city.latitude}</latitude>
          <altitude>0</altitude>
          <range>40000</range>
          <tilt>60</tilt>
          <!-- Set other LookAt properties as needed -->
        </LookAt>
      </gx:FlyTo>
    ''';
  }

  String generateUserLocationFlyTo(UserLocationModel userLocation) {
    return '''
       <!-- FlyTo for ${userLocation.userName} -->
      <gx:FlyTo>
        <gx:duration>8</gx:duration>
        <gx:flyToMode>smooth</gx:flyToMode>
        <LookAt>
          <longitude>${userLocation.longitude}</longitude>
          <latitude>${userLocation.latitude}</latitude>
          <altitude>0</altitude>
          <range>300</range>
          <tilt>60</tilt>
          <!-- Set other LookAt properties as needed -->
        </LookAt>
      </gx:FlyTo>
      
    ''';
  }

  String generateWait(double duration) {
    return '''
        <gx:Wait>
          <gx:duration>${duration}</gx:duration>
        </gx:Wait>
    ''';
  }

  String generateUserLocationOrbit(UserLocationModel userLocation) {
    String kmlContent = '';
    double orbitDuration = 1.0;

    // Generate a series of FlyTo elements to create the orbit effect
    for (int i = 0; i < 36; i++) {
      double heading = i * 10.0;
      kmlContent += '''
      <gx:FlyTo>
        <gx:duration>${orbitDuration}</gx:duration>
        <gx:flyToMode>smooth</gx:flyToMode>
        <LookAt>
          <longitude>${userLocation.longitude}</longitude>
          <latitude>${userLocation.latitude}</latitude>
          <altitude>0</altitude>
          <heading>${heading}</heading>
          <range>250</range>
          <tilt>60</tilt>
          <!-- Set other LookAt properties as needed -->
        </LookAt>
      </gx:FlyTo>
    ''';
    }

    return kmlContent;
  }

  String generateBalloonPlacemark(String balloonContent, LatLng coordinates) {
    return '''
      <Placemark>
        <name></name>
        <gx:balloonVisibility>1</gx:balloonVisibility>
        <description><![CDATA[$balloonContent]]></description>
        <Point>
          <coordinates>${coordinates.longitude},${coordinates.latitude}</coordinates>
        </Point>
      </Placemark>
    ''';
  }

  String generatePlacemarkwithID(String placemarkID) {
    return '''
        <gx:AnimatedUpdate>
          <!-- the default duration is 0.0 -->
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="$placemarkID">
                <visibility>1</visibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>
''';
  }

//   String showBalloon(String content) {
//     return '''
//    <gx:AnimatedUpdate>
//           <Update>
//             <targetHref/>
//             <Change>
//               <gx:Balloon>
//                 <gx:html>
//                   <![CDATA[
//                    $content
//                    ]]>
//                 </gx:html>
//                 <gx:visibility>1</gx:visibility>
//               </gx:Balloon>
//             </Change>
//           </Update>
//         </gx:AnimatedUpdate>
// ''';
//   }

  String hidePlacemarkwithID(String placemarkID) {
    return '''
        <gx:AnimatedUpdate>
          <!-- the default duration is 0.0 -->
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="$placemarkID">
               <visibility>0</visibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>
''';
  }
}






//   String tourKMLContent = '''
// <?xml version="1.0" encoding="UTF-8"?>
// <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
//   <Document>
//     <name>HAPIS Tour Doc</name>
//     <open>1</open>
//     <Folder>
//      <gx:Tour>
//       <name>Play me</name>
//       <gx:Playlist>
 
//         <gx:FlyTo>
//           <gx:duration>5.0</gx:duration>
//           <!-- bounce is the default flyToMode -->
//           <LookAt>
//             <longitude>-119.748584</longitude>
//             <latitude>33.736266</latitude>
//             <altitude>0</altitude>
//             <heading>-9.295926</heading>
//             <tilt>84.0957450</tilt>
//             <range>4469.850414</range>
//             <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
//           </LookAt>
//         </gx:FlyTo>

//         <gx:AnimatedUpdate>
//           <!-- the default duration is 0.0 -->
//           <Update>
//             <targetHref/>
//             <Change>
//               <Placemark targetId="underwater1">
//                 <gx:balloonVisibility>1</gx:balloonVisibility>
//               </Placemark>
//             </Change>
//           </Update>
//         </gx:AnimatedUpdate>

//         <gx:Wait>
//           <gx:duration>4.0</gx:duration>
//         </gx:Wait>

//         <gx:AnimatedUpdate>
//           <Update>
//             <targetHref/>
//             <Change>
//               <Placemark targetId="underwater1">
//                 <gx:balloonVisibility>0</gx:balloonVisibility>
//               </Placemark>
//             </Change>
//           </Update>
//         </gx:AnimatedUpdate>

//         <gx:FlyTo>
//           <gx:duration>3</gx:duration>
//           <gx:flyToMode>smooth</gx:flyToMode>
//           <LookAt>
//             <longitude>-119.782630</longitude>
//             <latitude>33.862855</latitude>
//             <altitude>0</altitude>
//             <heading>-19.314858</heading>
//             <tilt>84.117317</tilt>
//             <range>6792.665540</range>
//             <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
//           </LookAt>
//         </gx:FlyTo>

//         <gx:AnimatedUpdate>
//           <Update>
//             <targetHref/>
//             <Change>
//               <Placemark targetId="underwater2">
//                 <gx:balloonVisibility>1</gx:balloonVisibility>
//               </Placemark>
//             </Change>
//           </Update>
//         </gx:AnimatedUpdate>

//         <gx:Wait>
//           <gx:duration>4.0</gx:duration>
//         </gx:Wait>

//         <gx:AnimatedUpdate>
//           <Update>
//             <targetHref/>
//             <Change>
//               <Placemark targetId="underwater2">
//                 <gx:balloonVisibility>0</gx:balloonVisibility>
//               </Placemark>
//             </Change>
//           </Update>
//         </gx:AnimatedUpdate>

//         <gx:FlyTo>
//           <gx:duration>3</gx:duration>
//           <gx:flyToMode>smooth</gx:flyToMode>
//           <LookAt>
//             <longitude>-119.849578</longitude>
//             <latitude>33.968515</latitude>
//             <altitude>0</altitude>
//             <heading>-173.948935</heading>
//             <tilt>23.063392</tilt>
//             <range>3733.666023</range>
//             <altitudeMode>relativeToGround</altitudeMode>
//           </LookAt>
//         </gx:FlyTo>

//         <gx:AnimatedUpdate>
//           <Update>
//             <targetHref/>
//             <Change>
//               <Placemark targetId="onland">
//                 <gx:balloonVisibility>1</gx:balloonVisibility>
//               </Placemark>
//             </Change>
//           </Update>
//         </gx:AnimatedUpdate>

//         <gx:Wait>
//           <gx:duration>4.0</gx:duration>
//         </gx:Wait>

//       </gx:Playlist>
//     </gx:Tour>

//     <Placemark id="underwater1">
//       <name>Underwater off the California Coast</name>
//       <description>
//         The tour begins near the Santa Cruz Canyon, 
//         off the coast of California, USA.
//       </description>
//       <Point>
//         <gx:altitudeMode>clampToSeaFloor</gx:altitudeMode>
//         <coordinates>-119.749531,33.715059,0</coordinates>
//       </Point>
//     </Placemark>

//     <Placemark id="underwater2">
//       <name>Still swimming...</name>
//       <description>We're about to leave the ocean, and visit the coast...</description>
//       <Point>
//         <gx:altitudeMode>clampToSeaFloor</gx:altitudeMode>
//         <coordinates>-119.779550,33.829268,0</coordinates>
//       </Point>
//     </Placemark>

//     <Placemark id="onland">
//       <name>The end</name>
//       <description>
//         <![CDATA[The end of our simple tour. 
//         Use <gx:balloonVisibility>1</gx:balloonVisibility> 
//         to show description balloons.]]>
//       </description>
//       <Point>
//         <coordinates>-119.849578,33.968515,0</coordinates>
//       </Point>
//     </Placemark>
      
//     </Folder>
//   </Document>
// </kml>

// ''';







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