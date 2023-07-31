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
        WHEN F1.UserID = $id THEN 'seeker'
        ELSE 'giver'
    END AS Type,
    CASE
        WHEN F1.UserID = $id THEN U2.FirstName
        ELSE U1.FirstName
    END AS FirstName,
    CASE
        WHEN F1.UserID = $id THEN U2.LastName
        ELSE U1.LastName
    END AS LastName,
    CASE
        WHEN F1.UserID = $id THEN U2.City
        ELSE U1.City
    END AS City,

    CASE
        WHEN F1.UserID = $id THEN U2.AddressLocation
        ELSE U1.AddressLocation
    END AS AddressLocation,

    CASE
        WHEN F1.UserID = $id THEN U2.Email
        ELSE U1.Email
    END AS Email,

     CASE
        WHEN F1.UserID = $id THEN U2.PhoneNum
        ELSE U1.PhoneNum
    END AS PhoneNum,

    CASE
        WHEN F1.UserID = $id THEN F2.Item
        ELSE F1.Item
    END AS Item,
    CASE
        WHEN F1.UserID = $id THEN F2.Category
        ELSE F1.Category
    END AS Category,
    CASE
        WHEN F1.UserID = $id THEN F2.Dates_available
        ELSE F1.Dates_available
    END AS Dates_available,
    CASE
        WHEN F1.UserID = $id THEN F2.UserID
        ELSE F1.UserID
    END AS UserID,
    CASE
        WHEN F1.UserID = $id THEN F2.FormID
        ELSE F1.FormID
    END AS FormID,

    M_ID, Rec1_Status, Rec2_Status
    
FROM Matchings M
JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
JOIN Forms F2 ON M.Giver_FormID = F2.FormID
JOIN Users U1 ON F1.UserID = U1.UserID
JOIN Users U2 ON F2.UserID = U2.UserID
WHERE (F1.UserID = $id OR F2.UserID = $id) AND M.Donation_Status= 'Not Started'
''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
    print(queryResult);

    List<MatchingsModel> matchings = queryResult
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
            seekerStatus: matchingMap['Rec1_Status'] ?? '',
            giverStatus: matchingMap['Rec2_Status'] ?? ''))
        .toList();

    return matchings;
  }

  Future<int> updateMatching(int id, String type) async {
    String sqlStatement;
    if (type == 'seeker') {
      sqlStatement = '''
        UPDATE  Matchings
        SET Rec1_Status= 'Accepted',
            Donation_Status = 
                          CASE 
                            WHEN Rec2_Status = 'Accepted' 
                          THEN 
                            'In progress'  
                          ELSE 
                            Donation_Status 
                          END
        WHERE M_ID = $id
      ''';
    } else {
      sqlStatement = '''
        UPDATE  Matchings
        SET Rec2_Status= 'Accepted',
        Donation_Status = 
                          CASE 
                          WHEN Rec1_Status = 'Accepted'  
                          THEN 
                            'In progress'  
                          ELSE 
                            Donation_Status 
                          END
           
        WHERE M_ID = $id
      ''';
    }
    int queryResult = await db.updateData(sqlStatement);
    return queryResult;
  }

  Future<int> deleteMatching(int id) async {
    String sqlStatement = '''
    DELETE FROM Matchings
    WHERE  M_ID= $id
    ''';
    int queryResult = await db.deleteData(sqlStatement);
    return queryResult;
  }
}

/*
*/
