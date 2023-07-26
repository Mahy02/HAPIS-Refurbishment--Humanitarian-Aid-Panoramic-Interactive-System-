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

  Future<int> createNewUser(
      {required String userID,
      required String userName,
      required String firstName,
      required String lastName,
      required String counrty,
      required String city,
      required String phoneNum,
      required String address,
      required String email,
      String? password}) async {
    String sqlStatment = '''
      INSERT INTO Users (
        UserID,
        UserName,
        FirstName,
        LastName,
        City,
        Country,
        AddressLocation,
        PhoneNum,
        Email,
        Password
      ) VALUES ($userID, '$userName', '$firstName', '$lastName', '$city', '$counrty', '$address', '$phoneNum', '$email', '${password ?? ''}')
    ''';

    int result = await db.insertData(sqlStatment);

    return result;
  }

  Future<int> doesGoogleUserExist(String userId, String email) async {
    String sqlStatment = '''
      SELECT COUNT(*) AS count FROM Users WHERE UserID = $userId AND Email = "$email"
      ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);
    int count = result[0]['count'];
    return count;
  }

  // Future<Map<String, dynamic>> getRow() async {
  //   final List<Map<String, dynamic>> result =
  //       await db.readData('SELECT * FROM Users WHERE UserID = 50 ');
  //   if (result.isNotEmpty) {
  //     return result.first;
  //   } else {
  //     return Map<String, dynamic>();
  //     ;
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getAllUsers() async {
  //   final List<Map<String, dynamic>> result =
  //       await db.readData('SELECT * FROM Users');
  //   return result;
  // }

  // Future<int> doesNormalUserExist(String password, String email) async {
  //   String sqlStatment = '''
  //     SELECT COUNT(*) AS count FROM Users WHERE Password = '$password' AND Email = '$email'
  //     ''';

  //   List<Map<String, dynamic>> result = await db.readData(sqlStatment);
  //   int count = result[0]['count'];

  //   return count;
  // }
  Future<String> doesNormalUserExist(String password, String email) async {
  String sqlStatement = '''
    SELECT UserID FROM Users WHERE Password = '$password' AND Email = '$email'
    ''';

  List<Map<String, dynamic>> result = await db.readData(sqlStatement);
  if (result.isEmpty) {
    return '';
  } else {
    return result[0]['UserID'];
  }
}
}
