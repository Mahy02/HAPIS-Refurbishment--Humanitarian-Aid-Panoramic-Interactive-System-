import 'package:hapis/models/kml/line_model.dart';
import 'package:hapis/models/kml/look_at_model.dart';
import 'package:hapis/models/kml/placemark_model.dart';
import 'package:hapis/models/kml/point_model.dart';
import 'package:hapis/models/kml/tour_model.dart';
import '../../models/balloon_models/global_stats_model.dart';
import '../../models/kml/orbit_model.dart';

class GlobalBalloonService {
  /// Builds and returns a globe `Placemark` entity
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
        //longitude: -140.4518936,
        //latitude: 0.0000101,
        latitude: -47.0000101,
        // range: '90000000000',
        range: '31231212.86',
        //tilt: '0',
        tilt: '0',
        //altitude: 0,
        //altitude: 25540.1097385,
        altitude: 50000.1097385,
        heading: '0',
        altitudeMode: 'relativeToSeaFloor',
      );
    } else {
      lookAtObj = lookAt;
    }

    print(lookAtObj.latitude);
    print(lookAtObj.longitude);
    print(lookAtObj.altitude);
    print(lookAtObj.range);
    print(lookAtObj.heading);

    final point = PointModel(
        lat: lookAtObj.latitude,
        lng: lookAtObj.longitude,
        altitude: lookAtObj.altitude);
    final coordinates = globe.getGlobeOrbitCoordinates(step: orbitPeriod);
    print(coordinates);
    print(point.lat);
    print(point.lng);
    print(point.altitude);

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

  /// Builds an `orbit` KML based on Globe
  ///
  /// Returns a [String] that represents the `orbit` KML.
  String buildOrbit({LookAtModel? lookAt}) {
    LookAtModel lookAtObj;

    print("inside build orbit");
    if (lookAt == null) {
      lookAtObj = LookAtModel(
        longitude: -45.4518936,
        // longitude: -140.4518936,
        //latitude: 0.0000101,
        latitude: -47.0000101,
        // range: '90000000000',
        range: '31231212.86',
        //tilt: '0',
        tilt: '0',
        //altitude: 0,
        //altitude: 25540.1097385,
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
