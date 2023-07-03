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
      // String formattedLongitude = NumberFormat('#,##0.##°').format(-45.4518936);
      // String formattedLatitude = NumberFormat('#,##0.##°').format(0.0000101);
      // String formattedRange = NumberFormat('#,##0.## m').format(22231212.86);
      // String formattedAltitude = NumberFormat('#,##0.## m').format(20540.1097385);
      // String formattedHeading = NumberFormat('#,##0.##°').format(0);
      // String formattedTilt = NumberFormat('#,##0.##°').format(0);

      lookAtObj = LookAtModel(
          // longitude: -3.629954,
          // latitude: 40.769083,
          // range: '900000000.0',
          // tilt: '0',
          // altitude: 0,
          // heading: '0',
          // altitudeMode: 'relativeToSeaFloor'
          longitude: -45.4518936,
          latitude: 0.0000101,
          range: '22231212.86',
          tilt: '60',
          //altitude: 20540.1097385,
          altitude: 25512.1097385,
          //altitude: 20000.1097385,
          heading: '0',
          altitudeMode: 'relativeToSeaFloor');
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
          // longitude: -3.629954,
          // latitude: 40.769083,
          // range: '90000000000',
          // tilt: '0',
          // altitude: 0,
          // heading: '0',
          // altitudeMode: 'relativeToSeaFloor'
          longitude: -45.4518936,
          latitude: 0.0000101,
          range: '22231212.86',
          tilt: '60',
          //altitude: 20540.1097385,
          altitude: 25512.1097385,
          //altitude: 20000.1097385,
          heading: '0',
          altitudeMode: 'relativeToSeaFloor');
    } else {
      lookAtObj = lookAt;
    }

    return OrbitModel.buildOrbit(OrbitModel.tag(lookAtObj));
  }
}
