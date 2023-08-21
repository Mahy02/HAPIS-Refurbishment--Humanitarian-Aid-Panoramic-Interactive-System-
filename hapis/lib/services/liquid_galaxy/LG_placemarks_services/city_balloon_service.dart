
import 'package:hapis/models/liquid_galaxy/kml/look_at_model.dart';


import '../../../models/liquid_galaxy/balloon_models/city_ballon_model.dart';
import '../../../models/liquid_galaxy/kml/line_model.dart';
import '../../../models/liquid_galaxy/kml/orbit_model.dart';
import '../../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../../models/liquid_galaxy/kml/point_model.dart';
import '../../../models/liquid_galaxy/kml/tour_model.dart';

/// The `CityBalloonService` class handles building KML elements for city balloons and orbits.
class CityBalloonService {

  /// Builds and returns a city `Placemark` entity based on the given [city].
  ///
  /// The [balloon] parameter determines whether to include balloon content.
  /// The [orbitPeriod] specifies the orbit period.
  /// The [lookAt] parameter can be used to set a custom LookAt configuration.
  /// The [updatePosition] parameter determines whether to update the position.
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

  /// Builds an `orbit` KML for the given [city].
  ///
  /// The [lookAt] parameter can be used to set a custom LookAt configuration.
  /// Returns a [String] representing the `orbit` KML.
  /// 
  String buildOrbit(CityModel city, {LookAtModel? lookAt}) {
    LookAtModel lookAtObj;

    if (lookAt == null) {
      lookAtObj = LookAtModel(
        longitude: city.cityCoordinates.longitude,
        latitude: city.cityCoordinates.latitude,
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
