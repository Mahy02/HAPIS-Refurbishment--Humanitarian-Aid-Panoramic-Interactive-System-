


/// Represents a user's location model, including user information and geographical coordinates.
class UserLocationModel {
  /// The username associated with the user's location.
  String userName;

   /// The longitude coordinate of the user's location.
  double longitude;

  /// The latitude coordinate of the user's location.
  double latitude;

  /// Property that defines the user firstName
  String firstName;

  /// Property that defines the user lastName
  String lastName;

  /// Property that defines the user phone number
  String phoneNum;

  /// Property that defines the user's email
  String email;

  /// The address of the user's location
  String address;



  /// Constructs a `UserLocationModel` instance with the provided properties.
  ///
  /// The `userName` parameter is the username associated with the user's location.
  ///
  /// The `address` parameter is the address of the user's location.
  ///
  /// The `longitude` parameter is the longitude coordinate of the user's location.
  ///
  /// The `latitude` parameter is the latitude coordinate of the user's location.
  ///
  /// The `firstName` parameter is the first name of the user.
  ///
  /// The `lastName` parameter is the last name of the user.
  ///
  /// The `phoneNum` parameter is the phone number of the user.
  ///
  /// The `email` parameter is the email address of the user.
  UserLocationModel(this.userName, this.address, this.longitude, this.latitude,
      this.firstName, this.lastName, this.phoneNum, this.email);
}


