import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/users_model.dart';
import 'package:provider/provider.dart';

import '../../helpers/sql_db.dart';
import '../../providers/users_provider.dart';

class cityDBServices {
  SqlDb db = SqlDb();
//retreieve all info needed for city
/*
number of seekers in this city
number of givers in this city
list of seekers for this city - addresses
list of givers for this city  - addresses
number of in progress donations for this city
number of successful donations for this city
top 3 donated categories in this city

*/
//city name is from userstable
//city coordinates is from users table
  /// Retrieve the number of seekers in this city
  Future<int> getNumberOfSeekers(String cityName) async {
    String sqlStatment = '''
      SELECT COUNT(DISTINCT Forms.UserID) AS seeker_count
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.Type = 'seeker';
    ''';
    List<Map> result = await db.readData(sqlStatment);

    int numberOfSeekers = result[0]['seeker_count'];

    return numberOfSeekers;
  }

  /// Retrieve the number of givers in this city
  Future<int> getNumberOfGivers(String cityName) async {
    String sqlStatment = '''
      SELECT COUNT(DISTINCT Forms.UserID) AS giver_count
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.Type = 'giver';
    ''';
    List<Map> result = await db.readData(sqlStatment);

    int numberOfGivers = result[0]['giver_count'];

    return numberOfGivers;
  }

  /// Retrieve the list of seekers for this city - their data
  //Future<List<UsersModel>>
  getSeekersInfo(String cityName, BuildContext context) async {
    String sqlStatment = '''
      SELECT  Users.UserID AS UserUserID , UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email,Password,COUNT(CASE WHEN Forms.For = 'self' THEN Forms.FormID END) AS self_count, COUNT(CASE WHEN Forms.For = 'other' THEN Forms.FormID END) AS other_count
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.Type = 'seeker'
      GROUP BY Users.UserID;
    ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);
    // print('results of query get seekers info: $result');
    // result will look like this:
    /*
        [
      {
        'UserID': 1,
        'UserName': 'johndoe',
        'FirstName': 'John',
        'LastName': 'Doe',
        'City': 'New York',
        'Country': 'USA',
        'AddressLocation': '123 Main St',
        'PhoneNum': '555-1234',
        'Email': 'johndoe@example.com',
        'Password': 'password123'
      },
      {
        'UserID': 2,
        'UserName': 'janedoe',
        'FirstName': 'Jane',
        'LastName': 'Doe',
        'City': 'New York',
        'Country': 'USA',
        'AddressLocation': '456 Elm St',
        'PhoneNum': '555-5678',
        'Email': 'janedoe@example.com',
        'Password': 'password456'
      }
    ]
        */

    //List<UsersModel> seekerUsers = [];
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    for (Map<String, dynamic> row in result) {
      UsersModel user = UsersModel(
        userID: row['UserUserID'],
        userName: row['UserName'],
        firstName: row['FirstName'],
        lastName: row['LastName'],
        city: row['City'],
        country: row['Country'],
        addressLocation: row['AddressLocation'],
        phoneNum: row['PhoneNum'],
        email: row['Email'],
        pass: row['Password'],
       seekingForOthers: row['other_count'],
       seekingsForSelf: row['self_count'],
      );
      userProvider.saveSeekers(user);
    }

    //return seekerUsers;
  }

  /// Retrieve the list of givers for this city - their data
  getGiversInfo(String cityName, BuildContext context) async {
    String sqlStatment = '''
      SELECT  Users.UserID AS UserUserID, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email,Password, COUNT(*) AS numberOfGivings
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.Type = 'giver'
      GROUP BY Users.UserID;
    ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);

    print(result);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    for (Map<String, dynamic> row in result) {
      UsersModel user = UsersModel(
        userID: row['UserUserID'],
        userName: row['UserName'],
        firstName: row['FirstName'],
        lastName: row['LastName'],
        city: row['City'],
        country: row['Country'],
        addressLocation: row['AddressLocation'],
        phoneNum: row['PhoneNum'],
        email: row['Email'],
        pass: row['Password'],
        givings: row['numberOfGivings'],
      );
      userProvider.saveGivers(user);
    }
  }

  /// Retrieve the number of successful donations in this city
  Future<int> getNumberOfSuccessfulDonations(String cityName) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS successful_donation_count
    FROM (
      SELECT Matchings.Donation_Status
      FROM Matchings
      JOIN Forms ON Matchings.Seeker_FormID = Forms.FormID 
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Matchings.Donation_Status = 'Finished' 
      
      UNION ALL
      
      SELECT Requests.Donation_Status
      FROM Requests
      JOIN Users ON Requests.Rec_ID = Users.UserID
      WHERE Users.City = '$cityName' AND Requests.Donation_Status = 'Finished'
    ) AS donation_data;
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);
    int numberOfSuccessfulDonations = result[0]['successful_donation_count'];

    return numberOfSuccessfulDonations;
  }

  /// Retrieve the number of in progress donations in this city
  Future<int> getNumberOfInProgressDonations(String cityName) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS Inprogress_donation_count
    FROM (
      SELECT Matchings.Donation_Status
      FROM Matchings
      JOIN Forms ON Matchings.Seeker_FormID = Forms.FormID 
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Matchings.Donation_Status = 'In progress' 
      
      UNION ALL
      
      SELECT Requests.Donation_Status
      FROM Requests
      JOIN Users ON Requests.Rec_ID = Users.UserID
      WHERE Users.City = '$cityName' AND Requests.Donation_Status = 'In progress'
    ) AS donation_data;
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);
    int numberOfInProgressDonations = result[0]['Inprogress_donation_count'];

    return numberOfInProgressDonations;
  }

  // Retrieve the top 3 donated categories in this city
  Future<List<String>> getTopDonatedCategories(String cityName) async {
    String sqlStatement = '''
        SELECT Forms.Category, COUNT(*) AS category_count
        FROM Forms
        JOIN Users ON Forms.UserID = Users.UserID
        WHERE Users.city = '$cityName'
        GROUP BY Forms.Category
        ORDER BY category_count DESC
        LIMIT 3;
    ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);

    List<String> topCategories = [];
    for (Map<String, dynamic> row in result) {
      String category = row['Category'];
      topCategories.add(category);
    }

    return topCategories;
  }
}






 // Retrieve the number of in-progress donations for this city
  // Future<int> getNumberOfInProgressDonations(String cityName)async  {
  //   String sqlStatment = '''
  //     SELECT COUNT(*) AS successful_count
  //     FROM Forms
  //     JOIN Users ON Forms.UserID = Users.UserID
  //     WHERE Users.City = '$cityName' AND Forms.Status = 'In progress';
  //   ''';
  //   List<Map> result = await db.readData(sqlStatment);

  //   int numberOfSuccessfulDonations=result[0]['giver_count'];

  //   print("number of SuccessfulDonations: $numberOfSuccessfulDonations");

  //   return numberOfSuccessfulDonations;
  // }

  // Retrieve the number of successful donations for this city
  // Future<int> getNumberOfSuccessfulDonations(String cityName) async {
  //   String sqlStatment = '''
  //     SELECT COUNT(*) AS in_progress_count
  //     FROM Forms
  //     JOIN Users ON Forms.UserID = Users.UserID
  //     WHERE Users.city = '$cityName' AND Forms.Status = 'Completed';
  //   ''';
  //   List<Map> result = await db.readData(sqlStatment);

  //   int numberOfSuccessfulDonations=result[0]['giver_count'];

  //   print("number of SuccessfulDonations: $numberOfSuccessfulDonations");

  //   return numberOfSuccessfulDonations;
   
  // }