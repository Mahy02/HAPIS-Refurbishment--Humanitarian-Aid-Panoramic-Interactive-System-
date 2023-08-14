/// Model that represents the `UserModel`, with all of its properties and methods.

class UserModel {
  /// Property that defines the user userID
  String? userID;

  ///property that defines the user formid
  int? formID;

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

  /// Property that defines the form type
  String? type;

  /// Property that defines the form item
  String? item;

  /// Property that defines the form category
  String? category;

  /// Property that defines the dates available (multi-values)
  String? multiDates;

  /// Property that defines for who -only if seeker  so it could be null or empty
  String? forWho;

  ///property that defines password
  // String? pass;

  UserModel(
      {this.userID,
      this.formID,
      this.userName,
      this.firstName,
      this.lastName,
      this.country,
      this.city,
      this.addressLocation,
      this.phoneNum,
      this.email,
      this.type,
      this.item,
      this.category,
      this.multiDates,
      this.forWho, 
      //this.pass
      });

  /// Turns a `Map` into a `UsersModel`.  "Map From the database"
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['UserID'],
      userName: map['UserName'],
      firstName: map['FirstName'],
      lastName: map['LastName'],
      country: map['Country'],
      city: map['City'],
      addressLocation: map['AddressLocation'],
      phoneNum: map['PhoneNum'],
      email: map['Email'],
      type: map['FormType'],
      item: map['Item'],
      category: map['Category'],
      multiDates: map['Dates_available'],
      forWho: map['ForWho'],
      //pass: map['Password']
    );
  }
}
