import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/responsive/responsive_layout.dart';

class ConnectionIndicator extends StatelessWidget {
  final bool isConnected;

  ConnectionIndicator({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: isConnected
                        ? Color.fromARGB(255, 124, 124, 124)
                        : HapisColors.lgColor2,
                    radius: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: isConnected
                        ? HapisColors.lgColor4
                        : Color.fromARGB(255, 124, 124, 124),
                    radius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        tabletBody: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: isConnected
                        ? Color.fromARGB(255, 124, 124, 124)
                        : HapisColors.lgColor2,
                    radius: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: isConnected
                        ? HapisColors.lgColor4
                        : Color.fromARGB(255, 124, 124, 124),
                    radius: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
