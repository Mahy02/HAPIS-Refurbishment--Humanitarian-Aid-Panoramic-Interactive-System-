
import 'package:hapis/models/kml/line_model.dart';
import 'package:hapis/models/kml/look_at_model.dart';
import 'package:hapis/models/kml/placemark_model.dart';
import 'package:hapis/models/kml/point_model.dart';
import 'package:hapis/models/kml/tour_model.dart';

import '../../models/balloon_models/city_ballon_model.dart';
import '../../models/balloon_models/global_stats_model.dart';
import '../../models/kml/orbit_model.dart';

class GlobalBalloonService {
  /// Builds and returns a satellite `Placemark` entity according to the given [city]
  PlacemarkModel buildGlobalPlacemark(
    GlobeModel globe,
    bool balloon,
    double orbitPeriod, {
    LookAtModel? lookAt,
    bool updatePosition = true,
  })  {
    LookAtModel lookAtObj;

  

    if (lookAt == null) {
      lookAtObj = LookAtModel(
          longitude: 43,
          latitude: 12.6,
          range: '5000000',
          tilt: '0',
          altitude: 24938716.73,
          heading: '0');
    } else {
      lookAtObj = lookAt;
    }

    final point = PointModel(
        lat: lookAtObj.latitude,
        lng: lookAtObj.longitude,
        altitude: lookAtObj.altitude);
    final coordinates =
        globe.getCityOrbitCoordinates (step: orbitPeriod);
    final tour = TourModel(
      name: 'SimulationTour',
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
      //description: satellite.citation,
      balloonContent: balloon ? globe.balloonContent() : '',
      icon: 'satellite.png',
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
  String buildOrbit(
      {LookAtModel? lookAt})  {
    LookAtModel lookAtObj;

//final LatLng coord = await getCoordinates(city.name);
    if (lookAt == null) {
     // final coord = tle.read();

      lookAtObj = LookAtModel(
        longitude: 42,
        latitude: 12.6,
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
