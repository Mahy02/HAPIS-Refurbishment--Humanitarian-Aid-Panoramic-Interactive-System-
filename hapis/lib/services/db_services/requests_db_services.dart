import '../../helpers/sql_db.dart';

class RequestsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  Future<List<Map<String, dynamic>>> getRequestsSent() async {
    String sqlStatement = '''
    SELECT FirstName, LastName, Rec_Status
    FROM Requests
    JOIN Users ON Requests.Rec_ID = Users.UserID
    WHERE Requests.Sender_ID =14
  ''';

   

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    return queryResult;
  }

  Future<List<Map<String, dynamic>>> getRequestsReceived() async {
    String sqlStatement = '''
    SELECT FirstName, LastName, Item, Type
    FROM Requests
    JOIN Users ON Requests.Sender_ID = Users.UserID
    JOIN Forms ON Requests.Rec_FormID = Forms.FormID
    WHERE Requests.Rec_ID =14
  ''';

    List<Map<String, dynamic>> queryResult = await db.readData(sqlStatement);

    print(queryResult);
    return queryResult;
  }
}
