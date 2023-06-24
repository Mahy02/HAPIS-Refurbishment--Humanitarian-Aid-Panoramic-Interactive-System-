import 'package:geocoding/geocoding.dart';

///function that takes an address (can be a full address or a city name) and returns list of locations
///Locations can be => latitudem longitude, altitude
Future<LatLng> getCoordinates(String address) async {
  List<Location> locations = await locationFromAddress(address);
   Location location = locations.first;
  return LatLng(location.latitude, location.longitude);
  //return locations;
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}

///Usage example:
///-------------
/// String cityName = "New York";
/// List<Location> cityLocations = await getCoordinates(cityName);
/// if (cityLocations.isNotEmpty) {
///   Location firstLocation = cityLocations.first;
///   double latitude = firstLocation.latitude;
///   double longitude = firstLocation.longitude;
///   double altitude = firstLocation.altitude;

