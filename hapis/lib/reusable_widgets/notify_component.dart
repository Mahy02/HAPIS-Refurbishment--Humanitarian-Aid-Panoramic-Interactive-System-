import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';

class NotificationComponent extends StatelessWidget {
  final String title;
  final String message;

  const NotificationComponent({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: HapisColors.lgColor3,
        ),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 20,
              color: HapisColors.lgColor1,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
