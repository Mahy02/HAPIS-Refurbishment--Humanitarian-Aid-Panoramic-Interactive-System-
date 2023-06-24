import 'package:hapis/models/db_models/users_model.dart';

import '../../helpers/sql_db.dart';

class UserServices {
  // Future<List<String>> getCities() async {
  //    String selectSql = 'SELECT DISTINCT City FROM Users';
  //    //results is a list of map
  //   List<Map<String, dynamic>> results = await SqlDb().readData(selectSql);
  //   List<String> cities = results.map((row) => row['City'] as String).toList();
  //   return cities;

  // List<Map<String, dynamic>> results = await database.rawQuery(
  //   'SELECT DISTINCT city, country FROM your_table_name',
  // );
  // }
  Future<List<Map<String, String>>> getCitiesAndCountries() async {
    List<Map<String, String>> results = [
      {'city': 'Cairo', 'country': 'Egypt'},
      {'city': 'Lleida', 'country': 'Spain'},
      {'city': 'San Francisco', 'country': 'United States'},
      {'city': 'Edinburgh', 'country': 'United Kingdom'},
      {'city': 'Tokyo', 'country': 'Japan'},
      {'city': 'Cairo', 'country': 'Egypt'},
      {'city': 'Lleida', 'country': 'Spain'},
      {'city': 'San Francisco', 'country': 'United States'},
      {'city': 'Edinburgh', 'country': 'United Kingdom'},
      {'city': 'Tokyo', 'country': 'Japan'},
      {'city': 'Cairo', 'country': 'Egypt'},
      {'city': 'Lleida', 'country': 'Spain'},
      {'city': 'San Francisco', 'country': 'United States'},
      {'city': 'Edinburgh', 'country': 'United Kingdom'},
      {'city': 'Tokyo', 'country': 'Japan'},
      // Additional rows...
    ];

    return results;
  }
}
