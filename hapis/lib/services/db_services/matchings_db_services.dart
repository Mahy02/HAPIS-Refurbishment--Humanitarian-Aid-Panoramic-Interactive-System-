import '../../helpers/sql_db.dart';
import '../../models/db_models/get_matchings_model.dart';

///   `MatchingsServices` class that contains everything related to the matchings query and interactions with the database

class MatchingsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  /// `getMatchings` function that retrieves all matches for a certain user given his `id`
  /// It returns a future List of `MatchingsModel`
  Future<List<MatchingsModel>> getMatchings(String id) async {
    //type of current user
    String sqlStatement = '''
    SELECT
    CASE
        WHEN F1.UserID = '$id' THEN 'seeker'
        ELSE 'giver'
    END AS Type,
    CASE
        WHEN F1.UserID = '$id' THEN U2.FirstName
        ELSE U1.FirstName
    END AS FirstName,
    CASE
        WHEN F1.UserID = '$id' THEN U2.LastName
        ELSE U1.LastName
    END AS LastName,
    CASE
        WHEN F1.UserID = '$id' THEN U2.City
        ELSE U1.City
    END AS City,

    CASE
        WHEN F1.UserID = '$id' THEN U2.AddressLocation
        ELSE U1.AddressLocation
    END AS AddressLocation,

    CASE
        WHEN F1.UserID = '$id' THEN U2.Email
        ELSE U1.Email
    END AS Email,

     CASE
        WHEN F1.UserID = '$id' THEN U2.PhoneNum
        ELSE U1.PhoneNum
    END AS PhoneNum,

    CASE
        WHEN F1.UserID = '$id' THEN F2.Item
        ELSE F1.Item
    END AS Item,
    CASE
        WHEN F1.UserID = '$id' THEN F2.Category
        ELSE F1.Category
    END AS Category,
    CASE
        WHEN F1.UserID = '$id' THEN F2.Dates_available
        ELSE F1.Dates_available
    END AS Dates_available,
    CASE
        WHEN F1.UserID = '$id' THEN F2.UserID
        ELSE F1.UserID
    END AS UserID,
    CASE
        WHEN F1.UserID = '$id' THEN F2.FormID
        ELSE F1.FormID
    END AS FormID,

    M_ID, Rec1_Status, Rec2_status
    
FROM Matchings M
JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
JOIN Forms F2 ON M.Giver_FormID = F2.FormID
JOIN Users U1 ON F1.UserID = U1.UserID
JOIN Users U2 ON F2.UserID = U2.UserID
WHERE (F1.UserID = '$id' OR F2.UserID = '$id') AND M.Rec1_Donation_Status= 'Not Started'
''';
    List<MatchingsModel> matchings;

    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
      print(queryResult);

      matchings = queryResult
          .map((matchingMap) => MatchingsModel(
              matchingID: matchingMap['M_ID'],
              formID: matchingMap['FormID'],
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
      String error = e.toString();

      return [];
    }

    return matchings;
  }

  Future<int> updateMatching(int id, String type) async {
    print(type);
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
      String error = e.toString();

      return -1;
    }
    return queryResult;
  }

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
      String error = e.toString();

      return -1;
    }
    return queryResult;
  }

  Future<List<int>> getFormIds(int mId) async {
    String sqlStatement = '''
    SELECT Seeker_FormID, Giver_FormID
    FROM Matchings
    WHERE M_ID = $mId
  ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);
    if (results.isNotEmpty) {
      int seekerFormId = results[0]['Seeker_FormID'];
      int giverFormId = results[0]['Giver_FormID'];
      return [seekerFormId, giverFormId];
    } else {
      return [];
    }
  }

  Future<List<int?>> checkMatching(
      String type, String item, String cat, String dates, String city) async {
    String sqlStatement = '''
    SELECT FormID
    FROM Forms
    INNER JOIN Users ON Forms.UserID = Users.UserID
    WHERE Forms.Type = '$type' AND Forms.Item = '$item' AND Forms.Category = '$cat' AND Forms.Dates_available LIKE '%$dates%' AND Forms.Status = 'Not Completed' AND Users.City = '$city' 
    ''';
    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    // If a matching form exists, return its Form_ID
    List<int?> matching =
        queryResult.map<int?>((row) => row['FormID']).toList();

    return matching;
  }

  Future<int> createMatch(int seekerFormID, int giverFormID) async {
    String sqlStatment = '''
    INSERT INTO Matchings (Seeker_FormID,	Giver_FormID,	Rec1_Status ,	Rec2_status, 	Rec1_Donation_Status, Rec2_Donation_Status)
        VALUES ($seekerFormID, $giverFormID, 'Pending', 'Pending', 'Not Started', 'Not Started')
    ''';

    int rowID = await db.insertData(sqlStatment);

    return rowID;
  }
}
