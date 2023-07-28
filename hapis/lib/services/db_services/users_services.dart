import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/sql_db.dart';
import '../../models/db_models/user_model.dart';
import '../../providers/user_provider.dart';

///   `userServices` class that contains everything related to the users query and interactions with the database
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

  /// `getUsersInfo` that retrieves all users info for those who filled out a form as a seeker or a giver
  /// the function takes in  `type` of user and retrieves the form info and user info from both Forms and Users tables
  /// It creates a new `UserModel` with the data and use the `UserAppProvider` to save list of seekers and givers
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

///  `createNewUser` that creats a new user during sign up and adds him to database
/// It returns a Future<int> for whether the transaction was sucessful or not
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

/// `doesGoogleUserExist` function that checks if a user signed in by google exists or not from taking the `userId` and `email`
/// It returns a Future<int> for the count found , if it was >0 then user was found
  Future<int> doesGoogleUserExist(String userId, String email) async {
    String sqlStatment = '''
      SELECT COUNT(*) AS count FROM Users WHERE UserID = $userId AND Email = "$email"
      ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);
    int count = result[0]['count'];
    return count;
  }

/// `doesNormalUserExist` function that checks if a user signed in with email and password exists or not from taking the `password` and `email`
/// It returns a Future<String> for the userID if the user was found and retuns 0 if wasn't found
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
