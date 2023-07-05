
import 'package:hapis/models/db_models/users_model.dart';
import 'package:hapis/models/kml/line_model.dart';
import 'package:hapis/models/kml/look_at_model.dart';
import 'package:hapis/models/kml/placemark_model.dart';
import 'package:hapis/models/kml/point_model.dart';
import 'package:hapis/models/kml/tour_model.dart';

import '../../models/balloon_models/city_ballon_model.dart';
import '../../models/kml/orbit_model.dart';
import '../../utils/extract_geocoordinates.dart';

class UserBalloonService {
  /// Builds and returns a user `Placemark` entity according to the given [user]
  PlacemarkModel buildUserPlacemark(
    UsersModel user,
    bool balloon,
    bool seeker,
    double orbitPeriod, {
    LookAtModel? lookAt,
    bool updatePosition = true,
  })   {
    LookAtModel lookAtObj;

   // final LatLng coord = await getCoordinates(user.addressLocation!);

    if (lookAt == null) {
      lookAtObj = LookAtModel(
          longitude: user.userCoordinates!.longitude,
          latitude: user.userCoordinates!.latitude,
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
    final coordinates =
        user.getUserOrbitCoordinates(user.addressLocation!, step: orbitPeriod);
    final tour = TourModel(
      name: 'CityTour',
      placemarkId: 'p-${user.userID}',
      initialCoordinate: {
        'lat': point.lat,
        'lng': point.lng,
        'altitude': point.altitude,
      },
      coordinates: coordinates,
    );

    return PlacemarkModel(
      id: user.userID.toString(),
      name: '${user.userName} ',
      lookAt: updatePosition ? lookAtObj : null,
      point: point,
      balloonContent: balloon ? (seeker? user.seekerBalloonContent(): user.giverBalloonContent()) : '',
      line: LineModel(
        id: user.userID.toString(),
        altitudeMode: 'absolute',
        coordinates: coordinates,
      ),
      tour: tour,
    );
  }

  /// Builds an `orbit` KML based on the given [user] 
  ///
  /// Returns a [String] that represents the `orbit` KML.
  String buildOrbit(UsersModel user,
      {LookAtModel? lookAt})  {
    LookAtModel lookAtObj;

    if (lookAt == null) {
      lookAtObj = LookAtModel(
        longitude: user.userCoordinates!.longitude,
        latitude: user.userCoordinates!.latitude,
        altitude: 0,
        range: '4000000',
        tilt: '60',
        heading: '0',
      );
    } else {
      lookAtObj = lookAt;
    }

    return OrbitModel.buildOrbit(OrbitModel.tag(lookAtObj));
  }
}
