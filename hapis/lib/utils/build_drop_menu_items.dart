import 'package:flutter/material.dart';

DropdownMenuItem<String> buildMenuItem(String item, double fontSize) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style:  TextStyle(fontSize: fontSize),
    ));

