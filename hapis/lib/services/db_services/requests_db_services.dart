import 'package:hapis/models/db_models/get_requests_recieved_model.dart';
import 'package:hapis/models/db_models/get_requests_sent_model.dart';

import '../../helpers/sql_db.dart';

class RequestsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  Future<List<RequestSentModel>> getRequestsSent(String id) async {
    String sqlStatement = '''
    SELECT FirstName, LastName, Rec_Status
    FROM Requests
    JOIN Users ON Requests.Rec_ID = Users.UserID
    WHERE Requests.Sender_ID = $id AND Requests.Donation_Status= 'Not Started'
  ''';

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

  Future<List<RequestReceivedModel>> getRequestsReceived(String id) async {
    String sqlStatement = '''
    SELECT FirstName, LastName, Item, Type
    FROM Requests
    JOIN Users ON Requests.Sender_ID = Users.UserID
    JOIN Forms ON Requests.Rec_FormID = Forms.FormID
    WHERE Requests.Rec_ID = $id AND Requests.Donation_Status= 'Not Started'
  ''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    List<RequestReceivedModel> requests = queryResult
        .map((result) => RequestReceivedModel(
              firstName: result['FirstName'],
              lastName: result['LastName'],
              item: result['Item'],
              type: result['Type'],
            ))
        .toList();

    return requests;
  }
}
