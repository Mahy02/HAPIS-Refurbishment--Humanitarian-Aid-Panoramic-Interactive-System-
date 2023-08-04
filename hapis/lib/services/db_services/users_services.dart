import 'package:big_dart/big_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/sql_db.dart';
import '../../models/db_models/user_model.dart';
import '../../providers/user_provider.dart';
import 'package:decimal/decimal.dart';

///   `userServices` class that contains everything related to the users query and interactions with the database
class UserServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  String capitalizeFirstLetter(String text) {
    if (text == null || text.isEmpty) return text;

    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    }

    return words.join(' ');
  }

// Updated `getCitiesAndCountries` function.
  Future<List<Map<String, String>>> getCitiesAndCountries() async {
    String sqlStatement = '''
  SELECT DISTINCT LOWER(City) as City, LOWER(Country) as Country
  FROM Users
  ''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
    print(queryResult);
    List<Map<String, String>> results = queryResult.map((row) {
      return {
        'city': capitalizeFirstLetter(row['City'] as String),
        'country': capitalizeFirstLetter(row['Country'] as String),
      };
    }).toList();

    return results;
  }

  // /// `getCitiesAndCountries` function that retrives all cities and countries from USERS table in database and return the results in List of Maps
  // Future<List<Map<String, String>>> getCitiesAndCountries() async {
  //   String sqlStatement = '''
  //   SELECT DISTINCT LOWER(City) as City, LOWER(Country) as Country
  //   FROM Users
  // ''';

  //   List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
  //   List<Map<String, String>> results = queryResult.map((row) {
  //     return {
  //       'city': row['City'] as String,
  //       'country': row['Country'] as String,
  //     };
  //   }).toList();

  //   return results;
  // }

  Future<String> getCity(String id) async {
    String sqlStatement = '''
        SELECT City
        FROM Users
        WHERE UserID = '$id'
    ''';
    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
    print(queryResult);

    return queryResult.first['City'];
  }

  Future<UserModel> getUser(String id) async {
    String sqlStatement = '''
        SELECT *
        FROM Users
        WHERE UserID = '$id'
    ''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
    List<UserModel> user = queryResult
        .map((row) => UserModel(
            userID: row['UserID'],
            userName: row['UserName'],
            firstName: row['FirstName'],
            lastName: row['LastName'],
            city: row['City'],
            country: row['Country'],
            addressLocation: row['AddressLocation'],
            phoneNum: row['PhoneNum'],
            email: row['Email'],
            pass: row['Password']))
        .toList();

    return user[0];
  }

  /// `getUsersInfo` that retrieves all users info for those who filled out a form as a seeker or a giver
  /// the function takes in  `type` of user and retrieves the form info and user info from both Forms and Users tables
  /// It creates a new `UserModel` with the data and use the `UserAppProvider` to save list of seekers and givers
  getUsersInfo(String type, BuildContext context) async {
    String sqlStatment = '''
      SELECT Users.UserID AS UserUserID, FormID, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email, Item, Category, Dates_available, For
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Forms.Type = '$type' AND Forms.Status = 'Not Completed' 
    ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);
    UserAppProvider userProvider =
        Provider.of<UserAppProvider>(context, listen: false);

    for (Map<String, dynamic> row in result) {
      try {
        print('inside get users forms');
        String id = row['UserUserID'];
        print(id);

        UserModel user = UserModel(
          userID: row['UserUserID'],
          formID: row['FormID'],
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

  Future<bool> isFormInProgress(int formId) async {
    // Check in the 'requests' table
    String sqlStatementsR = '''
    SELECT COUNT(*) as countR 
    FROM Requests 
    WHERE Donation_Status = 'In progress' AND Rec_FormID = $formId
  ''';
    final resultR = await db.readData(sqlStatementsR);
    int requestsCount = resultR[0]['countR'];

    String sqlStatementsM = '''
     SELECT COUNT(*) as countM 
     FROM Matchings 
     WHERE Donation_Status = 'In progress' AND (Seeker_FormID = $formId OR Giver_FormID = $formId)
  ''';

    final resultM = await db.readData(sqlStatementsM);
    int matchingsCount = resultM[0]['countM'];

    // Return true if either of the counts is greater than 0
    return requestsCount > 0 || matchingsCount > 0;
  }

  Future<List<UserModel>> getUserForms(String id) async {
    print('inside user forms');
    print(id);

    String sqlStatment = '''
      SELECT Users.UserID AS UserUserID, FormID, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email, Item, Category, Dates_available, For, Type
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Forms.Status = 'Not Completed' AND Forms.UserID = '$id'
    ''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatment);
    print('res: $queryResult');
    List<UserModel> forms = queryResult
        .map((row) => UserModel(
              userID: id,
              formID: row['FormID'],
              userName: row['UserName'],
              firstName: row['FirstName'],
              lastName: row['LastName'],
              city: row['City'],
              country: row['Country'],
              addressLocation: row['AddressLocation'],
              phoneNum: row['PhoneNum'],
              email: row['Email'],
              type: row['Type'],
              item: row['Item'],
              category: row['Category'],
              multiDates: row['Dates_available'],
              forWho: row['For'],
            ))
        .toList();

    return forms;
  }

  Future<int> createNewForm(String userID, String type, String item,
      String category, String dates, String? forWho, String status) async {
    print('inside create form');
    print(userID);

    String sqlStatment = '''
    INSERT INTO Forms (UserID , Type, Item, Category, Dates_available, For, Status)
        VALUES ('$userID' , '$type', '$item', '$category', '$dates', '${forWho ?? ''}', '$status')
    ''';
    print(sqlStatment);
    int rowID = await db.insertData(sqlStatment);
    print('rowId');
    print(rowID);

    return rowID;
  }

  Future<int> updateForm(
      String userID,
      String type,
      String item,
      String category,
      String dates,
      String? forWho,
      String status,
      int formID) async {
    String sqlStatment = '''
    UPDATE Forms
    SET UserID= '$userID' , Type= '$type', Item='$item' , Category='$category' , Dates_available='$dates', For= '${forWho ?? ''}',Status='$status'
    WHERE FormID = $formID
    ''';

    int rowID = await db.updateData(sqlStatment);

    return rowID;
  }

  /// `deleteForm` deletes a form given an id
  Future<int> deleteForm(int id) async {
    String sqlStatement = '''
    DELETE FROM Forms
    WHERE FormID= $id
    ''';
    int queryResult = await db.deleteData(sqlStatement);
    return queryResult;
  }

  Future<int> deleteUser(String id) async {
    String sqlStatement = '''
    DELETE FROM Users
    WHERE UserID= '$id'
    ''';
    int queryResult = await db.deleteData(sqlStatement);
    return queryResult;
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
      ) VALUES ('$userID', '$userName', '$firstName', '$lastName', '$city', '$counrty', '$address', '$phoneNum', '$email', '${password ?? ''}')
    ''';

    int result = await db.insertData(sqlStatment);
    print('after creating new user');
    print(result);
    return result;
  }

  Future<int> updateNewUser(
      String userID,
      String userName,
      String firstName,
      String lastName,
      String counrty,
      String city,
      String phoneNum,
      String address,
      String email,
      String? password) async {
    String sqlStatment = '''
    UPDATE Users
    SET  UserName = '$userName' ,  FirstName= '$firstName',  LastName= '$lastName', City= '$city', Country= '$counrty', AddressLocation=  '$address', PhoneNum='$phoneNum' ,Email='$email', Password='${password ?? ''}'
    WHERE UserID= '$userID'
    ''';

    int result = await db.updateData(sqlStatment);

    return result;
  }

  /// `doesGoogleUserExist` function that checks if a user signed in by google exists or not from taking the `userId` and `email`
  /// It returns a Future<int> for the count found , if it was >0 then user was found
  Future<int> doesGoogleUserExist(String userId, String email) async {
    String sqlStatment = '''
      SELECT COUNT(*) AS count FROM Users WHERE UserID = '$userId' AND Email = "$email"
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

  //tirals:
  Future<int> bla() async {
    String sqlStatment = '''
      SELECT COUNT(*) AS count FROM Users WHERE UserID = 0
      ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);
    int count = result[0]['count'];
    return count;
  }
}
