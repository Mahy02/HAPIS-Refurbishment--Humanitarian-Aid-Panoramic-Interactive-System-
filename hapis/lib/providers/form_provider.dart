import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/forms_model.dart';
import 'package:provider/provider.dart';
import 'package:hapis/constants.dart';

///This is a [Provider] class of [FormProvider] that extends [ChangeNotifier]

///They all have setters and getters
///We have [saveData] method to save data into the form using [FormsModel]

class FormProvider extends ChangeNotifier {
  int? _formID;
  int? _userID;
  String _typeS = typeList[0];
  String _forWhoS = forWhoList[0];
  String _categoryS = categoryList[0];
  
  String? _statusS;
  String? _multiDatesS;

  final TextEditingController _formItemControllerS = TextEditingController();

  String _typeD = typeList[0];
  String _forWhoD = forWhoList[0];
  String _categoryD = categoryList[0];
  
  String? _statusD;
  String? _multiDatesD;

  final TextEditingController _formItemControllerD = TextEditingController();


  set formID(int? value) {
    _formID = value;
    notifyListeners();
  }

  set userID(int? value) {
    _userID = value;
    notifyListeners();
  }

  set multiDatesS(String? value) {
    _multiDatesS = value;
    notifyListeners();
  }

  set statusS(String? value) {
    _statusS = value;
    notifyListeners();
  }

  set forWhoS(String value) {
    _forWhoS = value;
    notifyListeners();
  }

  set categoryS(String value) {
    _categoryS = value;
    notifyListeners();
  }

  set itemS(String value) {
    _formItemControllerS.text = value;
    notifyListeners();
  }

  set typeS(String value) {
    _typeS = value;
    notifyListeners();
  }

  set multiDatesD(String? value) {
    _multiDatesD = value;
    notifyListeners();
  }

  set statusD(String? value) {
    _statusD = value;
    notifyListeners();
  }

  set forWhoD(String value) {
    _forWhoD = value;
    notifyListeners();
  }

  set categoryD(String value) {
    _categoryD = value;
    notifyListeners();
  }

  set itemD(String value) {
    _formItemControllerD.text = value;
    notifyListeners();
  }

  set typeD(String value) {
    _typeD = value;
    notifyListeners();
  }


  TextEditingController get formItemControllerS => _formItemControllerS;
  int? get formID => _formID;
  int? get userID => _userID;
  String get typeS => _typeS;
  String get categoryS => _categoryS;
  String get forWhoS => _forWhoS;
  String? get statusS => _statusS;
  String? get multiDatesS => _multiDatesS;

  TextEditingController get formItemControllerD => _formItemControllerD;
  String get typeD => _typeD;
  String get categoryD => _categoryD;
  String get forWhoD => _forWhoD;
  String? get statusD => _statusD;
  String? get multiDatesD => _multiDatesD;

  // final FormsModel _form = FormsModel();
  // FormsModel get form => _form;

  // void saveData(
  //   int formID,
  //   int userID,
  //   String type,
  //   TextEditingController item,
  //   String category,
  //   String multiDates,
  //   String forWho,
  //   String status,
  // ) {
  //   _form.formID = formID;
  //   _form.userID = userID;
  //   _form.type = type;
  //   _form.item = item.text;
  //   _form.category = category;
  //   _form.multiDates = multiDates;
  //   _form.forWho = forWho;
  //   _form.status = status;

  //   notifyListeners();
  // }
}
