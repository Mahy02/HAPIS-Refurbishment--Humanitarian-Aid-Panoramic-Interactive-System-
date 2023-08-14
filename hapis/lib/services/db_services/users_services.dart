import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/sql_db.dart';
import '../../models/db_models/user_model.dart';
import '../../providers/user_provider.dart';

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

  // Function to get the full name by id
  Future<String> getFullNameById(String userId) async {
    String sqlStatement = '''
      SELECT FirstName, LastName FROM Users
      WHERE UserID = '$userId'
    ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);

    if (results.isNotEmpty) {
      String firstName = results[0]['FirstName'] as String;
      String lastName = results[0]['LastName'] as String;
      return '$firstName $lastName';
    } else {
      return 'User not found'; // Return an error message or handle the case where the user is not found
    }
  }

// Updated `getCitiesAndCountries` function.
  Future<List<Map<String, String>>> getCitiesAndCountries() async {
    String sqlStatement = '''
  SELECT DISTINCT LOWER(City) as City, LOWER(Country) as Country
  FROM Users
  ''';
    List<Map<String, String>> results;
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

      results = queryResult.map((row) {
        return {
          'city': capitalizeFirstLetter(row['City'] as String),
          'country': capitalizeFirstLetter(row['Country'] as String),
        };
      }).toList();
    } catch (e) {
      print('An error occurred: $e');

      return [];
    }

    return results;
  }

  Future<String> getCity(String id) async {
    String sqlStatement = '''
        SELECT City
        FROM Users
        WHERE UserID = '$id'
    ''';
    List<Map<String, dynamic>> queryResult;
    try {
      queryResult = await db.readData(sqlStatement);
    } catch (e) {
      print('An error occurred: $e');

      return '';
    }

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
              // pass: row['Password']
            ))
        .toList();

    return user[0];
  }

  /// `getUsersInfo` that retrieves all users info for those who filled out a form as a seeker or a giver
  /// the function takes in  `type` of user and retrieves the form info and user info from both Forms and Users tables
  /// It creates a new `UserModel` with the data and use the `UserAppProvider` to save list of seekers and givers
  getUsersInfo(String type, BuildContext context) async {
    //Edited => ForWho and FormStatus and FormType
    String sql = '''
      SELECT hapisdb.Users.UserID AS UserUserID, FormID, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email, Item, Category, Dates_available, ForWho
      FROM hapisdb.Forms
      JOIN hapisdb.Users ON hapisdb.Forms.UserID = hapisdb.Users.UserID
      WHERE hapisdb.Forms.FormType = '$type' AND hapisdb.Forms.FormStatus = 'Not Completed'
    ''';

    List<Map<String, dynamic>> result = await db.readData(sql);

    UserAppProvider userProvider =
        Provider.of<UserAppProvider>(context, listen: false);

    print('after get users info');
    print(result);

    for (Map<String, dynamic> row in result) {
      try {
        UserModel user = UserModel(
          userID: row['UserUserID'],
          formID: int.parse(row['FormID']),
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
          forWho: row['ForWho'],
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
    //cannot delete if one of them is in progress
    print('forms in progress?????????');
    try {
      // Check in the 'requests' table
      String sqlStatementsR = '''
    SELECT COUNT(*) as countR 
    FROM Requests 
    WHERE (Rec1_Donation_Status = 'In progress' OR Rec2_Donation_Status = 'In progress') AND Rec_FormID = $formId
  ''';
      final resultR = await db.readData(sqlStatementsR);
      print(resultR);
      int requestsCount = int.parse(resultR[0]['countR']);

      String sqlStatementsM = '''
     SELECT COUNT(*) as countM 
     FROM Matchings 
     WHERE (Rec1_Donation_Status = 'In progress' OR Rec2_Donation_Status = 'In progress') AND (Seeker_FormID = $formId OR Giver_FormID = $formId)
  ''';

      final resultM = await db.readData(sqlStatementsM);
      int matchingsCount = int.parse(resultM[0]['countM']);
      print(resultM);

      print(requestsCount > 0 || matchingsCount > 0);
      return requestsCount > 0 || matchingsCount > 0;
    } catch (e) {
      print('Error in isFormInProgress: $e');

      return false;
    }
  }

  Future<List<UserModel>> getUserForms(String id) async {
    String sqlStatment = '''
      SELECT Users.UserID AS UserUserID, FormID, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email, Item, Category, Dates_available, ForWho, FormType
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Forms.FormStatus = 'Not Completed' AND Forms.UserID = '$id'
    ''';

    List<UserModel> forms;
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatment);

      forms = queryResult
          .map((row) => UserModel(
                userID: id,
                formID: int.parse(row['FormID']),
                userName: row['UserName'],
                firstName: row['FirstName'],
                lastName: row['LastName'],
                city: row['City'],
                country: row['Country'],
                addressLocation: row['AddressLocation'],
                phoneNum: row['PhoneNum'],
                email: row['Email'],
                type: row['FormType'],
                item: row['Item'],
                category: row['Category'],
                multiDates: row['Dates_available'],
                forWho: row['ForWho'],
              ))
          .toList();
    } catch (e) {
      print('An error occurred: $e');

      return [];
    }

    return forms;
  }

  Future<int> createNewForm(String userID, String type, String item,
      String category, String dates, String? forWho, String status) async {
    String sqlStatment = '''
    INSERT INTO Forms (UserID , FormType, Item, Category, Dates_available, ForWho, FormStatus)
        VALUES ('$userID' , '$type', '$item', '$category', '$dates', '${forWho ?? ''}', '$status')
    ''';

    try {
      int rowID = await db.insertData(sqlStatment);
      print('rowID');
      print(rowID);

      return rowID;
    } catch (e) {
      print('Error creating form: $e');
      String error = e.toString();

      if (error.contains('UNIQUE constraint failed: Forms.FormID')) {
        return -2; // Form duplication
      } else {
        return -3; // Error creating form
      }
    }
  }

  Future<int> completeForm(int formID) async {
    String sqlStatement = '''
    UPDATE Forms
    SET FormStatus='Completed'
    WHERE FormID = $formID
  ''';

    try {
      int rowID = await db.updateData(sqlStatement);

      return rowID;
    } catch (e) {
      print('Error updating form: $e');

      return -3; // Error updating form
    }
  }

  Future<int> updateForm(
    String userID,
    String type,
    String item,
    String category,
    String dates,
    String? forWho,
    String status,
    int formID,
  ) async {
    String sqlQuery = '''
    SELECT UserID, FormType, Item, Category, Dates_available, ForWho, FormStatus
    FROM Forms
    WHERE FormID = $formID
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlQuery);

    if (result.isEmpty) {
      // Form with the specified ID not found
      return -1;
    }

    Map<String, dynamic> existingForm = result.first;

    // Check if the new values are different from the existing values
    if (existingForm['UserID'] == userID &&
        existingForm['FormType'] == type &&
        existingForm['Item'] == item &&
        existingForm['Category'] == category &&
        existingForm['Dates_available'] == dates &&
        existingForm['ForWho'] == (forWho ?? '') &&
        existingForm['FormStatus'] == status) {
      //no need for updating as no changes made
      return 0;
    }

    String sqlStatement = '''
    UPDATE Forms
    SET UserID= '$userID', FormType= '$type', Item='$item', Category='$category',
        Dates_available='$dates', ForWho='${forWho ?? ''}', FormStatus='$status'
    WHERE FormID = $formID
  ''';

    try {
      int rowID = await db.updateData(sqlStatement);

      return rowID;
    } catch (e) {
      print('Error updating form: $e');

      return -3; // Error updating form
    }
  }

  /// `deleteForm` deletes a form given an id
  Future<int> deleteForm(int id) async {
    String sqlStatement = '''
    DELETE FROM Forms
    WHERE FormID= $id
    ''';
    int queryResult;
    try {
      queryResult = await db.deleteData(sqlStatement);
    } catch (e) {
      print('Error deleting form: $e');
      return 0;
    }
    return queryResult;
  }

  Future<int> deleteUser(String id) async {
    String sqlStatement = '''
    DELETE FROM Users
    WHERE UserID= '$id'
    ''';
    int queryResult;

    try {
      queryResult = await db.deleteData(sqlStatement);
      print(queryResult);
    } catch (e) {
      print('Error deleting user: $e');
      return 0;
    }
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
    // Capitalize the first letter of the city
    String capitalizedCity = capitalizeFirstLetter(city);
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
        Email
      ) VALUES ('$userID', '$userName', '$firstName', '$lastName', '$capitalizedCity', '$counrty', '$address', '$phoneNum', '$email');
    ''';
    try {
      int result = await db.insertData(sqlStatment);
      print('User created with ID: $result');
      return result;
    } catch (e) {
      // Error occurred during insertion, capture and print the specific error message.
      print('Error creating user: $e');
      String error = e.toString();
      if (error.contains('UNIQUE constraint failed: Users.UserName')) {
        return -1; // userName duplication
      } else if (error.contains('UNIQUE constraint failed: Users.UserID')) {
        return -2; // User duplication
      } else {
        return -3; // Error creating user
      }
    }
  }

  Future<int> updateUser(
    String userID,
    String userName,
    String firstName,
    String lastName,
    String counrty,
    String city,
    String phoneNum,
    String address,
    String email,
    //String? password
  ) async {
    String capitalizedCity = capitalizeFirstLetter(city);
    String sqlQuery = '''
    SELECT UserName, City, Country, AddressLocation, PhoneNum
    FROM Users
    WHERE UserID = '$userID'
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlQuery);

    if (result.isEmpty) {
      // user with the specified ID not found
      return -1;
    }

    Map<String, dynamic> existingUser = result.first;

    // Check if the new values are different from the existing values
    if (existingUser['UserName'] == userName &&
        existingUser['City'] == capitalizedCity &&
        existingUser['Country'] == counrty &&
        existingUser['AddressLocation'] == address &&
        existingUser['PhoneNum'] == phoneNum) {
      //no need for updating as no changes made
      return 0;
    }

    String sqlStatment = '''
    UPDATE Users
    SET  UserName = '$userName' ,  FirstName= '$firstName',  LastName= '$lastName', City= '$capitalizedCity', Country= '$counrty', AddressLocation=  '$address', PhoneNum='$phoneNum' ,Email='$email'
    WHERE UserID= '$userID';
    ''';

    try {
      int updateResult = await db.updateData(sqlStatment);

      return updateResult;
    } catch (e) {
      // Error occurred during insertion, capture and print the specific error message.
      print('Error updating user: $e');
      String error = e.toString();
      if (error.contains('UNIQUE constraint failed: Users.UserName')) {
        return -2; // userName duplication
      } else {
        return -3; // Error creating user
      }
    }
  }

  /// `doesGoogleUserExist` function that checks if a user signed in by google exists or not from taking the `userId` and `email`
  /// It returns a Future<int> for the count found , if it was >0 then user was found
  Future<int> doesGoogleUserExist(String userId, String email) async {
    // String sqlStatment = '''
    //   SELECT COUNT(*) AS count FROM Users WHERE UserID = '$userId' AND Email = "$email"
    //   ''';
    String sqlStatment = '''
      SELECT COUNT(*) AS count FROM Users WHERE UserID = '$userId' AND Email = '$email'
      ''';
    int count;
    try {
      List<Map<String, dynamic>> result = await db.readData(sqlStatment);
      count = int.parse(result[0]['count']);
    } catch (e) {
      print('An error occurred: $e');

      return 0;
    }
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
