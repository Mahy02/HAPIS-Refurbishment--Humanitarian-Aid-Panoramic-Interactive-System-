import 'package:flutter/material.dart';

///Here we save any constants we might need for HAPIS tablet app
///
/// * We have a class [HapisColors] for savinng the default colors for our app
/// * [earthRadius] property for defining earth radius for orbit functionality 
class HapisColors {
  static const Color primary = Color(0xFF90CCF5);
  static const Color accent = Color.fromARGB(255, 255, 255, 255);
  static const Color background = Color(0xFFF0F0F0);
  static const Color secondary = Color.fromARGB(255, 62, 141, 76);
  static const Color lgColor1 = Color(0xFF537DC0);
  static const Color lgColor2 = Color(0xFFE54E3E);
  static const Color lgColor3 = Color(0xFFF6B915);
  static const Color lgColor4 = Color(0xFF4CB15F);
}

const double earthRadius = 6371000; // Average radius of the Earth in meters
