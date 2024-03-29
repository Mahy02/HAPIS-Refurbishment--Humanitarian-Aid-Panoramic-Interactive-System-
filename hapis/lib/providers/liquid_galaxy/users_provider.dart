import 'package:flutter/material.dart';
import 'package:hapis/models/liquid_galaxy/balloon_models/users_model.dart';
import 'package:provider/provider.dart';
import '../../utils/extract_geocoordinates.dart';

///This is a [Provider] class of [UserProvider] that extends [ChangeNotifier]

///They all have setters and getters
///We have [saveData] method to save data into the form using [UsersModel]
///We have [saveSeekers] and [saveGivers] method to save all seekers and givers in the corresponding list
///We have [clearData] to empty the seekers and givers list before going to another city

class UserProvider extends ChangeNotifier {
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


  /// property that defines the user's total number of donations
  int? _givings;

  ///property that defines user's total number of seeking for self
  int? _seekingsForSelf;

  ///property that defines user's total number of seeking for others
  int? _seekingForOthers;

  ///property that defines user `Coordinates`
  LatLng? _userCoordinates;

  ///property that defines list of seekers
  List<UsersModel> _seekers = [];

  ///property that defines list of givers
  List<UsersModel> _givers = [];

  set userCoordinates(LatLng value) {
    _userCoordinates = value;
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

  set givings(int? value) {
    _givings = value;
    notifyListeners();
  }

  set seekingsForSelf(int? value) {
    _seekingsForSelf = value;
    notifyListeners();
  }

  set seekingsForOthers(int? value) {
    _seekingForOthers = value;
    notifyListeners();
  }

  void setSeekers(List<UsersModel> value) {
    _seekers = value;
    notifyListeners();
  }

  void setGivers(List<UsersModel> value) {
    _givers = value;
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
  int? get givings => _givings;
  int? get seekingsForSelf => _seekingsForSelf;
  int? get seekingsForOthers => _seekingForOthers;
  List<UsersModel> get seekers => _seekers;
  List<UsersModel> get givers => _givers;
  LatLng get userCoordinates => _userCoordinates!;

  final UsersModel _user = UsersModel();
  UsersModel get user => _user;

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
      String pass,
      int givings,
      int seekingsForSelf,
      int seekingsForOthers,
      LatLng userCoordinates) {
    _user.userID = userID;
    _user.userName = userName;
    _user.firstName = firstName;
    _user.lastName = lastName;
    _user.city = city;
    _user.country = country;
    _user.addressLocation = addressLocation;
    _user.phoneNum = phoneNum;
    _user.email = email;
   
    _user.seekingsForSelf = seekingsForSelf;
    _user.seekingForOthers = _seekingForOthers;
    _user.givings = _givings;
    _user.userCoordinates = _userCoordinates;
    notifyListeners();
  }

  void saveSeekers(UsersModel user) {
    _seekers.add(user);
    notifyListeners();
  }

  void saveGivers(UsersModel user) {
    _givers.add(user);
    notifyListeners();
  }

  void clearData() {
    _seekers = [];
    _givers = [];
    notifyListeners();
  }
}
