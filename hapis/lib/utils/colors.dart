import 'package:flutter/material.dart';

import '../constants.dart';

///This is where we define some functionalities related to the colors of the text 
///[getColorForLetter] is used to to display the text with different colors according to a letter
///[getColorForWord] is used to display the text with different colors according to the word
///[hexStringToColor] to convert a hex color to `Color`

Color getColorForLetter(String letter) {
  switch (letter) {
    case 'H':
      return HapisColors.lgColor1;
    case 'A':
      return HapisColors.lgColor2;
    case 'P':
      return HapisColors.lgColor3;
    case 'I':
      return HapisColors.lgColor1;
    case 'S':
      return HapisColors.lgColor4;
    default:
      return HapisColors.lgColor1;
  }
}

Color getColorForWord(String word) {
  // Assign different colors based on word or any other criteria
  if (word.startsWith('Humanitarian')) {
    return HapisColors.lgColor1;
  } else if (word.startsWith('Aid')) {
    return HapisColors.lgColor2;
  } else if (word.startsWith('Panoramic')) {
    return HapisColors.lgColor3;
  } else if (word.startsWith('Interactive')) {
    return HapisColors.lgColor1;
  } else if (word.startsWith('System')) {
    return HapisColors.lgColor4;
  } else {
    return Colors.black;
  }
}

/// a function `hexStringToColor` that takes a hex color and change it to `Color` 
hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}