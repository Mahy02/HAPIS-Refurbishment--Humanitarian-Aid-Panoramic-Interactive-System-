import '../../helpers/sql_db.dart';

class DonationsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  Future<List<Map<String, dynamic>>> getDonationsInProgress() async {
    String sqlStatement = '''
    SELECT

    CASE
        WHEN F1.UserID = 7 THEN U2.FirstName
        ELSE U1.FirstName
    END AS FirstName,
    CASE
        WHEN F1.UserID = 7 THEN U2.LastName
        ELSE U1.LastName
    END AS LastName
   
FROM Matchings M
JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
JOIN Forms F2 ON M.Giver_FormID = F2.FormID
JOIN Users U1 ON F1.UserID = U1.UserID
JOIN Users U2 ON F2.UserID = U2.UserID
WHERE (F1.UserID = 7 OR F2.UserID = 7) AND M.Donation_Status= 'In progress'

UNION ALL

SELECT 
   
    CASE 
        WHEN R.Sender_ID = 7 THEN U1.FirstName
        ELSE U2.FirstName
    END AS FirstName,
    CASE 
        WHEN R.Sender_ID = 7 THEN U1.LastName
        ELSE U2.LastName
    END AS LastName
FROM Requests R
JOIN Users U1 ON R.Rec_ID = U1.UserID
JOIN Users U2 ON R.Sender_ID = U2.UserID
WHERE R.Donation_Status = 'In progress' AND (R.Sender_ID = 7 OR R.Rec_ID = 7);


''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    print(queryResult);

    return queryResult;
  }
}
