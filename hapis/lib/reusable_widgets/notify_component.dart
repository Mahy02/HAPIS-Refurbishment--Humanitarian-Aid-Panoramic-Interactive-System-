import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/services/db_services/notifications_services.dart';

import '../utils/database_popups.dart';

class NotificationComponent extends StatefulWidget {
  final String title;
  final String message;
  final int id;
  final double notifyFontSize;
  final double textFontSize;
  final VoidCallback? onPressed;

  const NotificationComponent({
    required this.title,
    required this.message,
    required this.id,
    required this.onPressed, required this.notifyFontSize, required this.textFontSize,
  });

  @override
  State<NotificationComponent> createState() => _NotificationComponentState();
}

class _NotificationComponentState extends State<NotificationComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: HapisColors.lgColor3,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            color: HapisColors.lgColor4,
          ),
          onPressed: () async {
            int result =
                await NotificationsServices().deleteNotification(widget.id);
            print('result');

            if (result <= 0) {
              showDatabasePopup(context,
                  'Error confirming notifications \n\nPlease try again later.');
            }
            widget.onPressed!();
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              //fontSize: 20,
              fontSize: widget.notifyFontSize,
              color: HapisColors.lgColor1,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            widget.message,
            style: TextStyle(
              //fontSize: 18,
              fontSize: widget.textFontSize,
               color: Colors.black),
          ),
        ),
      ),
    );
  }
}
