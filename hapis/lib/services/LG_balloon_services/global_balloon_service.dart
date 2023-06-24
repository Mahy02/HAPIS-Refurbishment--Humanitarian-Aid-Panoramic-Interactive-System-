/*
 /// Builds and returns a satellite `Placemark` entity according to the given
  /// [satellite], [tle], [transmitters] and more.
  PlacemarkEntity buildPlacemark(
    SatelliteEntity satellite,
    TLEEntity tle,
    List<TransmitterEntity> transmitters,
    bool balloon,
    double orbitPeriod, {
    LookAtEntity? lookAt,
    bool updatePosition = true,
  }) {
    LookAtEntity lookAtObj;

    if (lookAt == null) {
      final coord = tle.read();

      lookAtObj = LookAtEntity(
        lng: coord['lng']!,
        lat: coord['lat']!,
        altitude: coord['alt']!,
        range: '4000000',
        tilt: '60',
        heading: '0',
      );
    } else {
      lookAtObj = lookAt;
    }

    final point = PointEntity(
      lat: lookAtObj.lat,
      lng: lookAtObj.lng,
      altitude: lookAtObj.altitude,
    );

    satellite.tle = tle;

    final coordinates = satellite.getOrbitCoordinates(step: orbitPeriod);

    final tour = TourEntity(
      name: 'SimulationTour',
      placemarkId: 'p-${satellite.id}',
      initialCoordinate: {
        'lat': point.lat,
        'lng': point.lng,
        'altitude': point.altitude,
      },
      coordinates: coordinates,
    );

    return PlacemarkEntity(
      id: satellite.id,
      name: '${satellite.name} (${satellite.getStatusLabel().toUpperCase()})',
      lookAt: updatePosition ? lookAtObj : null,
      point: point,
      description: satellite.citation,
      balloonContent:
          balloon ? satellite.balloonContent(transmitters.length) : '',
      icon: 'satellite.png',
      line: LineEntity(
        id: satellite.id,
        altitudeMode: 'absolute',
        coordinates: coordinates,
      ),
      tour: tour,
    );
  }

  /// Builds an `orbit` KML based on the given [satellite] and [tle].
  ///
  /// Returns a [String] that represents the `orbit` KML.
  String buildOrbit(SatelliteEntity satellite, TLEEntity tle,
      {LookAtEntity? lookAt}) {
    LookAtEntity lookAtObj;

    if (lookAt == null) {
      final coord = tle.read();

      lookAtObj = LookAtEntity(
        lng: coord['lng']!,
        lat: coord['lat']!,
        altitude: coord['alt']!,
        range: '4000000',
        tilt: '60',
        heading: '0',
      );
    } else {
      lookAtObj = lookAt;
    }

    return OrbitEntity.buildOrbit(OrbitEntity.tag(lookAtObj));
  }
}

*/