import '../../helpers/sql_db.dart';
import '../../models/db_models/get_matchings_model.dart';

class MatchingsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  Future<List<MatchingsModel>> getMatchings() async {
    String sqlStatement = '''
    SELECT
    CASE
        WHEN F1.UserID = 32 THEN 'seeker'
        ELSE 'giver'
    END AS Type,
    CASE
        WHEN F1.UserID = 32 THEN U2.FirstName
        ELSE U1.FirstName
    END AS FirstName,
    CASE
        WHEN F1.UserID = 32 THEN U2.LastName
        ELSE U1.LastName
    END AS LastName,
    CASE
        WHEN F1.UserID = 32 THEN U2.City
        ELSE U1.City
    END AS City,

    CASE
        WHEN F1.UserID = 32 THEN U2.AddressLocation
        ELSE U1.AddressLocation
    END AS AddressLocation,

    CASE
        WHEN F1.UserID = 32 THEN U2.Email
        ELSE U1.Email
    END AS Email,

     CASE
        WHEN F1.UserID = 32 THEN U2.PhoneNum
        ELSE U1.PhoneNum
    END AS PhoneNum,

    CASE
        WHEN F1.UserID = 32 THEN F2.Item
        ELSE F1.Item
    END AS Item,
    CASE
        WHEN F1.UserID = 32 THEN F2.Category
        ELSE F1.Category
    END AS Category,
    CASE
        WHEN F1.UserID = 32 THEN F2.Dates_available
        ELSE F1.Dates_available
    END AS Dates_available
    
FROM Matchings M
JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
JOIN Forms F2 ON M.Giver_FormID = F2.FormID
JOIN Users U1 ON F1.UserID = U1.UserID
JOIN Users U2 ON F2.UserID = U2.UserID
WHERE F1.UserID = 32 OR F2.UserID = 32
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

/*






SELECT
    M.M_ID,
    M.Seek_FormID,
    M.Giver_FormID,
    CASE
        WHEN F1.User_ID = <current_user_id> THEN 'Seeker'
        WHEN F2.User_ID = <current_user_id> THEN 'Giver'
        ELSE 'Unknown'
    END AS User_Type,
    U1.First_Name AS Seeker_First_Name,
    U1.Last_Name AS Seeker_Last_Name,
    U2.First_Name AS Giver_First_Name,
    U2.Last_Name AS Giver_Last_Name,
    F1.Item AS Seeker_Item,
    F2.Item AS Giver_Item,
    F1.Category AS Seeker_Category,
    F2.Category AS Giver_Category,
    M.Rec1_Status,
    M.Rec2_Status,
    M.Donation_Status
FROM Matchings M
JOIN Forms F1 ON M.Seek_FormID = F1.Form_ID
JOIN Forms F2 ON M.Giver_FormID = F2.Form_ID
JOIN Users U1 ON F1.User_ID = U1.user_ID
JOIN Users U2 ON F2.User_ID = U2.user_ID
WHERE F1.User_ID = <current_user_id> OR F2.User_ID = <current_user_id>;


SELECT
  Matchings.M_ID,
  Seeker.FirstName AS SeekerFirstName,
  Seeker.LastName AS SeekerLastName,
  Giver.FirstName AS GiverFirstName,
  Giver.LastName AS GiverLastName,
  Matchings.Rec1_Status,
  Matchings.Rec2_Status,
  Matchings.Donation_Status
FROM Matchings
JOIN Forms AS SeekerForm ON Matchings.Seeker_FormID = SeekerForm.FormID
JOIN Forms AS GiverForm ON Matchings.Giver_FormID = GiverForm.FormID
JOIN Users AS Seeker ON SeekerForm.UserID = Seeker.UserID
JOIN Users AS Giver ON GiverForm.UserID = Giver.UserID
WHERE Seeker.UserID = ? OR Giver.UserID = ?

*/