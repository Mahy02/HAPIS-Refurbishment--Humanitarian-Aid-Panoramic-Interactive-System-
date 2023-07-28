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
  String _type = typeList[0];
  String _forWho = forWhoList[0];
  String _category = categoryList[0];
  
  String? _status;
  String? _multiDates;

  final TextEditingController _formItemController = TextEditingController();


  set formID(int? value) {
    _formID = value;
    notifyListeners();
  }

  set userID(int? value) {
    _userID = value;
    notifyListeners();
  }

  set multiDates(String? value) {
    _multiDates = value;
    notifyListeners();
  }

  set status(String? value) {
    _status = value;
    notifyListeners();
  }

  set forWho(String value) {
    _forWho = value;
    notifyListeners();
  }

  set category(String value) {
    _category = value;
    notifyListeners();
  }

  set item(String value) {
    _formItemController.text = value;
    notifyListeners();
  }

  set type(String value) {
    _type = value;
    notifyListeners();
  }

  TextEditingController get formItemController => _formItemController;
  int? get formID => _formID;
  int? get userID => _userID;
  String get type => _type;
  String get category => _category;
  String get forWho => _forWho;
  String? get status => _status;
  String? get multiDates => _multiDates;

  final FormsModel _form = FormsModel();
  FormsModel get form => _form;

  void saveData(
    int formID,
    int userID,
    String type,
    TextEditingController item,
    String category,
    String multiDates,
    String forWho,
    String status,
  ) {
    _form.formID = formID;
    _form.userID = userID;
    _form.type = type;
    _form.item = item.text;
    _form.category = category;
    _form.multiDates = multiDates;
    _form.forWho = forWho;
    _form.status = status;

    notifyListeners();
  }
}
