import '../../helpers/sql_db.dart';
import '../../models/db_models/get_inprogress_donations_model.dart';

///   `DonationsServices` class that contains everything related to the donations query and interactions with the database

class DonationsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  /// `getDonationsInProgress` function that retrieves all donations in progress for a certain user given his `id`
  /// It returns a future List of `InProgressDonationModel`
  //======> *** type here can be sender rec seeker giver
  Future<List<InProgressDonationModel>> getDonationsInProgress(
      String id) async {
    String sqlStatement = '''
    SELECT
    M_ID AS MID,
    NULL AS ReqID,


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
    END AS LastName
      
    FROM Matchings M
    JOIN Forms F1 ON M.Seeker_FormID = F1.FormID
    JOIN Forms F2 ON M.Giver_FormID = F2.FormID
    JOIN Users U1 ON F1.UserID = U1.UserID
    JOIN Users U2 ON F2.UserID = U2.UserID
    WHERE (F1.UserID = '$id' OR F2.UserID = '$id') AND (M.Rec1_Donation_Status= 'In progress' OR M.Rec2_Donation_Status= 'In progress')

    UNION ALL

    SELECT 
      NULL AS MID,
      R_ID AS ReqID,



     CASE 
            WHEN R.Sender_ID = '$id' THEN 'sender'
            ELSE 'rec'
        END AS Type,


      
        CASE 
            WHEN R.Sender_ID = '$id' THEN U1.FirstName
            ELSE U2.FirstName
        END AS FirstName,
        CASE 
            WHEN R.Sender_ID = '$id' THEN U1.LastName
            ELSE U2.LastName
        END AS LastName
    FROM Requests R
    JOIN Users U1 ON R.Rec_ID = U1.UserID
    JOIN Users U2 ON R.Sender_ID = U2.UserID
    WHERE (R.Rec1_Donation_Status = 'In progress' OR R.Rec2_Donation_Status = 'In progress') AND (R.Sender_ID = '$id' OR R.Rec_ID = '$id');
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
              lastName: result['LastName'],
              type: result['Type']))
          .toList();
    } catch (e) {
      print('An error occurred: $e');

      return [];
    }

    return donations;
  }

  // Future<int> updateDonation(int rid, int mid, String type) async {
  //   int queryResultRequest = 0;
  //   int queryResultMatching = 0;

  //   if (rid != 0) {
  //     if (type == 'sender') {
  //       String sqlStatementRequest = '''
  //       UPDATE Requests
  //       SET Rec1_Donation_Status = 'Finished'
  //       WHERE R_ID = $rid
  //     ''';
  //       try {
  //         queryResultRequest = await db.updateData(sqlStatementRequest);
  //       } catch (e) {
  //         print('Error updating : $e');

  //         return -1;
  //       }
  //     } else if (type == 'rec') {
  //       String sqlStatementRequest = '''
  //       UPDATE Requests
  //       SET Rec2_Donation_Status = 'Finished'
  //       WHERE R_ID = $rid
  //     ''';
  //       try {
  //         queryResultRequest = await db.updateData(sqlStatementRequest);
  //       } catch (e) {
  //         print('Error updating : $e');

  //         return -1;
  //       }
  //     }
  //     //now do a select statment to see if both Rec2_Donation_Status and Rec1_Donation_Status are finished or not
  //   } else //there was no else and no returns here?????????????
  //   if (mid != 0) {
  //     if (type == 'seeker') {
  //       String sqlStatementMatching = '''
  //       UPDATE Matchings
  //       SET Rec1_Donation_Status = 'Finished'
  //       WHERE M_ID = $mid
  //     ''';
  //       try {
  //         queryResultMatching = await db.updateData(sqlStatementMatching);
  //       } catch (e) {
  //         print('Error updating : $e');

  //         return -1;
  //       }
  //     } else if (type == 'giver') {
  //       String sqlStatementMatching = '''
  //       UPDATE Matchings
  //       SET Rec1_Donation_Status = 'Finished'
  //       WHERE M_ID = $mid
  //     ''';
  //       try {
  //         queryResultMatching = await db.updateData(sqlStatementMatching);
  //       } catch (e) {
  //         print('Error updating : $e');

  //         return -1;
  //       }
  //     }
  //     ////now do a select statment to see if both Rec2_Donation_Status and Rec1_Donation_Status are finished or not
  //   }

  //   return queryResultMatching + queryResultRequest;
  // }

  Future<Map<String, dynamic>> updateDonation(int rid, int mid, String type) async {
  int queryResultRequest = 0;
  int queryResultMatching = 0;
  bool areBothFinished = false;

  if (rid != 0) {
    if (type == 'sender') {
      String sqlStatementRequest = '''
        UPDATE Requests
        SET Rec1_Donation_Status = 'Finished'
        WHERE R_ID = $rid
      ''';
      try {
        queryResultRequest = await db.updateData(sqlStatementRequest);
      } catch (e) {
        print('Error updating: $e');
        return {'result': -1, 'areBothFinished': false};
      }
    } else if (type == 'rec') {
      String sqlStatementRequest = '''
        UPDATE Requests
        SET Rec2_Donation_Status = 'Finished'
        WHERE R_ID = $rid
      ''';
      try {
        queryResultRequest = await db.updateData(sqlStatementRequest);
      } catch (e) {
        print('Error updating: $e');
        return {'result': -1, 'areBothFinished': false};
      }
    }

    // Check if both Rec2_Donation_Status and Rec1_Donation_Status are finished
    String sqlStatementCheck = '''
      SELECT Rec1_Donation_Status, Rec2_Donation_Status
      FROM Requests
      WHERE R_ID = $rid
    ''';
    try {
      List<Map<String, dynamic>> result = await db.readData(sqlStatementCheck);
      if (result.isNotEmpty) {
        String rec1Status = result[0]['Rec1_Donation_Status'];
        String rec2Status = result[0]['Rec2_Donation_Status'];
        if (rec1Status == 'Finished' && rec2Status == 'Finished') {
          areBothFinished = true;
        }
      }
    } catch (e) {
      print('Error checking status: $e');
      return {'result': -1, 'areBothFinished': false};
    }
  } else if (mid != 0) {
    if (type == 'seeker') {
      String sqlStatementMatching = '''
        UPDATE Matchings
        SET Rec1_Donation_Status = 'Finished'
        WHERE M_ID = $mid
      ''';
      try {
        queryResultMatching = await db.updateData(sqlStatementMatching);
      } catch (e) {
        print('Error updating: $e');
        return {'result': -1, 'areBothFinished': false};
      }
    } else if (type == 'giver') {
      String sqlStatementMatching = '''
        UPDATE Matchings
        SET Rec1_Donation_Status = 'Finished'
        WHERE M_ID = $mid
      ''';
      try {
        queryResultMatching = await db.updateData(sqlStatementMatching);
      } catch (e) {
        print('Error updating: $e');
        return {'result': -1, 'areBothFinished': false};
      }
    }

    // Check if both Rec2_Donation_Status and Rec1_Donation_Status are finished
    String sqlStatementCheck = '''
      SELECT Rec1_Donation_Status, Rec2_Donation_Status
      FROM Matchings
      WHERE M_ID = $mid
    ''';
    try {
      List<Map<String, dynamic>> result = await db.readData(sqlStatementCheck);
      if (result.isNotEmpty) {
        String rec1Status = result[0]['Rec1_Donation_Status'];
        String rec2Status = result[0]['Rec2_Donation_Status'];
        if (rec1Status == 'Finished' && rec2Status == 'Finished') {
          areBothFinished = true;
        }
      }
    } catch (e) {
      print('Error checking status: $e');
      return {'result': -1, 'areBothFinished': false};
    }
  }

  return {'result': queryResultMatching + queryResultRequest, 'areBothFinished': areBothFinished};
}
Future<bool> checkBothFinished(int rid, int mid) async {
  bool areBothFinished = false;

  if (rid != 0) {
    String sqlStatementCheck = '''
      SELECT Rec1_Donation_Status, Rec2_Donation_Status
      FROM Requests
      WHERE R_ID = $rid
    ''';
    try {
      List<Map<String, dynamic>> result = await db.readData(sqlStatementCheck);
      if (result.isNotEmpty) {
        String rec1Status = result[0]['Rec1_Donation_Status'];
        String rec2Status = result[0]['Rec2_Donation_Status'];
        if (rec1Status == 'Finished' && rec2Status == 'Finished') {
          areBothFinished = true;
        }
      }
    } catch (e) {
      print('Error checking status: $e');
    }
  } else if (mid != 0) {
    String sqlStatementCheck = '''
      SELECT Rec1_Donation_Status, Rec2_Donation_Status
      FROM Matchings
      WHERE M_ID = $mid
    ''';
    try {
      List<Map<String, dynamic>> result = await db.readData(sqlStatementCheck);
      if (result.isNotEmpty) {
        String rec1Status = result[0]['Rec1_Donation_Status'];
        String rec2Status = result[0]['Rec2_Donation_Status'];
        if (rec1Status == 'Finished' && rec2Status == 'Finished') {
          areBothFinished = true;
        }
      }
    } catch (e) {
      print('Error checking status: $e');
    }
  }

  return areBothFinished;
}
}
