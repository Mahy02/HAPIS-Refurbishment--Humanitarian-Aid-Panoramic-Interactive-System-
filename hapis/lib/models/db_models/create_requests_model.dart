/// Model that represents the `RequestsModel`, with all of its properties and methods.

class RequestsModel {
  /// Property that defines the request rID 
  int? rID;

  /// Property that defines the user senderID which is referenced from the users table
  int? senderID;

    /// Property that defines the user receieverID which is referenced from the users table
  int? recID;

  /// Property that defines the reciever form ID to retrieve from data later
  int? recFormID;

  /// Property that defines the recStatus
  String? recStatus;

  /// Property that defines the donation status of sender
  String? senderDonStatus;

  /// Property that defines the donation status of the receiver 
  String? recDonStatus;

  RequestsModel(
      {this.rID,
        this.senderID,
        this.recID,
        this.recFormID,
        this.recStatus,
        this.senderDonStatus,
        this.recDonStatus
     });

  /// Turns a `Map` into a `RequestsModel`.  "Map From the database"
  factory RequestsModel.fromMap(Map<String, dynamic> map) {
    return RequestsModel(
      rID: map['R_ID'],
      senderID: map['Sender_ID'],
      recID: map['Rec_ID'],
      recFormID: map['Rec_FormID'],
      recStatus: map['Rec_Status'],
      senderDonStatus: map['Rec1_Donation_Status'],
      recDonStatus: map['Rec2_Donation_Status']
    );
  }

}
