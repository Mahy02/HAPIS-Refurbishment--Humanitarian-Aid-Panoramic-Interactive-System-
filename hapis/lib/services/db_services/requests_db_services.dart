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
    SELECT FirstName, LastName, Rec_Status
    FROM Requests
    JOIN Users ON Requests.Rec_ID = Users.UserID
    WHERE Requests.Sender_ID = $id AND Requests.Donation_Status= 'Not Started' AND Rec_Status= 'Pending'
  ''';
//AND (Requests.Donation_Status= 'Not Started' AND (Rec_Status= 'Pending' OR Rec_Status= 'Accepted' ))
    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    List<RequestSentModel> requests = queryResult
        .map((result) => RequestSentModel(
              firstName: result['FirstName'],
              lastName: result['LastName'],
              recipientStatus: result['Rec_Status'],
            ))
        .toList();

    return requests;
  }

  /// `getRequestsReceived` function that retrives all requests received for a certain user taking his `id`
  /// It returns Future list of `RequestReceivedModel`
  Future<List<RequestReceivedModel>> getRequestsReceived(String id) async {
    String sqlStatement = '''
    SELECT FirstName, LastName, Item, Type, R_ID
    FROM Requests
    JOIN Users ON Requests.Sender_ID = Users.UserID
    JOIN Forms ON Requests.Rec_FormID = Forms.FormID
    WHERE Requests.Rec_ID = $id AND Requests.Donation_Status= 'Not Started' AND Rec_Status= 'Pending'
  ''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    List<RequestReceivedModel> requests = queryResult
        .map((result) => RequestReceivedModel(
              RId: result['R_ID'],
              firstName: result['FirstName'],
              lastName: result['LastName'],
              item: result['Item'],
              type: result['Type'],
            ))
        .toList();

    return requests;
  }

  Future<int> acceptRequest(int id) async {
    String sqlStatement = '''
    UPDATE Requests 
    SET Donation_Status = 'In progress' , Rec_Status= 'Accepted'
    WHERE R_ID = $id
    ''';
    int queryResult = await db.updateData(sqlStatement);
    return queryResult;
  }

  Future<int> deleteRequest(int id) async {
    String sqlStatement = '''
    DELETE FROM Requests
    WHERE Requests.R_ID = $id
    ''';
    int queryResult = await db.deleteData(sqlStatement);
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
      int recFormId = results[0]['Rec_FormID'];

      return recFormId;
    } else {
      return 0;
    }
  }

  Future<int> createRequest(String senderID, String recID, int formID) async {
    String sqlStatment = '''
    INSERT INTO Requests (Sender_ID, Rec_ID, Rec_FormID, Rec_Status, Donation_Status)
        VALUES ($senderID , $recID , $formID, 'Pending', 'Not Started')
    ''';
    int rowID = await db.insertData(sqlStatment);

    return rowID;
  }

  Future<bool> checkFriendshipRequest(String senderId, String recId) async {
    String sqlStatement = '''
    SELECT 1
    FROM Requests
    WHERE Sender_ID = $senderId AND Rec_ID = $recId
  ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);
    print(results);
    return results.isNotEmpty;
  }
}
