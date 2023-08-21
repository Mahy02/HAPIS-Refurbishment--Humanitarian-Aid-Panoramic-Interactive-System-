import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/sql_db.dart';
import '../../models/db_models/user_model.dart';
import '../../providers/user_provider.dart';

///   `userServices` class that contains everything related to the users query and interactions with the database
class UserServices {
  /// The [db] database instance.
  SqlDb db = SqlDb();

  /// Capitalize the first letter of each word in the given text.
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

  /// Function to get the full name by id
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

  /// retrieves the user city given a user ID
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

  /// retrieves all users data given a user ID
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
      SELECT hapisdb.Users.UserID AS UserUserID, FormID, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email, Item, Category, Dates_available, ForWho, ProfileImage
      FROM hapisdb.Forms
      JOIN hapisdb.Users ON hapisdb.Forms.UserID = hapisdb.Users.UserID
      WHERE hapisdb.Forms.FormType = '$type' AND hapisdb.Forms.FormStatus = 'Not Completed'
    ''';

    List<Map<String, dynamic>> result = await db.readData(sql);

    UserAppProvider userProvider =
        Provider.of<UserAppProvider>(context, listen: false);

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
            imagePath: row['ProfileImage']);

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

  /// `isFormInProgress` checks if the current form's status is In progress or not given a form ID
  /// Returns a [Future] [bool] indicating the result of the transaction.
  Future<bool> isFormInProgress(int formId) async {
    try {
      // Check in the 'requests' table
      String sqlStatementsR = '''
    SELECT COUNT(*) as countR 
    FROM Requests 
    WHERE (Rec1_Donation_Status = 'In progress' OR Rec2_Donation_Status = 'In progress') AND Rec_FormID = $formId
  ''';
      final resultR = await db.readData(sqlStatementsR);
      int requestsCount = int.parse(resultR[0]['countR']);

      String sqlStatementsM = '''
     SELECT COUNT(*) as countM 
     FROM Matchings 
     WHERE (Rec1_Donation_Status = 'In progress' OR Rec2_Donation_Status = 'In progress') AND (Seeker_FormID = $formId OR Giver_FormID = $formId)
  ''';

      final resultM = await db.readData(sqlStatementsM);
      int matchingsCount = int.parse(resultM[0]['countM']);
      return requestsCount > 0 || matchingsCount > 0;
    } catch (e) {
      print('Error in isFormInProgress: $e');

      return false;
    }
  }

  /// Retrieves a list of user forms based on the provided user ID.
  ///
  /// This method queries the database to fetch forms associated with the given user ID that have a status of "Not Completed".
  ///
  /// Parameters:
  /// - `id`: The user ID for which to retrieve the forms.
  ///
  /// Returns a [Future] [List] of [UserModel] instances representing the retrieved forms.
  ///
  /// Example:
  /// ```dart
  /// List<UserModel> forms = await getUserForms('user123');
  /// ```
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

  /// Creates a new form in the database.
  ///
  /// This method inserts a new form entry into the database with the provided details.
  ///
  /// Parameters:
  /// - `userID`: The ID of the user associated with the form.
  /// - `type`: The type of the form, such as "seeker" or "giver".
  /// - `item`: The item being sought or given.
  /// - `category`: The category of the item.
  /// - `dates`: The available dates associated with the form.
  /// - `forWho`: Optional parameter indicating the intended recipient or purpose of the form.
  /// - `status`: The status of the form.
  ///
  /// Returns a [Future] [int] representing the ID of the inserted form, or an error code if the insertion fails.
  ///
  /// Example:
  /// ```dart
  /// int formID = await createNewForm('user123', 'seeker', 'Clothing', 'Apparel', '2023-08-21', 'Children', 'Not Completed');
  /// ```
  Future<int> createNewForm(String userID, String type, String item,
      String category, String dates, String? forWho, String status) async {
    String sqlStatment = '''
    INSERT INTO Forms (UserID , FormType, Item, Category, Dates_available, ForWho, FormStatus)
        VALUES ('$userID' , '$type', '$item', '$category', '$dates', '${forWho ?? ''}', '$status')
    ''';

    try {
      int rowID = await db.insertData(sqlStatment);
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

  /// Marks a form as completed in the database.
  ///
  /// This method updates the status of the form with the given `formID` to "Completed".
  ///
  /// Parameters:
  /// - `formID`: The ID of the form to be marked as completed.
  ///
  /// Returns a [Future] [int] representing the updated row ID, or an error code if the update fails.
  ///
  /// Example:
  /// ```dart
  /// int updatedFormID = await completeForm(123);
  /// ```
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

  /// Updates the details of a form in the database.
  ///
  /// This method updates the form with the specified `formID` using the provided
  /// information. If any of the values are changed, the form's details are updated
  /// accordingly.
  ///
  /// Parameters:
  /// - `userID`: The user ID associated with the form.
  /// - `type`: The type of the form.
  /// - `item`: The item description in the form.
  /// - `category`: The category of the form.
  /// - `dates`: The available dates in the form.
  /// - `forWho`: The target audience for the form (optional).
  /// - `status`: The status of the form.
  /// - `formID`: The ID of the form to be updated.
  ///
  /// Returns a [Future] [int] representing the updated row ID, or an error code if the update fails.
  ///
  /// Example:
  /// ```dart
  /// int updatedFormID = await updateForm(
  ///   'user123',
  ///   'seeker',
  ///   'Clothing',
  ///   'Donation',
  ///   '2023-08-31',
  ///   'Individuals',
  ///   'Not Completed',
  ///   456
  /// );
  /// ```
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

  /// Deletes a form from the database.
  ///
  /// This method deletes the form with the specified `id` from the database.
  ///
  /// Parameters:
  /// - `id`: The ID of the form to be deleted.
  ///
  /// Returns a [Future] [int] representing the number of rows affected by the deletion, or 0 if the deletion fails.
  ///
  /// Example:
  /// ```dart
  /// int deletedRowCount = await deleteForm(123);
  /// ```
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

  /// Deletes a user from the database.
  ///
  /// This method deletes the user with the specified `id` from the database.
  ///
  /// Parameters:
  /// - `id`: The ID of the user to be deleted.
  ///
  /// Returns a [Future] [int] representing the number of rows affected by the deletion, or 0 if the deletion fails.
  ///
  /// Example:
  /// ```dart
  /// int deletedRowCount = await deleteUser('user123');
  /// ```
  Future<int> deleteUser(String id) async {
    String sqlStatement = '''
    DELETE FROM Users
    WHERE UserID= '$id'
    ''';
    int queryResult;
    try {
      queryResult = await db.deleteData(sqlStatement);
    } catch (e) {
      print('Error deleting user: $e');
      return 0;
    }
    return queryResult;
  }

  /// Creates a new user during sign-up and adds them to the database.
  ///
  /// This method inserts a new user's details into the database with the provided information.
  ///
  /// Parameters:
  /// - `userID`: The ID of the new user.
  /// - `userName`: The username of the new user.
  /// - `firstName`: The first name of the new user.
  /// - `lastName`: The last name of the new user.
  /// - `counrty`: The country of the new user.
  /// - `city`: The city of the new user.
  /// - `phoneNum`: The phone number of the new user.
  /// - `address`: The address of the new user.
  /// - `email`: The email of the new user.
  /// - `password`: The password of the new user (optional).
  ///
  /// Returns a [Future] [int] representing the result of the transaction:
  /// - Positive value: Success, representing the number of rows affected by the insertion.
  /// - -1: Username duplication.
  /// - -2: User duplication.
  /// - -3: Error creating user.
  ///
  /// Example:
  /// ```dart
  /// int result = await createNewUser(
  ///   userID: 'user123',
  ///   userName: 'john_doe',
  ///   firstName: 'John',
  ///   lastName: 'Doe',
  ///   counrty: 'USA',
  ///   city: 'New York',
  ///   phoneNum: '123-456-7890',
  ///   address: '123 Main St',
  ///   email: 'john@example.com',
  ///   password: 'securepassword',
  /// );
  /// ```
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
      return result;
    } catch (e) {
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

  /// Updates the details of a user in the database.
  ///
  /// This method updates the user with the specified `userID` using the provided
  /// information. If any of the values are changed, the user's details are updated
  /// accordingly.
  ///
  /// Parameters:
  /// - `userID`: The ID of the user to be updated.
  /// - `userName`: The updated username of the user.
  /// - `firstName`: The updated first name of the user.
  /// - `lastName`: The updated last name of the user.
  /// - `counrty`: The updated country of the user.
  /// - `city`: The updated city of the user.
  /// - `phoneNum`: The updated phone number of the user.
  /// - `address`: The updated address of the user.
  /// - `email`: The updated email of the user.
  ///
  /// Returns a [Future] [int] representing the updated row ID, or an error code if the update fails.
  ///
  /// Example:
  /// ```dart
  /// int updatedUserID = await updateUser(
  ///   'user123',
  ///   'new_username',
  ///   'New',
  ///   'Name',
  ///   'USA',
  ///   'Los Angeles',
  ///   '987-654-3210',
  ///   '456 Oak St',
  ///   'new@example.com',
  /// );
  /// ```
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

  /// Checks if a user signed in through Google exists in the database.
  ///
  /// This method checks whether a user with the given `userId` and `email`
  /// exists in the database.
  ///
  /// Parameters:
  /// - `userId`: The ID associated with the Google user.
  /// - `email`: The email of the Google user.
  ///
  /// Returns a [Future] [int] representing the count found:
  /// - Greater than 0: User was found.
  /// - 0: User was not found.
  ///
  /// Example:
  /// ```dart
  /// int userCount = await doesGoogleUserExist('google123', 'google@example.com');
  /// ```
  Future<int> doesGoogleUserExist(String userId, String email) async {
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

  /// Checks if a user signed in with email and password exists in the database.
  ///
  /// This method checks whether a user with the given `email` and `password`
  /// exists in the database.
  ///
  /// Parameters:
  /// - `password`: The password of the user.
  /// - `email`: The email of the user.
  ///
  /// Returns a [Future] [String] representing the userID if the user was found, or an empty string if the user was not found.
  ///
  /// Example:
  /// ```dart
  /// String foundUserID = await doesNormalUserExist('securepassword', 'user@example.com');
  /// if (foundUserID.isNotEmpty) {
  /// } else {
  /// }
  /// ```
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
