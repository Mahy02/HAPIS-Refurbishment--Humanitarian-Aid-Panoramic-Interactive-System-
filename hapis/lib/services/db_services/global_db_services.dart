import '../../helpers/sql_db.dart';

///   `globalDBServices` class that contains everything related to the global statistics query and interactions with the database

class globalDBServices {

  /// The [db] database instance.
  SqlDb db = SqlDb();

  /// Retrieve the number of seekers globally.
  ///
  /// Returns a [Future] with the count of seekers.
  Future<int> getNumberOfSeekers() async {
    String sqlStatment = '''
      SELECT COUNT(DISTINCT Forms.UserID) AS seeker_count
      FROM Forms
      WHERE Forms.FormType = 'seeker';
    ''';
    List<Map> result = await db.readData(sqlStatment);

    int numberOfSeekers = int.parse(result[0]['seeker_count']);

    return numberOfSeekers;
  }

  /// Retrieve the number of givers globally.
  ///
  /// Returns a [Future] with the count of givers.
  Future<int> getNumberOfGivers() async {
    String sqlStatment = '''
      SELECT COUNT(DISTINCT Forms.UserID) AS giver_count
      FROM Forms
      WHERE Forms.FormType = 'giver';
    ''';
    List<Map> result = await db.readData(sqlStatment);

    int numberOfGivers = int.parse(result[0]['giver_count']);

    return numberOfGivers;
  }

  /// Retrieve the number of successful donations globally.
  ///
  /// Returns a [Future] with the count of successful donations.
  Future<int> getNumberOfSuccessfulDonations() async {
    String sqlStatement = '''
    SELECT COUNT(*) AS successful_donation_count
    FROM (
      SELECT *
      FROM Matchings
      WHERE Matchings.Rec1_Donation_Status = 'Finished'  AND Matchings.Rec2_Donation_Status = 'Finished'
      
      UNION ALL
      
      SELECT *
      FROM Requests
      WHERE Requests.Rec1_Donation_Status = 'Finished' AND Requests.Rec2_Donation_Status = 'Finished'
    ) AS donation_data;
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);
    int numberOfSuccessfulDonations = int.parse( result[0]['successful_donation_count']);

    return numberOfSuccessfulDonations;
  }

  /// Retrieve the number of in-progress donations globally.
  ///
  /// Returns a [Future] with the count of in-progress donations.
  Future<int> getNumberOfInProgressDonations() async {
    String sqlStatement = '''
    SELECT COUNT(*) AS Inprogress_donation_count
    FROM (
      SELECT *
      FROM Matchings
      WHERE Matchings.Rec1_Donation_Status = 'In progress'  AND Matchings.Rec2_Donation_Status = 'In progress' 
      
      UNION ALL
      
      SELECT *
      FROM Requests
      WHERE Requests.Rec1_Donation_Status = 'In progress' AND Requests.Rec2_Donation_Status = 'In progress'
    ) AS donation_data;
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);
    int numberOfInProgressDonations = int.parse(result[0]['Inprogress_donation_count']);

    return numberOfInProgressDonations;
  }

  /// Retrieve the top 3 donated categories globally.
  ///
  /// Returns a [Future] with a List of the top 3 donated categories.
  Future<List<String>> getTopDonatedCategories() async {
    String sqlStatement = '''
        SELECT Forms.Category, COUNT(*) AS category_count
        FROM Forms
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

  /// Retrieve the top 3 cities with the most forms globally.
  ///
  /// Returns a [Future] with a List of the top 3 cities.
  Future<List<String>> getTopCities() async {
    String sqlStatement = '''
        SELECT Users.City AS City , COUNT(*) AS city_count
        FROM Forms
        JOIN Users ON Forms.UserID = Users.UserID
        GROUP BY Users.city
        ORDER BY city_count DESC
        LIMIT 3;
    ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);

    List<String> topCities = [];
    for (Map<String, dynamic> row in result) {
      String city = row['City'];
      topCities.add(city);
    }

    return topCities;
  }
}
