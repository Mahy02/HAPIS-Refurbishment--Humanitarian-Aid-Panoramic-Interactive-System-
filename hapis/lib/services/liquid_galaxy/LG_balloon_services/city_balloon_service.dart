import 'package:hapis/models/db_models/users_model.dart';
import 'package:hapis/models/liquid_galaxy/kml/look_at_model.dart';

import '../../../models/balloon_models/city_ballon_model.dart';
import '../../../models/liquid_galaxy/kml/line_model.dart';
import '../../../models/liquid_galaxy/kml/orbit_model.dart';
import '../../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../../models/liquid_galaxy/kml/point_model.dart';
import '../../../models/liquid_galaxy/kml/tour_model.dart';

class CityBalloonService {
  /// Builds and returns a city `Placemark` entity according to the given [city]
  PlacemarkModel buildCityPlacemark(
    CityModel city,
    bool balloon,
    double orbitPeriod, {
    LookAtModel? lookAt,
    bool updatePosition = true,
  }) {
    LookAtModel lookAtObj;

    if (lookAt == null) {
      lookAtObj = LookAtModel(
          longitude: city.cityCoordinates.longitude,
          latitude: city.cityCoordinates.latitude,
          range: '4000000',
          // range: '2000000',
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
        city.getCityOrbitCoordinates(city.name, step: orbitPeriod);
    final tour = TourModel(
      name: 'CityTour',
      placemarkId: 'p-${city.id}',
      initialCoordinate: {
        'lat': point.lat,
        'lng': point.lng,
        'altitude': point.altitude,
      },
      coordinates: coordinates,
    );

    return PlacemarkModel(
      id: city.id,
      name: '${city.name} ',
      lookAt: updatePosition ? lookAtObj : null,
      point: point,
      balloonContent: balloon ? city.balloonContent() : '',
      icon: 'cityballoon.png',
      line: LineModel(
        id: city.id,
        altitudeMode: 'absolute',
        coordinates: coordinates,
      ),
      tour: tour,
    );
  }

  /// Builds an `orbit` KML based on the given [city]
  ///
  /// Returns a [String] that represents the `orbit` KML.
  String buildOrbit(CityModel city, {LookAtModel? lookAt}) {
    LookAtModel lookAtObj;

    if (lookAt == null) {
      lookAtObj = LookAtModel(
        longitude: city.cityCoordinates.longitude,
        latitude: city.cityCoordinates.latitude,
        altitude: 0,
        range: '4000000',
        // range: '2000000',
        tilt: '60',
        heading: '0',
      );
    } else {
      lookAtObj = lookAt;
    }

    return OrbitModel.buildOrbit(OrbitModel.tag(lookAtObj));
  }
}
