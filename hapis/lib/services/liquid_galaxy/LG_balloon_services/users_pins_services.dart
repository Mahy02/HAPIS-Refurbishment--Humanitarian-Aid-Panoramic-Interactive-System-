import 'package:hapis/models/liquid_galaxy/kml/look_at_model.dart';

import '../../../models/db_models/users_model.dart';
import '../../../models/liquid_galaxy/kml/line_model.dart';

import '../../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../../models/liquid_galaxy/kml/point_model.dart';

class UsersPinsService {
  /// Builds and returns a Donor `Placemark` entity according to the given a list of [donors]
  List<PlacemarkModel> buildDonorsPlacemark(
    List<UsersModel> donors,
    double orbitPeriod, {
    LookAtModel? lookAt,
    bool updatePosition = true,
  }) {
    List<PlacemarkModel> placemarks = [];

    for (UsersModel donor in donors) {
      LookAtModel lookAtObj;

      if (lookAt == null) {
        lookAtObj = LookAtModel(
            longitude: donor.userCoordinates!.longitude,
            latitude: donor.userCoordinates!.latitude,
            range: '4000000',
            altitude: 10000,
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
        icon: 'assets/images/donorpin.png',
      ));
    }

    return placemarks;
  }

  /// Builds and returns a Seeker `Placemark` entity according to the given a list of [seekers]
  List<PlacemarkModel> buildSeekersPlacemark(
    List<UsersModel> seekers,
    double orbitPeriod, {
    LookAtModel? lookAt,
    bool updatePosition = true,
  }) {
    List<PlacemarkModel> placemarks = [];

    for (UsersModel seeker in seekers) {
      LookAtModel lookAtObj;

      if (lookAt == null) {
        lookAtObj = LookAtModel(
            longitude: seeker.userCoordinates!.longitude,
            latitude: seeker.userCoordinates!.latitude,
            altitude: 10000,
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
        icon: 'assets/images/seekerpin.png',
      ));
    }

    return placemarks;
  }
}
