/// Model that represents the `RequestReceivedModel`, with all of its properties and methods.
class RequestReceivedModel {
  /// Property that defines the user firstName
  final String firstName;

  /// Property that defines the user lastName
  final String lastName;

  /// Property that defines the user item
  final String item;

  /// Property that defines the user type
  final String type;

  RequestReceivedModel({
    required this.firstName,
    required this.lastName,
    required this.item,
    required this.type,
  });
}
