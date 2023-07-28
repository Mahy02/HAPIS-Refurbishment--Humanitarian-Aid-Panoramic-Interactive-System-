import '../../helpers/sql_db.dart';
import '../../models/db_models/get_matchings_model.dart';

///   `MatchingsServices` class that contains everything related to the matchings query and interactions with the database

class MatchingsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

 /// `getMatchings` function that retrieves all matches for a certain user given his `id`
 /// It returns a future List of `MatchingsModel`
  Future<List<MatchingsModel>> getMatchings(String id) async {
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
    END AS Dates_available
    
FROM Matchings M
JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
JOIN Forms F2 ON M.Giver_FormID = F2.FormID
JOIN Users U1 ON F1.UserID = U1.UserID
JOIN Users U2 ON F2.UserID = U2.UserID
WHERE (F1.UserID = $id OR F2.UserID = $id) AND M.Donation_Status= 'Not Started'
''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    List<MatchingsModel> matchings = queryResult
        .map((matchingMap) => MatchingsModel(
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
            ))
        .toList();

    return matchings;
  }
}
