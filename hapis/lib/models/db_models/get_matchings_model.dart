/// Model that represents the `MatchingsModel`, with all of its properties and methods.
class MatchingsModel {
  /// Property that defines the user type
  final String type;

  /// Property that defines the user firstName
  final String firstName;

  /// Property that defines the user lastName
  final String lastName;

  /// Property that defines the user city
  final String city;

  /// Property that defines the user addressLocation
  final String addressLocation;

  /// Property that defines the user phoneNum
  final String phoneNum;

  /// Property that defines the user email
  final String email;

  /// Property that defines the user item
  final String item;

  /// Property that defines the user category
  final String category;

  /// Property that defines the user datesAvailable
  final String datesAvailable;

  MatchingsModel({
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.addressLocation,
    required this.phoneNum,
    required this.email,
    required this.item,
    required this.category,
    required this.datesAvailable,
  });
}
