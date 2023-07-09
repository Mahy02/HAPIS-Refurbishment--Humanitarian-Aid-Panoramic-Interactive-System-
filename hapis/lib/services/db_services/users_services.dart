

import '../../helpers/sql_db.dart';

class UserServices {

  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  /// `getCitiesAndCountries` function that retrives all cities and countries from USERS table in database and return the results in List of Maps
  Future<List<Map<String, String>>> getCitiesAndCountries() async {
    String sqlStatement = '''
    SELECT DISTINCT City, Country
    FROM Users
  ''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
    List<Map<String, String>> results = queryResult.map((row) {
      return {
        'city': row['City'] as String,
        'country': row['Country'] as String,
      };
    }).toList();

    return results;
  }
}
