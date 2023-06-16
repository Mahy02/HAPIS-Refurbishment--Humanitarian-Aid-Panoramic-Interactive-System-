import 'package:flutter/material.dart';

///This is a provider class for the Icon State of the side menu
/// [_isSelectedMap] is a private object of type [Map] that holds whether icon is selected or not for each item list
/// We have [_selectedItemNumber] which is initially '0' and then is used to check whether the selected item is the same or not
/// It activates only one item at a time by the  [setIconState] and returns whether its seleted or not by [getIconState]
/// It will notify all listerners that data has changed using  [notifyListeners]
class IconState extends ChangeNotifier {
  final Map<String, bool> _isSelectedMap = {};

  String _selectedItemNumber = '0';

  void setIconState(String itemNumber) {
    if (_selectedItemNumber == itemNumber) return;

    _isSelectedMap[_selectedItemNumber] = false;
    _selectedItemNumber = itemNumber;
    _isSelectedMap[_selectedItemNumber] = true;

    notifyListeners();
  }

  bool getIconState(String itemNumber) {
    return _isSelectedMap[itemNumber] ?? false;
  }
}
