import '../../helpers/sql_db.dart';

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
      SELECT COUNT(*) AS seeker_count
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.Type = 'seeker';
    ''';
    List<Map> result = await db.readData(sqlStatment);

    int numberOfSeekers = result[0]['seeker_count'];

    print("number of seekers: $numberOfSeekers");

    return numberOfSeekers;
  }

  /// Retrieve the number of givers in this city
  Future<int> getNumberOfGivers(String cityName) async {
    String sqlStatment = '''
      SELECT COUNT(*) AS giver_count
      FROM Forms
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Forms.Type = 'giver';
    ''';
    List<Map> result = await db.readData(sqlStatment);

    int numberOfGivers = result[0]['giver_count'];

    print("number of givers: $numberOfGivers");

    return numberOfGivers;
  }

  /// Retrieve the list of seekers for this city - addresses
  List<String> getListOfSeekers() {
    return [
      'Address 1',
      'Address 2',
      'Address 3',
    ];
  }

  /// Retrieve the list of givers for this city - addresses
  List<String> getListOfGivers() {
    return [
      'Address A',
      'Address B',
      'Address C',
    ];
  }

  /// Retrieve the number of successful donations in this city
  Future<int> getNumberOfSuccessfulDonations(String cityName) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS successful_donation_count
    FROM (
      SELECT *
      FROM Matchings
      JOIN Forms ON Matchings.Seeker_FormID = Forms.FormID 
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Matchings.Donation_Status = 'Finished' 
      
      UNION ALL
      
      SELECT *
      FROM Requests
      JOIN Users ON Requests.Rec_ID = Users.UserID
      WHERE Users.City = '$cityName' AND Requests.Donation_Status = 'Finished'
    ) AS donation_data;
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);
    int numberOfSuccessfulDonations = result[0]['successful_donation_count'];

    print("Number of successful donations: $numberOfSuccessfulDonations");

    return numberOfSuccessfulDonations;
  }

  /// Retrieve the number of in progress donations in this city
  Future<int> getNumberOfInProgressDonations(String cityName) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS Inprogress_donation_count
    FROM (
      SELECT *
      FROM Matchings
      JOIN Forms ON Matchings.Seeker_FormID = Forms.FormID 
      JOIN Users ON Forms.UserID = Users.UserID
      WHERE Users.City = '$cityName' AND Matchings.Donation_Status = 'In progress' 
      
      UNION ALL
      
      SELECT *
      FROM Requests
      JOIN Users ON Requests.Rec_ID = Users.UserID
      WHERE Users.City = '$cityName' AND Requests.Donation_Status = 'In progress'
    ) AS donation_data;
  ''';

    List<Map<String, dynamic>> result = await db.readData(sqlStatement);
    int numberOfInProgressDonations = result[0]['Inprogress_donation_count'];

    print("Number of inprogress donations: $numberOfInProgressDonations");

    return numberOfInProgressDonations;
  }

  // Retrieve the top 3 donated categories in this city
  Future<List<String>> getTopDonatedCategories(String cityName) async{
    String sqlStatement = '''
        SELECT Forms.Category, COUNT(*) AS category_count
        FROM Forms
        JOIN Users ON Forms.User_ID = Users.UserID
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


    // return [
    //   'Category 1',
    //   'Category 2',
    //   'Category 3',
    // ];
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