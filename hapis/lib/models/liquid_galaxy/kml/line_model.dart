/// Class that defines the `line` entity, which contains its properties and methods.
class LineModel{
  /// Property that defines the line `id`.
  String id;

  /// Property that defines the line `coordinates` list.
  List<Map<String, double>> coordinates;

  /// Property that defines the line `draw order`.
  double drawOrder;

  /// Property that defines the line `altitude mode`.
  ///
  /// Defaults to `relativeToGround`.
  String altitudeMode;

  LineModel({
    required this.id,
    required this.coordinates,
    this.drawOrder = 0,
    this.altitudeMode = 'relativeToGround',
  });

  /// Property that defines the line `tag` according to its current properties.
  ///
  /// Example
  /// ```
  /// LineEntity line = LineEntity(
  ///   id: "123abc",
  ///   coordinates: [
  ///     {
  ///       'lng': 32,
  ///       'lat': -74,
  ///       'altitude': 0,
  ///     },
  ///     {
  ///       'lng': 34,
  ///       'lat': -78,
  ///       'altitude': 0,
  ///     },
  ///   ],
  /// )
  /// line.tag => '''
  ///   <Polygon id="123abc">
  ///     <extrude>0</extrude>
  ///     <altitudeMode>relativeToGround</altitudeMode>
  ///     <outerBoundaryIs>
  ///       <LinearRing>
  ///         <coordinates>
  ///           32,-74,0 34,-78,0
  ///         </coordinates>
  ///       </LinearRing>
  ///     </outerBoundaryIs>
  ///   </Polygon>
  /// '''
  /// ```
  String get tag => '''
      <Polygon id="$id">
        <extrude>0</extrude>
        <altitudeMode>$altitudeMode</altitudeMode>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>
              $linearCoordinates
            </coordinates>
          </LinearRing>
        </outerBoundaryIs>
      </Polygon>
    ''';

  /// Property that defines the line `linear coordinates` according to its current [coordinates].
  ///
  /// Example
  /// ```
  /// LineEntity line = LineEntity(
  ///   ...
  ///   coordinates: [
  ///     {
  ///       'lng': 32,
  ///       'lat': -74,
  ///       'altitude': 0,
  ///     },
  ///     {
  ///       'lng': 34,
  ///       'lat': -78,
  ///       'altitude': 0,
  ///     },
  ///   ],
  ///   ...
  /// )
  /// line.linearCoordinates => '32,-74,0 34,-78,0'
  /// ```
  String get linearCoordinates {
    String coords = coordinates
        .map((coord) => '${coord['lng']},${coord['lat']},${coord['altitude']}')
        .join(' ');

    return coords;
  }

  /// Returns a [Map] from the current [LineModel].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coordinates': coordinates,
      'altitudeMode': altitudeMode,
      'drawOrder': drawOrder,
    };
  }

  /// Returns a [LineModel] from the given [map].
  factory LineModel.fromMap(Map<String, dynamic> map) {
    return LineModel(
      id: map['id'],
      coordinates: map['coordinates'],
      altitudeMode: map['altitudeMode'],
      drawOrder: map['drawOrder'],
    );
  }
}
