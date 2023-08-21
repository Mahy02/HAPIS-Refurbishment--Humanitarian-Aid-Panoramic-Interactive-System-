import 'package:hapis/models/liquid_galaxy/tour_models/userlocation_model.dart';


/// Represents a city model for a tour, including its name, geographical coordinates, and associated user locations.
class CityModelTour {
  /// The name of the city.
  String name;

  /// The longitude coordinate of the city's location.
  double longitude;

   /// The latitude coordinate of the city's location.
  double latitude;

  /// A list of user locations associated with this city model.
  List<UserLocationModel> userLocations;


 
  /// Constructs a `CityModelTour` instance with the provided properties.
  ///
  /// The `name` parameter is the name of the city.
  ///
  /// The `longitude` parameter is the longitude coordinate of the city's location.
  ///
  /// The `latitude` parameter is the latitude coordinate of the city's location.
  ///
  /// The `userLocations` parameter is a list of [UserLocationModel] instances representing user locations associated with this city.
  CityModelTour(this.name, this.longitude, this.latitude, this.userLocations);
}

