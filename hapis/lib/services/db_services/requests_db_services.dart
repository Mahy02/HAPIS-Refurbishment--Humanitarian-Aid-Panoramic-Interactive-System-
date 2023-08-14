import 'package:hapis/models/db_models/get_requests_recieved_model.dart';
import 'package:hapis/models/db_models/get_requests_sent_model.dart';

import '../../helpers/sql_db.dart';

///   `RequestsServices` class that contains everything related to the requests query and interactions with the database

class RequestsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  /// `getRequestsSent` function that retrives all requests sent for a certain user taking his `id`
  /// It returns Future list of `RequestSentModel`
  Future<List<RequestSentModel>> getRequestsSent(String id) async {
    String sqlStatement = '''
    SELECT FirstName, LastName, Rec_Status, R_ID
    FROM Requests
    JOIN Users ON Requests.Rec_ID = Users.UserID
    WHERE Requests.Sender_ID = '$id' AND Requests.Rec1_Donation_Status= 'Not Started' AND Rec_Status= 'Pending'
  ''';
    List<RequestSentModel> requests;
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

      requests = queryResult
          .map((result) => RequestSentModel(
              RId: int.parse(result['R_ID']),
              firstName: result['FirstName'],
              lastName: result['LastName'],
              recipientStatus: result['Rec_Status']))
          .toList();
    } catch (e) {
      print('An error occurred: $e');

      return [];
    }

    return requests;
  }

  /// `getRequestsReceived` function that retrives all requests received for a certain user taking his `id`
  /// It returns Future list of `RequestReceivedModel`
  Future<List<RequestReceivedModel>> getRequestsReceived(String id) async {
    String sqlStatement = '''
    SELECT FirstName, LastName, Item, FormType, R_ID, Users.UserID AS UserID
    FROM Requests
    JOIN Users ON Requests.Sender_ID = Users.UserID
    JOIN Forms ON Requests.Rec_FormID = Forms.FormID
    WHERE Requests.Rec_ID = '$id' AND Requests.Rec1_Donation_Status= 'Not Started' AND Rec_Status= 'Pending'
  ''';
    List<RequestReceivedModel> requests;
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

      requests = queryResult
          .map((result) => RequestReceivedModel(
              RId: int.parse(result['R_ID']),
              userId: result['UserID'],
              firstName: result['FirstName'],
              lastName: result['LastName'],
              item: result['Item'],
              type: result['FormType']))
          .toList();
    } catch (e) {
      print('An error occurred: $e');

      return [];
    }

    return requests;
  }

  /// Function to get the count of requests sent by a user
  Future<int> getRequestsSentCount(String id) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS Count
    FROM Requests
    WHERE Sender_ID = '$id' AND Rec1_Donation_Status = 'Not Started' AND Rec_Status = 'Pending'
  ''';
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
      return queryResult.isNotEmpty ? int.parse(queryResult[0]['Count']) : 0;
    } catch (e) {
      print('An error occurred: $e');
      return 0;
    }
  }

  /// Function to get the count of requests received by a user
  Future<int> getRequestsReceivedCount(String id) async {
    String sqlStatement = '''
    SELECT COUNT(*) AS Count
    FROM Requests
    WHERE Rec_ID = '$id' AND Rec1_Donation_Status = 'Not Started' AND Rec_Status = 'Pending'
  ''';
    try {
      List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);
      return queryResult.isNotEmpty ? int.parse(queryResult[0]['Count']) : 0;
    } catch (e) {
      print('An error occurred: $e');
      return 0;
    }
  }

  Future<int> acceptRequest(int id) async {
    String sqlStatement = '''
    UPDATE Requests 
    SET Rec1_Donation_Status = 'In progress' , Rec_Status= 'Accepted', Rec2_Donation_Status = 'In progress'
    WHERE R_ID = $id
    ''';
    try {
      int queryResult = await db.updateData(sqlStatement);

      return queryResult;
    } catch (e) {
      print('Error updating form: $e');

      return -3; // Error updating request
    }
  }

  Future<int> deleteRequest(int id) async {
    String sqlStatement = '''
    DELETE FROM Requests
    WHERE Requests.R_ID = $id
    ''';
    int queryResult;
    try {
      queryResult = await db.deleteData(sqlStatement);
    } catch (e) {
      print('Error deleting form: $e');
      return 0;
    }
    return queryResult;
  }

  Future<int> getFormId(int rId) async {
    String sqlStatement = '''
    SELECT Rec_FormID
    FROM Requests
    WHERE R_ID = $rId
  ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);
    if (results.isNotEmpty) {
      int recFormId = int.parse(results[0]['Rec_FormID']);

      return recFormId;
    } else {
      return 0;
    }
  }

  Future<int> createRequest(String senderID, String recID, int formID) async {
    String sqlStatment = '''
    INSERT INTO Requests (Sender_ID, Rec_ID, Rec_FormID, Rec_Status, Rec1_Donation_Status, Rec2_Donation_Status)
        VALUES ('$senderID' , '$recID' , $formID, 'Pending', 'Not Started', 'Not Started');
    ''';

    try {
      int rowID = await db.insertData(sqlStatment);

      return rowID;
    } catch (e) {
      print('Error creating request: $e');
      String error = e.toString();

      return -3;
    }
  }

  Future<bool> checkFriendshipRequest(
      String senderId, String recId, int recFormID) async {
    String sqlStatement = '''
    SELECT 1
    FROM Requests
    WHERE Sender_ID = '$senderId' AND Rec_ID = '$recId' AND  (Rec1_Donation_Status != 'Cancelled' AND Rec2_Donation_Status != 'Cancelled') AND Rec_FormID =$recFormID
  ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);

    return results.isNotEmpty;
  }
}
