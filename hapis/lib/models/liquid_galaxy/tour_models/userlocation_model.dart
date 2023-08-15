import 'package:hapis/models/liquid_galaxy/tour_models/city_model.dart';

class UserLocationModel {
  String userName;
  double longitude;
  double latitude;

  /// Property that defines the user firstName
  String firstName;

  /// Property that defines the user lastName
  String lastName;

  /// Property that defines the user phone number
  String phoneNum;

  /// Property that defines the user's email
  String email;

  String address;

  UserLocationModel(this.userName, this.address, this.longitude, this.latitude,
      this.firstName, this.lastName, this.phoneNum, this.email);
}
