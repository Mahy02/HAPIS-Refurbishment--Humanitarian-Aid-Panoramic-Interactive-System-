import 'package:flutter/material.dart';
import 'package:hapis/models/connection_model.dart';


///This is a [Provider] class of [Connectionprovider] that extends [ChangeNotifier]
///It has the following:
///  *  [_ipController] of type  [TextEditingController] to get the data of the host entered by the user
///  *  [_portController] of type  [TextEditingController] to get the data of the port entered by the user  (usually 22)
///  *  [_userNameController] of type  [TextEditingController] to get the username entered by the user (usally lg)
///  *  [_passwordController] of type  [TextEditingController] to get the password entered by the user (Master password)
///They all have setters and getters
///We have [saveData] method to save data into the form using [ConnectionModel]

class Connectionprovider extends ChangeNotifier {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = //int
      TextEditingController(text: '22');
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  set userName(String value) {
    _userNameController.text = value;
    notifyListeners();
  }

  set ip(String value) {
    _ipController.text = value;
    notifyListeners();
  }

  set password(String value) {
    _passwordController.text = value;
    notifyListeners();
  }

  set port(String value) {
    _portController.text = value;
    notifyListeners();
  }

  TextEditingController get userNameController => _userNameController;
  TextEditingController get hostController => _ipController;
  TextEditingController get passwordOrKeyController => _passwordController;
  TextEditingController get portController => _portController;

  final ConnectionModel _connectionFormData = ConnectionModel();
  ConnectionModel get connectionFormData => _connectionFormData;

  void saveData(
    TextEditingController userNameControl,
    TextEditingController ipControl,
    TextEditingController passwordControl,
    TextEditingController portControl,
  ) {
    _connectionFormData.ip = ipControl.text;
    _connectionFormData.password = passwordControl.text;
    _connectionFormData.username = userNameControl.text;
    _connectionFormData.port = int.parse(portControl.text);

    notifyListeners();
  }
}



//this class is for the user interaction** it gets saved so that we can add it to the ssh model