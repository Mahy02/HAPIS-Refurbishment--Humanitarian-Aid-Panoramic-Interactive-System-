import 'package:hapis/models/liquid_galaxy/tour_models/city_model.dart';

/// Represents a country model for a tour, including its name, geographical coordinates, and associated cities.
class CountryModel {
  /// The name of the country.
  String name;

  /// The longitude coordinate of the country's location.
  double longitude;

  /// The latitude coordinate of the country's location
  double latitude;

  /// A list of city models associated with this country model.
  List<CityModelTour> cities;


  
  /// Constructs a `CountryModel` instance with the provided properties.
  ///
  /// The `name` parameter is the name of the country.
  ///
  /// The `longitude` parameter is the longitude coordinate of the country's location.
  ///
  /// The `latitude` parameter is the latitude coordinate of the country's location.
  ///
  /// The `cities` parameter is a list of [CityModelTour] instances representing cities associated with this country.

  CountryModel(this.name, this.longitude, this.latitude, this.cities);
}

