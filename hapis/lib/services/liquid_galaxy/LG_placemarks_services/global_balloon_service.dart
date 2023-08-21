

import '../../../models/liquid_galaxy/balloon_models/global_stats_model.dart';
import '../../../models/liquid_galaxy/kml/line_model.dart';
import '../../../models/liquid_galaxy/kml/look_at_model.dart';
import '../../../models/liquid_galaxy/kml/orbit_model.dart';
import '../../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../../models/liquid_galaxy/kml/point_model.dart';
import '../../../models/liquid_galaxy/kml/tour_model.dart';

/// The `GlobalBalloonService` class handles building KML elements for global statistics balloons and orbits.
class GlobalBalloonService {

  /// Builds and returns a globe `Placemark` entity based on the given [globe].
  ///
  /// The [balloon] parameter determines whether to include balloon content.
  /// The [orbitPeriod] specifies the orbit period.
  /// The [lookAt] parameter can be used to set a custom LookAt configuration.
  /// The [updatePosition] parameter determines whether to update the position.
  /// 
  PlacemarkModel buildGlobalPlacemark(
    GlobeModel globe,
    bool balloon,
    double orbitPeriod, {
    LookAtModel? lookAt,
    bool updatePosition = true,
  }) {
    LookAtModel lookAtObj;

    if (lookAt == null) {
      lookAtObj = LookAtModel(
        longitude: -60.4518936,
        latitude: -47.0000101,
        range: '31231212.86',
        tilt: '0',
        altitude: -47.0000101,
        heading: '0',
        altitudeMode: 'relativeToSeaFloor',
      );
    } else {
      lookAtObj = lookAt;
    }

    final point = PointModel(
        lat: lookAtObj.latitude,
        lng: lookAtObj.longitude,
        altitude: lookAtObj.altitude);
    final coordinates = globe.getGlobeOrbitCoordinates(step: orbitPeriod);

    final tour = TourModel(
      name: 'GlobeTour',
      placemarkId: 'p-${globe.id}',
      initialCoordinate: {
        'lat': point.lat,
        'lng': point.lng,
        'altitude': point.altitude,
      },
      coordinates: coordinates,
    );

    return PlacemarkModel(
      id: globe.id,
      name: 'Global Statistics',
      lookAt: updatePosition ? lookAtObj : null,
      point: point,
      balloonContent: balloon ? globe.balloonContent() : '',
      icon: 'earth.png',
      line: LineModel(
        id: globe.id,
        altitudeMode: 'absolute',
        coordinates: coordinates,
      ),
      tour: tour,
    );
  }

 
  /// Builds an `orbit` KML based on global statistics.
  ///
  /// The [lookAt] parameter can be used to set a custom LookAt configuration.
  /// Returns a [String] representing the `orbit` KML.
  /// 
  String buildOrbit({LookAtModel? lookAt}) {
    LookAtModel lookAtObj;

    if (lookAt == null) {
      lookAtObj = LookAtModel(
        longitude: -45.4518936,
        latitude: -47.0000101,
        range: '31231212.86',
        tilt: '0',
        altitude: 50000.1097385,
        heading: '0',
        altitudeMode: 'relativeToSeaFloor',
      );
    } else {
      lookAtObj = lookAt;
    }

    return OrbitModel.buildOrbit(OrbitModel.tag(lookAtObj));
  }
}
