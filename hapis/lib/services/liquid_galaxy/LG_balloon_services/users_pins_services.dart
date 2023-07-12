import 'package:hapis/models/liquid_galaxy/kml/look_at_model.dart';

import '../../../models/db_models/users_model.dart';

import '../../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../../models/liquid_galaxy/kml/point_model.dart';

class UsersPinsService {
  /// Builds and returns a Donor `Placemark` entity according to the given a list of [donors]
  List<PlacemarkModel> buildDonorsPlacemark(
    List<UsersModel> donors,
    double orbitPeriod, {
    LookAtModel? lookAt,
    bool updatePosition = false,
  }) {
    List<PlacemarkModel> placemarks = [];

    for (UsersModel donor in donors) {
      LookAtModel lookAtObj;

      if (lookAt == null) {
        lookAtObj = LookAtModel(
            longitude: donor.userCoordinates!.longitude,
            latitude: donor.userCoordinates!.latitude,
            range: '4000000',
            altitude: 0,
            tilt: '60',
            heading: '0');
      } else {
        lookAtObj = lookAt;
      }

      final point = PointModel(
          lat: lookAtObj.latitude,
          lng: lookAtObj.longitude,
          altitude: lookAtObj.altitude);

      placemarks.add(PlacemarkModel(
        id: donor.userName!,
        name: donor.userName!,
        lookAt: updatePosition ? lookAtObj : null,
        point: point,
        icon:
            'https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week4/hapis/assets/images/donorpin.png?raw=true',
      ));
    }

    return placemarks;
  }

  /// Builds and returns a Seeker `Placemark` entity according to the given a list of [seekers]
  List<PlacemarkModel> buildSeekersPlacemark(
    List<UsersModel> seekers,
    double orbitPeriod, {
    LookAtModel? lookAt,
    bool updatePosition = false,
  }) {
    List<PlacemarkModel> placemarks = [];

    for (UsersModel seeker in seekers) {
      LookAtModel lookAtObj;

      if (lookAt == null) {
        lookAtObj = LookAtModel(
            longitude: seeker.userCoordinates!.longitude,
            latitude: seeker.userCoordinates!.latitude,
            altitude: 0,
            range: '4000000',
            tilt: '60',
            heading: '0');
      } else {
        lookAtObj = lookAt;
      }

      final point = PointModel(
          lat: lookAtObj.latitude,
          lng: lookAtObj.longitude,
          altitude: lookAtObj.altitude);

      placemarks.add(PlacemarkModel(
        id: seeker.userName!,
        name: seeker.userName!,
        lookAt: updatePosition ? lookAtObj : null,
        point: point,
        icon:
            'https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week4/hapis/assets/images/seekerpin.png?raw=true',
      ));
    }

    return placemarks;
  }
}


/*
  public LGCommand showPlacemark(POI poi, LGCommand.Listener listener, String placemarkIcon, String route){
        currentPOI = new POI(poi);
        return  sendPlacemarkToLG(listener, placemarkIcon, route);
    }


     private LGCommand sendPlacemarkToLG(LGCommand.Listener listener, String placemarkIcon, String route){
        LGCommand lgCommand = new LGCommand(buildPlacemark(currentPOI, placemarkIcon, route), CRITICAL_MESSAGE, (String result) -> {
            //currentPOI = new POI(previousPOI);
            if(listener != null)
                listener.onResponse(result);
        });
        LGConnectionManager.getInstance().addCommandToLG(lgCommand);
        return lgCommand;
    }

POIController.getInstance().showPlacemark(userPoi,null, "https://i.ibb.co/Bg4Lnvk/donor-icon.png", "placemarks/donors");


    private static String buildPlacemark(POI poi, String placemarkIcon, String route){
       return "echo '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
               "<kml xmlns=\"http://www.opengis.net/kml/2.2\"> " +
               "<Placemark>\n" +
               "  <Style id=\"homelessIcon\">\n" +
               "      <IconStyle>\n" +
               "        <Icon>\n" +
               "          <href>" + placemarkIcon + "</href>\n" +
               "        </Icon>\n" +
               "      </IconStyle>\n" +
               "    </Style>\n" +
               "  <styleUrl>#homelessIcon</styleUrl>\n" +
               " <Point>\n" +
               " <coordinates>" + poi.getLongitude() + "," + poi.getLatitude() + "," + poi.getAltitude() + "</coordinates>\n" +
               " </Point>\n" +
               " </Placemark> </kml>' > /var/www/html/hapis/" + route + "/" + poi.getName() + ".kml";
    }

*/
