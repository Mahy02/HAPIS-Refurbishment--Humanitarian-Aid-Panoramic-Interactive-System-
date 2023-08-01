/// Model that represents the `MatchingsModel`, with all of its properties and methods.
class MatchingsModel {
  ///property that defines the matching id
  final int matchingID;

  ///property that defines form id of other user
  final int formID;

  ///property that defines the other user ID
  final String userID;

  /// Property that defines the current user type
  final String type;

  /// Property that defines the other user firstName
  final String firstName;

  /// Property that defines the other user lastName
  final String lastName;

  /// Property that defines the other user city
  final String city;

  /// Property that defines the other user addressLocation
  final String addressLocation;

  /// Property that defines the other user phoneNum
  final String phoneNum;

  /// Property that defines the other user email
  final String email;

  /// Property that defines the other user item
  final String item;

  /// Property that defines the other user category
  final String category;

  /// Property that defines the other user datesAvailable
  final String datesAvailable;

  ///property that defines rec1 status (seeker)
  final String seekerStatus;

  ///property that defines rec2 status (giver)
  final String giverStatus;

  MatchingsModel({
    required this.matchingID,
    required this.formID,
    required this.userID,
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
    required this.seekerStatus,
    required this.giverStatus
  });
}
