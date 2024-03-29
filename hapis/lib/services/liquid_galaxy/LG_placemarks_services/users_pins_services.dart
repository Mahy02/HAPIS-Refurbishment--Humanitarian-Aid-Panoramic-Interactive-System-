import 'package:hapis/models/liquid_galaxy/kml/look_at_model.dart';

import '../../../models/liquid_galaxy/balloon_models/users_model.dart';

import '../../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../../models/liquid_galaxy/kml/point_model.dart';

/// The `UsersPinsService` class handles building KML elements for donor and seeker pins.

class UsersPinsService {
  /// Builds and returns a list of `Placemark` entities for donors according to the given list of [donors].
  ///
  /// The [orbitPeriod] parameter specifies the orbit period.
  /// The [lookAt] parameter can be used to set a custom LookAt configuration.
  /// The [updatePosition] parameter determines whether to update the position.
  
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


  /// Builds and returns a list of `Placemark` entities for seekers according to the given list of [seekers].
  ///
  /// The [orbitPeriod] parameter specifies the orbit period.
  /// The [lookAt] parameter can be used to set a custom LookAt configuration.
  /// The [updatePosition] parameter determines whether to update the position.
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


