/// Model that represents the `UsersModel`, with all of its properties and methods.

class UsersModel {
  /// Property that defines the user userID
  int? userID;

  /// Property that defines the user userName
  String? userName;

  /// Property that defines the user firstName
  String? firstName;

  /// Property that defines the user lastName
  String? lastName;

  ///property that defines the country the user lives in
  String? country;

  /// Property that defines the city the user lives in
  String? city;

  /// Property that defines the user's address location
  String? addressLocation;

  /// Property that defines the user phone number
  String? phoneNum;

  /// Property that defines the user's email
  String? email;

  /// Property that defines the user's password
  String? pass;

  UsersModel(
      {this.userID,
      this.userName,
      this.firstName,
      this.lastName,
      this.country,
      this.city,
      this.addressLocation,
      this.phoneNum,
      this.email,
      this.pass});

  /// Turns a `Map` into a `UsersModel`.  "Map From the database"
  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
        userID: map['UserID'],
        userName: map['UserName'],
        firstName: map['FirstName'],
        lastName: map['LastName'],
        country: map['Country'],
        city: map['City'],
        addressLocation: map['AddressLocation'],
        phoneNum: map['PhoneNum'],
        email: map['Email'],
        pass: map['Password']);
  }
}
