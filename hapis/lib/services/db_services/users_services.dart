import 'package:hapis/models/users_model.dart';

import '../../helpers/sql_db.dart';

class UserServices {
  Future<List<String>> getCities() async {
     String selectSql = 'SELECT DISTINCT City FROM Users';
     //results is a list of map
    List<Map<String, dynamic>> results = await SqlDb().readData(selectSql);
    List<String> cities = results.map((row) => row['City'] as String).toList();
    return cities;
  }
}

