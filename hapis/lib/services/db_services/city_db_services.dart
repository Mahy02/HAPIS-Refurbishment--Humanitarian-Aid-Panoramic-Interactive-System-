import 'package:flutter/material.dart';
import 'package:hapis/models/liquid_galaxy/balloon_models/users_model.dart';
import 'package:hapis/utils/extract_geocoordinates.dart';
import 'package:provider/provider.dart';

import '../../helpers/sql_db.dart';
import '../../providers/liquid_galaxy/users_provider.dart';

/// The `cityDBServices` class provides methods to interact with the database and retrieve information related to city statistics.
class cityDBServices {

  /// The [db] database instance.
  SqlDb db = SqlDb();

  /// Retrieve the number of seekers in the given city `cityName`.
  ///
  /// Returns a [Future] with the number of seekers.
  Future<int> getNumberOfSeekers(String cityName) async {
    String sqlStatment = '''
      SELECT COUNT(DISTINCT Forms.UserID) AS seeker_count
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.FormType = 'seeker';
    ''';
    List<Map> result = await db.readData(sqlStatment);

    int numberOfSeekers = int.parse(result[0]['seeker_count']);

    return numberOfSeekers;
  }

  /// Retrieve the number of givers in the given city `cityName`.
  ///
  /// Returns a [Future] with the number of givers.
  Future<int> getNumberOfGivers(String cityName) async {
    String sqlStatment = '''
      SELECT COUNT(DISTINCT Forms.UserID) AS giver_count
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.FormType = 'giver';
    ''';
    List<Map> result = await db.readData(sqlStatment);

    int numberOfGivers = int.parse(result[0]['giver_count']);

    return numberOfGivers;
  }

  /// Retrieve the list of seekers and their information for the given city `cityName`.
  ///
  /// This method fetches seekers' data from the database and stores it in the UserProvider.
  getSeekersInfo(String cityName, BuildContext context) async {
    String sqlStatment = '''
      SELECT  Users.UserID AS UserUserID , ProfileImage, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email,COUNT(CASE WHEN Forms.ForWho = 'self' THEN Forms.FormID END) AS self_count, COUNT(CASE WHEN Forms.ForWho = 'other' THEN Forms.FormID END) AS other_count
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.FormType = 'seeker'
      GROUP BY Users.UserID;
    ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);

    /// result will look like this:
    ///     [
    ///   {
    ///     'UserID': 1,
    ///     'UserName': 'johndoe',
    ///     'FirstName': 'John',
    ///     'LastName': 'Doe',
    ///     'City': 'New York',
    ///     'Country': 'USA',
    ///     'AddressLocation': '123 Main St',
    ///     'PhoneNum': '555-1234',
    ///     'Email': 'johndoe@example.com',
    ///     'Password': 'password123'
    ///   },
    ///   {
    ///     'UserID': 2,
    ///     'UserName': 'janedoe',
    ///     'FirstName': 'Jane',
    ///     'LastName': 'Doe',
    ///     'City': 'New York',
    ///     'Country': 'USA',
    ///     'AddressLocation': '456 Elm St',
    ///     'PhoneNum': '555-5678',
    ///     'Email': 'janedoe@example.com',
    ///     'Password': 'password456'
    ///   }
    /// ]

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    for (Map<String, dynamic> row in result) {
      try {
        LatLng coords = await getCoordinates(row['AddressLocation']);

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
          imagePath: row['ProfileImage'],
          seekingForOthers: int.parse(row['other_count']),
          seekingsForSelf: int.parse(row['self_count']),
          userCoordinates: coords,
        );
        userProvider.saveSeekers(user);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Retrieve the list of givers and their information for the given city `cityName`.
  ///
  /// This method fetches givers' data from the database and stores it in the UserProvider.
  getGiversInfo(String cityName, BuildContext context) async {
    String sqlStatment = '''
      SELECT  Users.UserID AS UserUserID, ProfileImage, UserName, FirstName, LastName, City, Country, AddressLocation,PhoneNum,Email, COUNT(*) AS numberOfGivings
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.FormType = 'giver'
      GROUP BY Users.UserID;
    ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatment);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    for (Map<String, dynamic> row in result) {
      try {
        LatLng coords = await getCoordinates(row['AddressLocation']);

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
          imagePath: row['ProfileImage'],
          givings: int.parse(row['numberOfGivings']),
          userCoordinates: coords,
        );
        userProvider.saveGivers(user);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Retrieve the number of successful donations in the given city `cityName`.
  ///
  /// Returns a [Future] with the number of successful donations.
  Future<int> getNumberOfSuccessfulDonations(String cityName) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS successful_donation_count
    FROM (
      SELECT Matchings.Rec1_Donation_Status
      FROM Matchings
      JOIN Forms ON Matchings.Seeker_FormID = Forms.FormID 
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Matchings.Rec2_Donation_Status = 'Finished' AND Matchings.Rec1_Donation_Status = 'Finished' 
      
      UNION ALL
      
      SELECT Requests.Rec1_Donation_Status
      FROM Requests
      JOIN Users ON Requests.Rec_ID = Users.UserID
      WHERE Users.City = '$cityName' AND Requests.Rec1_Donation_Status = 'Finished' AND Requests.Rec2_Donation_Status = 'Finished'
    ) AS donation_data;
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);
    int numberOfSuccessfulDonations =
        int.parse(result[0]['successful_donation_count']);

    return numberOfSuccessfulDonations;
  }

   /// Retrieve the number of in-progress donations in the given city `cityName`.
  ///
  /// Returns a [Future] with the number of in-progress donations.
  Future<int> getNumberOfInProgressDonations(String cityName) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS Inprogress_donation_count
    FROM (
      SELECT Matchings.Rec1_Donation_Status
      FROM Matchings
      JOIN Forms ON Matchings.Seeker_FormID = Forms.FormID 
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Matchings.Rec1_Donation_Status = 'In progress' AND Matchings.Rec2_Donation_Status = 'In progress' 
      
      UNION ALL
      
      SELECT Requests.Rec1_Donation_Status
      FROM Requests
      JOIN Users ON Requests.Rec_ID = Users.UserID
      WHERE Users.City = '$cityName' AND Requests.Rec1_Donation_Status = 'In progress' AND Requests.Rec2_Donation_Status = 'In progress'
    ) AS donation_data;
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);
    int numberOfInProgressDonations =
        int.parse(result[0]['Inprogress_donation_count']);

    return numberOfInProgressDonations;
  }

  /// Retrieve the top 3 donated categories in the given city `cityName`.
  ///
  /// Returns a [Future] with a list of the top 3 donated categories.
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
