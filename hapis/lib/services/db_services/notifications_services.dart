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
      print(queryResult);
    } catch (e) {
      print('Error : $e');
      String error = e.toString();

      return -1;
    }
    return queryResult;
  }

  Future<List<NotifyModel>> getNotificationsByUserId(String userId) async {
    String sqlStatement = '''
      SELECT * FROM Notifications
      WHERE UserID = '$userId'
    ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);

    List<NotifyModel> notifications = results.map((result) {
      String message = result['Message'] as String;
      int id = result['N_ID'] as int;
      return NotifyModel(message: message, notifyID: id);
    }).toList();

    return notifications;
  }

  Future<int> getNotificationCount(String userId) async {
    String sqlStatement = '''
    SELECT COUNT(*) as count FROM Notifications
    WHERE UserID = '$userId'
  ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);

    int notificationCount = results.isNotEmpty ? results[0]['count'] : 0;

    return notificationCount;
  }
}

/*
- we want to send notifications in these cases:

1. someone requested someone  (NO)
2. someone accepted or declined request  (YES)
3. a match occured   (NO)
4. someone accepted, rejected the match (YES)
5. someone cancelled or finished the donation (YES)
*/ 
