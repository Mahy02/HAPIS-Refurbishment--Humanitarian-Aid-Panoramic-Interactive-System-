import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';

class BackButtonWidget extends StatefulWidget {
  final bool isTablet;
  const BackButtonWidget({super.key, required this.isTablet});

  @override
  State<BackButtonWidget> createState() => _BackButtonWidgetState();
}

class _BackButtonWidgetState extends State<BackButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: HapisColors.lgColor3,
          size: widget.isTablet? 45: 20 ,
          weight: 200.0,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
