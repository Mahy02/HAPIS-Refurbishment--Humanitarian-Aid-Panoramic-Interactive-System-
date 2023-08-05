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
    M_ID AS MID,
    NULL AS ReqID,
    Rec1_Donation_Status,
    Rec2_Donation_Status,
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
    WHERE (F1.UserID = $id OR F2.UserID = $id) AND M.Rec1_Donation_Status= 'In progress'

    UNION ALL

    SELECT 
      NULL AS MID,
      R_ID AS ReqID,
       Rec1_Donation_Status,
       Rec2_Donation_Status
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
    WHERE R.Rec1_Donation_Status = 'In progress' AND (R.Sender_ID = '$id' OR R.Rec_ID = '$id');
    ''';
    List<InProgressDonationModel> donations;
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
      print(queryResult);
      donations = queryResult
          .map((result) => InProgressDonationModel(
              mID: result['MID'] ?? 0,
              rID: result['ReqID'] ?? 0,
              firstName: result['FirstName'],
              lastName: result['LastName']))
          .toList();
    } catch (e) {
      print('An error occurred: $e');

      return [];
    }

    return donations;
  }

  // Future<int> updateDonation(int rid, int mid) async {
  //   int queryResultRequest = 0;
  //   int queryResultMatching = 0;
  //   if (rid != 0) {
  //     String sqlStatementRequest = '''
  //       UPDATE Requests
  //       SET Donation_Status = 'Finished'          
  //       WHERE R_ID = $rid
  //     ''';
  //     try {
  //       queryResultRequest = await db.updateData(sqlStatementRequest);
  //     } catch (e) {
  //       print('Error updating : $e');

  //       return -1;
  //     }
  //   } else //there was no else and no returns here?????????????
  //   if (mid != 0) {
  //     String sqlStatementMatching = '''
  //       UPDATE Matchings
  //       SET Donation_Status = 'Finished'          
  //       WHERE M_ID = $mid
  //     ''';
  //     try {
  //       queryResultMatching = await db.updateData(sqlStatementMatching);
  //     } catch (e) {
  //       print('Error updating : $e');

  //       return -1;
  //     }
  //   }

  //   return queryResultMatching + queryResultRequest;
  // }
}
