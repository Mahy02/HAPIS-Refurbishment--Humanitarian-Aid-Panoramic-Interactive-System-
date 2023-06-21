
/// Model that represents the `FormsModel`, with all of its properties and methods.

class FormsModel {
  /// Property that defines the form formID
  int? formID;

  /// Property that defines the user userID which is referenced from the users table
  int? userID;

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

  /// Property that defines the form's status
  String? status;


  FormsModel(
      {this.formID,
        this.userID,
        this.type,
        this.item,
        this.category,
        this.multiDates,
        this.forWho,
        this.status
     });

  /// Turns a `Map` into a `FormsModel`.  "Map From the database"
  factory FormsModel.fromMap(Map<String, dynamic> map) {
    return FormsModel(
      formID: map['FormID'],
      userID: map['UserID'],
      type: map['Type'],
      item: map['Item'],
      category: map['Category'],
      multiDates: map['Dates_available'],
      forWho: map['For'],
      status: map['Status']
    );
  }

}
