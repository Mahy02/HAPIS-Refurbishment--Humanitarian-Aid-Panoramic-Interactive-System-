import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

///function that takes an address (can be a full address or a city name) and returns list of locations
///Locations can be => latitudem longitude, altitude
Future<LatLng> getCoordinates(String address) async {
  print(address);
  List<Location> locations = await locationFromAddress(address);
  Location location = locations.first;
  print(location.latitude);
  print(location.longitude);
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

Future<String?> getCountryFromCity(String cityName) async {
  try {
    List<Location> locations = await geocoding.locationFromAddress(cityName);
    if (locations.isNotEmpty) {
      final coordinates = locations[0];
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(
              coordinates.latitude, coordinates.longitude);
      if (placemarks.isNotEmpty) {
        final country = placemarks[0].country;
        return country;
      }
    }
  } catch (e) {
    print('Error getting country: $e');
  }
  return null;
}

Future<String?> getPlaceIdFromAddress(String address) async {
  try {
    // Geocode the address to get the coordinates
    List<Location> locations = await locationFromAddress(address);
    if (locations.isEmpty) {
      return null; // Address not found
    }

    // Reverse geocode the coordinates to get the place details
    List<Placemark> placemarks = await placemarkFromCoordinates(
        locations.first.latitude, locations.first.longitude);
    if (placemarks.isEmpty) {
      return null; // Place details not found
    }

    // Convert the placemark to a map and extract the place ID
    Map<String, dynamic> placemarkMap = placemarks.first.toJson();
    String? placeId = placemarkMap['placeId'];

    return placeId;
  } catch (e) {
    print('Error retrieving place ID: $e');
    return null;
  }
}
