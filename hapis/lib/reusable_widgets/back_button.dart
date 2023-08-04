import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: HapisColors.lgColor3,
          weight: 200.0,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
