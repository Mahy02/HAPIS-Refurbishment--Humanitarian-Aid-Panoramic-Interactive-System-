import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/sql_db.dart';
import '../../models/db_models/user_model.dart';
import '../../providers/user_provider.dart';

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

  getUsersInfo(String type, BuildContext context) async {
    String sqlStatment = '''
      SELECT Users.UserID AS UserUserID, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email, Item, Category, Dates_available, For
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Forms.Type = '$type' AND Forms.Status = 'Not Completed'
    ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);
    UserAppProvider userProvider =
        Provider.of<UserAppProvider>(context, listen: false);

    for (Map<String, dynamic> row in result) {
      try {
        UserModel user = UserModel(
          userID: row['UserUserID'],
          userName: row['UserName'],
          firstName: row['FirstName'],
          lastName: row['LastName'],
          city: row['City'],
          country: row['Country'],
          addressLocation: row['AddressLocation'],
          phoneNum: row['PhoneNum'],
          email: row['Email'],
          type: type,
          item: row['Item'],
          category: row['Category'],
          multiDates: row['Dates_available'],
          forWho: row['For'],
        );
        if (type == 'seeker') {
          userProvider.saveSeekersApp(user);
        } else {
          userProvider.saveGiversApp(user);
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }
}
