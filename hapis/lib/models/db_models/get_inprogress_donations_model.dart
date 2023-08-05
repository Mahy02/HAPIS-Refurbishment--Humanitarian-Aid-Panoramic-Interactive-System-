/// Model that represents the `InProgressDonationModel`, with all of its properties and methods.
class InProgressDonationModel {
  ///property that defines the matching `id` if exists
  final int mID;

  ///property that defines the requests `id` if exists
  final int rID;

  /// property that defines the user `firstName`
  final String firstName;

  ///property that defines the user `lastName`
  final String lastName;

  ///property that defines the type => sender rec seeker giver
  final String type;

  InProgressDonationModel({
    required this.mID,
    required this.rID,
    required this.firstName,
    required this.lastName,
    required this.type
  });
}
