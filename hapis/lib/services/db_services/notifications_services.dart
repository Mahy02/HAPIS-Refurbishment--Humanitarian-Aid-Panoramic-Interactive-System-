import 'package:hapis/models/db_models/notify_models.dart';

import '../../helpers/sql_db.dart';

class NotificationsServices {
  /// retrieving the [db] database instance
  SqlDb db = SqlDb();

  //insert
  Future<int> insertNotification(String userId, String message) async {
    String sqlStatment = '''
    INSERT INTO Notifications (UserID, Message)
    VALUES ('$userId', '$message')
  ''';
    int rowID = await db.insertData(sqlStatment);

    return rowID;
  }

  //delete

  Future<int> deleteNotification(int notificationId) async {
    String sqlStatement = '''
    DELETE FROM Notifications
    WHERE N_ID = $notificationId
  ''';
    int queryResult;
    try {
      queryResult = await db.deleteData(sqlStatement);
    } catch (e) {
      print('Error : $e');
      String error = e.toString();

      return -1;
    }
    return queryResult;
  }

  //retrieve notfications for a current userId
  // Future<List<String>> getNotificationsByUserId(String userId) async {
  //   String sqlStatment = '''
  //   SELECT * FROM Notifications
  //   WHERE UserID = '$userId'
  // ''';
  //   List<Map<String, dynamic>> results = await db.readData(sqlStatment);
  //   // Extract the 'Message' values from the results and return as a List<String>
  //   List<String> messages =
  //       results.map((result) => result['Message'] as String).toList();

  //   return messages;
  // }

   Future<List<NotifyModel>> getNotificationsByUserId(String userId) async {
    String sqlStatement = '''
      SELECT * FROM Notifications
      WHERE UserID = '$userId'
    ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);

    List<NotifyModel> notifications = results.map((result) {
      String message = result['Message'] as String;
      return NotifyModel(message: message);
    }).toList();

    return notifications;
  }
}

/*
- we want to send notifications in these cases:

1. someone requested someone
2. someone accepted or declined request
3. a match occured
4. someone accepted, rejected the match
5. someone cancelled or finished the donation
*/
