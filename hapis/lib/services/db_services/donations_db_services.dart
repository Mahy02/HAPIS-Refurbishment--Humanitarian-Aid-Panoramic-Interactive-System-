import '../../helpers/sql_db.dart';
import '../../models/db_models/get_inprogress_donations_model.dart';

///   `DonationsServices` class that contains everything related to the donations query and interactions with the database

class DonationsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  /// `getDonationsInProgress` function that retrieves all donations in progress for a certain user given his `id`
  /// It returns a future List of `InProgressDonationModel`
  Future<List<InProgressDonationModel>> getDonationsInProgress(
      String id) async {
    String sqlStatement = '''
    SELECT

    CASE
        WHEN F1.UserID = $id THEN U2.FirstName
        ELSE U1.FirstName
    END AS FirstName,
    CASE
        WHEN F1.UserID = $id THEN U2.LastName
        ELSE U1.LastName
    END AS LastName
      
    FROM Matchings M
    JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
    JOIN Forms F2 ON M.Giver_FormID = F2.FormID
    JOIN Users U1 ON F1.UserID = U1.UserID
    JOIN Users U2 ON F2.UserID = U2.UserID
    WHERE (F1.UserID = $id OR F2.UserID = $id) AND M.Donation_Status= 'In progress'

    UNION ALL

    SELECT 
      
        CASE 
            WHEN R.Sender_ID = $id THEN U1.FirstName
            ELSE U2.FirstName
        END AS FirstName,
        CASE 
            WHEN R.Sender_ID = $id THEN U1.LastName
            ELSE U2.LastName
        END AS LastName
    FROM Requests R
    JOIN Users U1 ON R.Rec_ID = U1.UserID
    JOIN Users U2 ON R.Sender_ID = U2.UserID
    WHERE R.Donation_Status = 'In progress' AND (R.Sender_ID = $id OR R.Rec_ID = $id);
    ''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    List<InProgressDonationModel> donations = queryResult
        .map((result) => InProgressDonationModel(
            firstName: result['FirstName'], lastName: result['LastName']))
        .toList();

    return donations;
  }
}
