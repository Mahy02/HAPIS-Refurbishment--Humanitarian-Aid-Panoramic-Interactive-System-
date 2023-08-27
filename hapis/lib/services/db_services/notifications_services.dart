// import 'package:hapis/models/db_models/notify_models.dart';

// import '../../helpers/sql_db.dart';

// /// The `NotificationsServices` class contains methods for managing user notifications using the database.

// class NotificationsServices {

//   /// The [db] database instance.
//   SqlDb db = SqlDb();

//    /// Insert a new notification entry for a user with the given message.
//   ///
//   /// Returns a [Future] with the ID of the inserted row.
//   Future<int> insertNotification(String userId, String message) async {
//     String sqlStatment = '''
//     INSERT INTO Notifications (UserID, Message)
//     VALUES ('$userId', '$message')
//   ''';
//     int rowID = await db.insertData(sqlStatment);

//     return rowID;
//   }

//   /// Delete a notification entry based on its `notificationId`.
//   ///
//   /// Returns a [Future] with the result of the delete operation.
//   Future<int> deleteNotification(int notificationId) async {
//     String sqlStatement = '''
//     DELETE FROM Notifications
//     WHERE N_ID = $notificationId
//   ''';
//     int queryResult;
//     try {
//       queryResult = await db.deleteData(sqlStatement);
//     } catch (e) {
//       print('Error : $e');
//       return -1;
//     }
//     return queryResult;
//   }

//   /// Retrieve notifications for a user with the specified `userId`.
//   ///
//   /// Returns a [Future] with a List of `NotifyModel` representing notifications.
//   Future<List<NotifyModel>> getNotificationsByUserId(String userId) async {
//     String sqlStatement = '''
//       SELECT * FROM Notifications
//       WHERE UserID = '$userId'
//     ''';
//     List<Map<String, dynamic>> results = await db.readData(sqlStatement);

//     List<NotifyModel> notifications = results.map((result) {
//       String message = result['Message'] as String;
//       int id = int.parse(result['N_ID']) as int;
//       return NotifyModel(message: message, notifyID: id);
//     }).toList();

//     return notifications;
//   }

//   /// Retrieve the count of notifications for a user with the specified `userId`.
//   ///
//   /// Returns a [Future] with the count of notifications.
//   Future<int> getNotificationCount(String userId) async {
//     String sqlStatement = '''
//     SELECT COUNT(*) as count FROM Notifications
//     WHERE UserID = '$userId'
//   ''';
//     List<Map<String, dynamic>> results = await db.readData(sqlStatement);

//     String notificationCountString =
//         results.isNotEmpty ? results[0]['count'] : '0';
//     int notificationCount = int.parse(notificationCountString);

//     return notificationCount;
//   }
// }



import 'package:hapis/models/db_models/notify_models.dart';

import '../../helpers/sql_db.dart';

/// The `NotificationsServices` class contains methods for managing user notifications using the database.

class NotificationsServices {

  /// The [db] database instance.
  SqlDb db = SqlDb();

   /// Insert a new notification entry for a user with the given message.
  ///
  /// Returns a [Future] with the ID of the inserted row.
  Future<int> insertNotification(String userId, String message) async {
    String sqlStatment = '''
    INSERT INTO Notifications (UserID, Message)
    VALUES ('40', '$message')
  ''';
    int rowID = await db.insertData(sqlStatment);

    return rowID;
  }

  /// Delete a notification entry based on its `notificationId`.
  ///
  /// Returns a [Future] with the result of the delete operation.
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
      return -1;
    }
    return queryResult;
  }

  /// Retrieve notifications for a user with the specified `userId`.
  ///
  /// Returns a [Future] with a List of `NotifyModel` representing notifications.
  Future<List<NotifyModel>> getNotificationsByUserId(String userId) async {
    String sqlStatement = '''
      SELECT * FROM Notifications
      WHERE UserID = '40'
    ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);

    List<NotifyModel> notifications = results.map((result) {
      String message = result['Message'] as String;
      int id = int.parse(result['N_ID']) as int;
      return NotifyModel(message: message, notifyID: id);
    }).toList();

    return notifications;
  }

  /// Retrieve the count of notifications for a user with the specified `userId`.
  ///
  /// Returns a [Future] with the count of notifications.
  Future<int> getNotificationCount(String userId) async {
    String sqlStatement = '''
    SELECT COUNT(*) as count FROM Notifications
    WHERE UserID = '40'
  ''';
    List<Map<String, dynamic>> results = await db.readData(sqlStatement);

    String notificationCountString =
        results.isNotEmpty ? results[0]['count'] : '0';
    int notificationCount = int.parse(notificationCountString);

    return notificationCount;
  }
}



