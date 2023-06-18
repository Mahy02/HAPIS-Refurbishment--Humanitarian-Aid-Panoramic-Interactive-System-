import 'package:flutter/material.dart';

import '../constants.dart';

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
