// import '../../helpers/sql_db.dart';
// import '../../models/db_models/get_matchings_model.dart';

// ///   `MatchingsServices` class that contains everything related to the matchings query and interactions with the database

// class MatchingsServices {
  
//   /// The [db] database instance.
//   SqlDb db = SqlDb();

//   /// Retrieve all matches for a certain user given their `id`.
//   ///
//   /// Returns a [Future] with a List of `MatchingsModel`.
//   Future<List<MatchingsModel>> getMatchings(String id) async {
//     //type of current user
//     String sqlStatement = '''
//     SELECT
//     CASE
//         WHEN F1.UserID = '$id' THEN 'seeker'
//         ELSE 'giver'
//     END AS Type,
//     CASE
//         WHEN F1.UserID = '$id' THEN U2.FirstName
//         ELSE U1.FirstName
//     END AS FirstName,
//     CASE
//         WHEN F1.UserID = '$id' THEN U2.LastName
//         ELSE U1.LastName
//     END AS LastName,
//     CASE
//         WHEN F1.UserID = '$id' THEN U2.City
//         ELSE U1.City
//     END AS City,

//     CASE
//         WHEN F1.UserID = '$id' THEN U2.AddressLocation
//         ELSE U1.AddressLocation
//     END AS AddressLocation,

//     CASE
//         WHEN F1.UserID = '$id' THEN U2.Email
//         ELSE U1.Email
//     END AS Email,

//      CASE
//         WHEN F1.UserID = '$id' THEN U2.PhoneNum
//         ELSE U1.PhoneNum
//     END AS PhoneNum,

//     CASE
//         WHEN F1.UserID = '$id' THEN F2.Item
//         ELSE F1.Item
//     END AS Item,
//     CASE
//         WHEN F1.UserID = '$id' THEN F2.Category
//         ELSE F1.Category
//     END AS Category,
//     CASE
//         WHEN F1.UserID = '$id' THEN F2.Dates_available
//         ELSE F1.Dates_available
//     END AS Dates_available,
//     CASE
//         WHEN F1.UserID = '$id' THEN F2.UserID
//         ELSE F1.UserID
//     END AS UserID,
//     CASE
//         WHEN F1.UserID = '$id' THEN F2.FormID
//         ELSE F1.FormID
//     END AS FormID,

//     M_ID, Rec1_Status, Rec2_status
    
//     FROM Matchings M
//     JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
//     JOIN Forms F2 ON M.Giver_FormID = F2.FormID
//     JOIN Users U1 ON F1.UserID = U1.UserID
//     JOIN Users U2 ON F2.UserID = U2.UserID
//     WHERE (F1.UserID = '$id' OR F2.UserID = '$id') AND M.Rec1_Donation_Status= 'Not Started'
// ''';
//     List<MatchingsModel> matchings;

//     try {
//       List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
   
//       matchings = queryResult
//           .map((matchingMap) => MatchingsModel(
//               matchingID: int.parse(matchingMap['M_ID']),
//               formID: int.parse(matchingMap['FormID']),
//               userID: matchingMap['UserID'],
//               type: matchingMap['Type'],
//               firstName: matchingMap['FirstName'],
//               lastName: matchingMap['LastName'],
//               city: matchingMap['City'],
//               addressLocation: matchingMap['AddressLocation'],
//               phoneNum: matchingMap['PhoneNum'],
//               email: matchingMap['Email'],
//               item: matchingMap['Item'],
//               category: matchingMap['Category'],
//               datesAvailable: matchingMap['Dates_available'],
//               seekerStatus: matchingMap['Rec1_Status'],
//               giverStatus: matchingMap['Rec2_status']))
//           .toList();
//     } catch (e) {
//       print('Error creating request: $e');

//       return [];
//     }

//     return matchings;
//   }

//   /// Retrieve the count of matchings for a user.
//   ///
//   /// Returns a [Future] with the count of matchings.
//   Future<int> getMatchingsCount(String id) async {
//     String sqlStatement = '''
//     SELECT COUNT(*) AS Count
//     FROM Matchings M
//     JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
//     JOIN Forms F2 ON M.Giver_FormID = F2.FormID
//     JOIN Users U1 ON F1.UserID = U1.UserID
//     JOIN Users U2 ON F2.UserID = U2.UserID
//     WHERE (F1.UserID = '$id' OR F2.UserID = '$id') AND M.Rec1_Donation_Status = 'Not Started'
//   ''';
//     try {
//       List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
//       return queryResult.isNotEmpty ? int.parse(queryResult[0]['Count']) : 0;
//     } catch (e) {
//       print('An error occurred: $e');
//       return 0;
//     }
//   }

//   /// Update the status of a matching entry based on the user's type.
//   ///
//   /// Returns a [Future] with the result of the update operation.
//   Future<int> updateMatching(int id, String type) async {
  
//     String sqlStatement;
//     if (type == 'seeker') {
//       sqlStatement = '''
//         UPDATE  Matchings
//         SET Rec1_Status= 'Accepted',
//             Rec1_Donation_Status = 
//                           CASE 
//                             WHEN Rec2_Status = 'Accepted' 
//                           THEN 
//                             'In progress'  
//                           ELSE 
//                             Rec1_Donation_Status 
//                           END,
//             Rec2_Donation_Status = 
//                           CASE 
//                             WHEN Rec2_Status = 'Accepted' 
//                           THEN 
//                             'In progress'  
//                           ELSE 
//                             Rec2_Donation_Status 
//                           END
//         WHERE M_ID = $id
//       ''';
//     } else {
//       sqlStatement = '''
//         UPDATE  Matchings
//         SET Rec2_Status= 'Accepted',
//         Rec1_Donation_Status = 
//                           CASE 
//                           WHEN Rec1_Status = 'Accepted'  
//                           THEN 
//                             'In progress'  
//                           ELSE 
//                             Rec1_Donation_Status  
//                           END,
//         Rec2_Donation_Status = 
//                           CASE 
//                           WHEN Rec1_Status = 'Accepted'  
//                           THEN 
//                             'In progress'  
//                           ELSE 
//                             Rec2_Donation_Status 
//                           END
           
//         WHERE M_ID = $id
//       ''';
//     }
//     int queryResult;
//     try {
//       queryResult = await db.updateData(sqlStatement);
//     } catch (e) {
//       print('Error : $e');
//       return -1;
//     }
//     return queryResult;
//   }

//   /// Delete a matching entry based on its `id`.
//   ///
//   /// Returns a [Future] with the result of the delete operation.
//   Future<int> deleteMatching(int id) async {
//     String sqlStatement = '''
//     DELETE FROM Matchings
//     WHERE  M_ID= $id
//     ''';
//     int queryResult;
//     try {
//       queryResult = await db.deleteData(sqlStatement);
//     } catch (e) {
//       print('Error : $e');
//       return -1;
//     }
//     return queryResult;
//   }

//   /// Retrieve the Form IDs associated with a given matching ID.
//   ///
//   /// Returns a [Future] with a List of Form IDs.
//   Future<List<int>> getFormIds(int mId) async {
//     String sqlStatement = '''
//     SELECT Seeker_FormID, Giver_FormID
//     FROM Matchings
//     WHERE M_ID = $mId
//   ''';
//     List<Map<String, dynamic>> results = await db.readData(sqlStatement);
//     List<int> ids = [];
//     if (results.isNotEmpty) {
      
//       int seekerFormId = int.parse(results[0]['Seeker_FormID']) as int;
//       int giverFormId = int.parse(results[0]['Giver_FormID']) as int;
//       ids.add(seekerFormId);
//       ids.add(giverFormId);
//       return ids;
//     } else {
//       return [];
//     }
//   }

//    /// Check for potential matches based on specified criteria.
//   ///
//   /// Returns a [Future] with a List of potential matching Form IDs.
//   Future<List<int?>> checkMatching(
//       String type, String item, String cat, String dates, String city) async {
//     final individualDates = dates.split(',');
//     final dateConditions = individualDates.map((date) {
//       return "Forms.Dates_available LIKE '%$date%'";
//     }).join(" OR ");

//     String sqlStatement = '''
//     SELECT FormID
//     FROM Forms
//     INNER JOIN Users ON Forms.UserID = Users.UserID
//     WHERE Forms.FormType = '$type'
//       AND LOWER(Forms.Item) = LOWER('$item')
//       AND Forms.Category = '$cat'
//       AND ( $dateConditions )
//       AND Forms.FormStatus = 'Not Completed'
//       AND Users.City = '$city'
//     ''';
//     List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
  
//     List<int?> matching =
//         queryResult.map<int?>((row) => int.parse(row['FormID'])).toList();

//     return matching;
//   }

//   /// Create a new match between a seeker and a giver.
//   ///
//   /// Returns a [Future] with the ID of the inserted row.
//   Future<int> createMatch(int seekerFormID, int giverFormID) async {
//     String sqlStatment = '''
//     INSERT INTO Matchings (Seeker_FormID,	Giver_FormID,	Rec1_Status ,	Rec2_status, 	Rec1_Donation_Status, Rec2_Donation_Status)
//         VALUES ($seekerFormID, $giverFormID, 'Pending', 'Pending', 'Not Started', 'Not Started');
//     ''';
//     int rowID = await db.insertData(sqlStatment);
//     return rowID;
//   }
// }


import '../../helpers/sql_db.dart';
import '../../models/db_models/get_matchings_model.dart';

///   `MatchingsServices` class that contains everything related to the matchings query and interactions with the database

class MatchingsServices {
  
  /// The [db] database instance.
  SqlDb db = SqlDb();

  /// Retrieve all matches for a certain user given their `id`.
  ///
  /// Returns a [Future] with a List of `MatchingsModel`.
  Future<List<MatchingsModel>> getMatchings(String id) async {
    //type of current user
    String sqlStatement = '''
    SELECT
    CASE
        WHEN F1.UserID = '40' THEN 'seeker'
        ELSE 'giver'
    END AS Type,
    CASE
        WHEN F1.UserID = '40' THEN U2.FirstName
        ELSE U1.FirstName
    END AS FirstName,
    CASE
        WHEN F1.UserID = '40' THEN U2.LastName
        ELSE U1.LastName
    END AS LastName,
    CASE
        WHEN F1.UserID = '40' THEN U2.City
        ELSE U1.City
    END AS City,

    CASE
        WHEN F1.UserID = '40' THEN U2.AddressLocation
        ELSE U1.AddressLocation
    END AS AddressLocation,

    CASE
        WHEN F1.UserID = '40' THEN U2.Email
        ELSE U1.Email
    END AS Email,

     CASE
        WHEN F1.UserID = '40' THEN U2.PhoneNum
        ELSE U1.PhoneNum
    END AS PhoneNum,

    CASE
        WHEN F1.UserID = '40' THEN F2.Item
        ELSE F1.Item
    END AS Item,
    CASE
        WHEN F1.UserID = '40' THEN F2.Category
        ELSE F1.Category
    END AS Category,
    CASE
        WHEN F1.UserID = '40' THEN F2.Dates_available
        ELSE F1.Dates_available
    END AS Dates_available,
    CASE
        WHEN F1.UserID = '40' THEN F2.UserID
        ELSE F1.UserID
    END AS UserID,
    CASE
        WHEN F1.UserID = '40' THEN F2.FormID
        ELSE F1.FormID
    END AS FormID,

    M_ID, Rec1_Status, Rec2_status
    
    FROM Matchings M
    JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
    JOIN Forms F2 ON M.Giver_FormID = F2.FormID
    JOIN Users U1 ON F1.UserID = U1.UserID
    JOIN Users U2 ON F2.UserID = U2.UserID
    WHERE (F1.UserID = '40' OR F2.UserID = '40') AND M.Rec1_Donation_Status= 'Not Started'
''';
    List<MatchingsModel> matchings;

    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
   
      matchings = queryResult
          .map((matchingMap) => MatchingsModel(
              matchingID: int.parse(matchingMap['M_ID']),
              formID: int.parse(matchingMap['FormID']),
              userID: matchingMap['UserID'],
              type: matchingMap['Type'],
              firstName: matchingMap['FirstName'],
              lastName: matchingMap['LastName'],
              city: matchingMap['City'],
              addressLocation: matchingMap['AddressLocation'],
              phoneNum: matchingMap['PhoneNum'],
              email: matchingMap['Email'],
              item: matchingMap['Item'],
              category: matchingMap['Category'],
              datesAvailable: matchingMap['Dates_available'],
              seekerStatus: matchingMap['Rec1_Status'],
              giverStatus: matchingMap['Rec2_status']))
          .toList();
    } catch (e) {
      print('Error creating request: $e');

      return [];
    }

    return matchings;
  }

  /// Retrieve the count of matchings for a user.
  ///
  /// Returns a [Future] with the count of matchings.
  Future<int> getMatchingsCount(String id) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS Count
    FROM Matchings M
    JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
    JOIN Forms F2 ON M.Giver_FormID = F2.FormID
    JOIN Users U1 ON F1.UserID = U1.UserID
    JOIN Users U2 ON F2.UserID = U2.UserID
    WHERE (F1.UserID = '40' OR F2.UserID = '40') AND M.Rec1_Donation_Status = 'Not Started'
  ''';
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
      return queryResult.isNotEmpty ? int.parse(queryResult[0]['Count']) : 0;
    } catch (e) {
      print('An error occurred: $e');
      return 0;
    }
  }

  /// Update the status of a matching entry based on the user's type.
  ///
  /// Returns a [Future] with the result of the update operation.
  Future<int> updateMatching(int id, String type) async {
  
    String sqlStatement;
    if (type == 'seeker') {
      sqlStatement = '''
        UPDATE  Matchings
        SET Rec1_Status= 'Accepted',
            Rec1_Donation_Status = 
                          CASE 
                            WHEN Rec2_Status = 'Accepted' 
                          THEN 
                            'In progress'  
                          ELSE 
                            Rec1_Donation_Status 
                          END,
            Rec2_Donation_Status = 
                          CASE 
                            WHEN Rec2_Status = 'Accepted' 
                          THEN 
                            'In progress'  
                          ELSE 
                            Rec2_Donation_Status 
                          END
        WHERE M_ID = $id
      ''';
    } else {
      sqlStatement = '''
        UPDATE  Matchings
        SET Rec2_Status= 'Accepted',
        Rec1_Donation_Status = 
                          CASE 
                          WHEN Rec1_Status = 'Accepted'  
                          THEN 
                            'In progress'  
                          ELSE 
                            Rec1_Donation_Status  
                          END,
        Rec2_Donation_Status = 
                          CASE 
                          WHEN Rec1_Status = 'Accepted'  
                          THEN 
                            'In progress'  
                          ELSE 
                            Rec2_Donation_Status 
                          END
           
        WHERE M_ID = $id
      ''';
    }
    int queryResult;
    try {
      queryResult = await db.updateData(sqlStatement);
    } catch (e) {
      print('Error : $e');
      return -1;
    }
    return queryResult;
  }

  /// Delete a matching entry based on its `id`.
  ///
  /// Returns a [Future] with the result of the delete operation.
  Future<int> deleteMatching(int id) async {
    String sqlStatement = '''
    DELETE FROM Matchings
    WHERE  M_ID= $id
    ''';
    int queryResult;
    try {
      queryResult = await db.deleteData(sqlStatement);
    } catch (e) {
      print('Error : $e');
      return -1;
    }
    return queryResult;
  }

  /// Retrieve the Form IDs associated with a given matching ID.
  ///
  /// Returns a [Future] with a List of Form IDs.
  Future<List<int>> getFormIds(int mId) async {
    String sqlStatement = '''
    SELECT Seeker_FormID, Giver_FormID
    FROM Matchings
    WHERE M_ID = $mId
  ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);
    List<int> ids = [];
    if (results.isNotEmpty) {
      
      int seekerFormId = int.parse(results[0]['Seeker_FormID']) as int;
      int giverFormId = int.parse(results[0]['Giver_FormID']) as int;
      ids.add(seekerFormId);
      ids.add(giverFormId);
      return ids;
    } else {
      return [];
    }
  }

   /// Check for potential matches based on specified criteria.
  ///
  /// Returns a [Future] with a List of potential matching Form IDs.
  Future<List<int?>> checkMatching(
      String type, String item, String cat, String dates, String city) async {
    final individualDates = dates.split(',');
    final dateConditions = individualDates.map((date) {
      return "Forms.Dates_available LIKE '%$date%'";
    }).join(" OR ");

    String sqlStatement = '''
    SELECT FormID
    FROM Forms
    INNER JOIN Users ON Forms.UserID = Users.UserID
    WHERE Forms.FormType = '$type'
      AND LOWER(Forms.Item) = LOWER('$item')
      AND Forms.Category = '$cat'
      AND ( $dateConditions )
      AND Forms.FormStatus = 'Not Completed'
      AND Users.City = '$city'
    ''';
    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
  
    List<int?> matching =
        queryResult.map<int?>((row) => int.parse(row['FormID'])).toList();

    return matching;
  }

  /// Create a new match between a seeker and a giver.
  ///
  /// Returns a [Future] with the ID of the inserted row.
  Future<int> createMatch(int seekerFormID, int giverFormID) async {
    String sqlStatment = '''
    INSERT INTO Matchings (Seeker_FormID,	Giver_FormID,	Rec1_Status ,	Rec2_status, 	Rec1_Donation_Status, Rec2_Donation_Status)
        VALUES ($seekerFormID, $giverFormID, 'Pending', 'Pending', 'Not Started', 'Not Started');
    ''';
    int rowID = await db.insertData(sqlStatment);
    return rowID;
  }
}
