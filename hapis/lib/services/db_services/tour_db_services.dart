import 'package:hapis/models/liquid_galaxy/tour_models/userlocation_model.dart';
import 'package:hapis/utils/extract_geocoordinates.dart';

import '../../helpers/sql_db.dart';
import '../../models/liquid_galaxy/tour_models/city_model.dart';
import '../../models/liquid_galaxy/tour_models/country_model.dart';

class TourDBServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  Future<List<CountryModel>> getCountries() async {
    String sqlStatement = '''
  SELECT DISTINCT Country 
  FROM Users;
  ''';

    List<CountryModel> countries = [];
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

      for (var row in queryResult) {
        String countryName = row['Country'];

        LatLng coords;
        coords = await getCoordinates(countryName);

        List<CityModelTour> cities = await getCitiesForCountry(countryName);

        CountryModel country = CountryModel(
            countryName, coords.longitude, coords.latitude, cities);
        countries.add(country);
      }
    } catch (e) {
      print('An error occurred: $e');

      return [];
    }

    return countries;
  }

  Future<List<CityModelTour>> getCitiesForCountry(String countryName) async {
    String sqlStatement = '''
      SELECT DISTINCT City
      FROM Users
      WHERE Country = '$countryName';
    ''';

    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

      List<CityModelTour> cities = [];
      for (var row in queryResult) {
        String cityName = row['City'];

        LatLng coords;
        coords = await getCoordinates(cityName);

        List<UserLocationModel> userAddresses =
            await getUserAddressesForCity(cityName);

        CityModelTour city = CityModelTour(
            cityName, coords.longitude, coords.latitude, userAddresses);
        cities.add(city);
      }

      return cities;
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }

  Future<List<UserLocationModel>> getUserAddressesForCity(
      String cityName) async {
    String sqlStatement = '''
      SELECT AddressLocation, FirstName, LastName,  UserName, PhoneNum,Email
      FROM Users
      WHERE City = '$cityName';
    ''';

    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

      List<UserLocationModel> addresses = [];
      for (var row in queryResult) {
        String address = row['AddressLocation'];
        String phone = row['PhoneNum'];
        String username = row['UserName'];
        String email = row['Email'];
        String firstName = row['FirstName'];
        String lastName = row['LastName'];
        LatLng coords;
        coords = await getCoordinates(address);

        UserLocationModel userLocation = UserLocationModel(
            username,
            address,
            coords.longitude,
            coords.latitude,
            firstName,
            lastName,
            phone,
            email);
        addresses.add(userLocation);
      }

      return addresses;
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }
}
