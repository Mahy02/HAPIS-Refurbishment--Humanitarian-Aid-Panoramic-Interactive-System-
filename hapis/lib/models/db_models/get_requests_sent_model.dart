/// Model that represents the `RequestSentModel`, with all of its properties and methods.
class RequestSentModel {
  /// property that defines the user's `firstName`
  final String firstName;

  /// property that defines the user's `lastName`
  final String lastName;

  /// property that defines the user's `recipientStatus`
  final String recipientStatus;

  RequestSentModel({
    required this.firstName,
    required this.lastName,
    required this.recipientStatus,
  });
}
