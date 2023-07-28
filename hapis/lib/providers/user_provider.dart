import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/db_models/user_model.dart';


///This is a [Provider] class of [UserAppProvider] that extends [ChangeNotifier]

///They all have setters and getters
///We have [saveData] method to save data into the form using [UserModel]
///We have [saveSeekersApp] and [saveGiversApp] method to save all seekers and givers in the corresponding list
///We have [clearDataApp] to empty the seekers and givers list before going to another city

class UserAppProvider extends ChangeNotifier {
  /// Property that defines the user userID
  String? _userID;

  /// Property that defines the user userName
  String? _userName;

  /// Property that defines the user firstName
  String? _firstName;

  /// Property that defines the user lastName
  String? _lastName;

  ///property that defines the country the user lives in
  String? _country;

  /// Property that defines the city the user lives in
  String? _city;

  /// Property that defines the user's address location
  String? _addressLocation;

  /// Property that defines the user phone number
  String? _phoneNum;

  /// Property that defines the user's email
  String? _email;

  /// Property that defines the form type
  String? _type;

  /// Property that defines the form item
  String? _item;

  /// Property that defines the form category
  String? _category;

  /// Property that defines the dates available (multi-values)
  String? _multiDates;

  /// Property that defines for who -only if seeker  so it could be null or empty
  String? _forWho;

  ///property that defines list of seekers
  List<UserModel> _seekersApp = [];

  ///property that defines list of givers
  List<UserModel> _giversApp = [];

  set forWho(String? value) {
    _forWho = value;
    notifyListeners();
  }

  set multiDates(String? value) {
    _multiDates = value;
    notifyListeners();
  }

  set category(String? value) {
    _category = value;
    notifyListeners();
  }

  set item(String? value) {
    _item = value;
    notifyListeners();
  }

  set type(String? value) {
    _type = value;
    notifyListeners();
  }

  void setSeekerApp(List<UserModel> value) {
    _seekersApp = value;
    notifyListeners();
  }

  void setGiverApp(List<UserModel> value) {
    _giversApp = value;
    notifyListeners();
  }

  set email(String? value) {
    _email = value;
    notifyListeners();
  }

  set phoneNum(String? value) {
    _phoneNum = value;
    notifyListeners();
  }

  set addressLocation(String? value) {
    _addressLocation = value;
    notifyListeners();
  }

  set city(String? value) {
    _city = value;
    notifyListeners();
  }

  set country(String? value) {
    _country = value;
    notifyListeners();
  }

  set lastName(String? value) {
    _lastName = value;
    notifyListeners();
  }

  set firstName(String? value) {
    _firstName = value;
    notifyListeners();
  }

  set userName(String? value) {
    _userName = value;
    notifyListeners();
  }

  set userID(String? value) {
    _userID = value;
    notifyListeners();
  }

  String? get email => _email;
  String? get phoneNum => _phoneNum;
  String? get addressLocation => _addressLocation;
  String? get city => _city;
  String? get country => _country;
  String? get lastName => _lastName;
  String? get firstName => _firstName;
  String? get userName => _userName;
  String? get userID => _userID;
  String? get type => _type;
  String? get item => _item;
  String? get category => _category;
  String? get multiDates => _multiDates;
  String? get forWho => _forWho;
  List<UserModel> get seekersApp => _seekersApp;
  List<UserModel> get giversApp => _giversApp;

  final UserModel _user = UserModel();
  UserModel get user => _user;

  void saveData(
    String userID,
    String userName,
    String firstName,
    String lastName,
    String country,
    String city,
    String addressLocation,
    String phoneNum,
    String email,
    String type,
    String item,
    String category,
    String multiDates,
    String forWho,
  ) {
    _user.userID = userID;
    _user.userName = userName;
    _user.firstName = firstName;
    _user.lastName = lastName;
    _user.city = city;
    _user.country = country;
    _user.addressLocation = addressLocation;
    _user.phoneNum = phoneNum;
    _user.email = email;
    _user.type = type;
    _user.item = item;
    _user.category = category;
    _user.multiDates = multiDates;
    _user.forWho = forWho;

    notifyListeners();
  }

  void saveSeekersApp(UserModel user) {
    _seekersApp.add(user);
    notifyListeners();
  }

  void saveGiversApp(UserModel user) {
    _giversApp.add(user);
    notifyListeners();
  }

  void clearDataApp() {
    _seekersApp = [];
    _giversApp = [];
    notifyListeners();
  }
}
