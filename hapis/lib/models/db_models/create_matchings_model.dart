/// Model that represents the `MatchingsModel`, with all of its properties and methods.

class CreateMatchingsModel {
  /// Property that defines the matching mID 
  int? mID;

  /// Property that defines the user (seeker) Form ID which is referenced from the Forms table
  int? seekerFormID;

  /// Property that defines the user (giver) Form ID which is referenced from the Forms table
  int? giverFormID;

  /// Property that defines the recStatus for reciever 1
  String? rec1Status;

  /// Property that defines the recStatus for reciever 2
  String? rec2Status;

  /// Property that defines the donation status 
  String? rec1DonStatus;

  /// Property that defines the donation status 
  String? rec2DonStatus;
 

  CreateMatchingsModel(
      {this.mID,
        this.seekerFormID,
        this.giverFormID,
        this.rec1Status,
        this.rec2Status,
        this.rec1DonStatus,
        this.rec2DonStatus
     });

  /// Turns a `Map` into a `MatchingsModel`.  "Map From the database"
  factory CreateMatchingsModel.fromMap(Map<String, dynamic> map) {
    return CreateMatchingsModel(
      mID: map['M_ID'],
      seekerFormID: map['Seeker_FormID'],
      giverFormID: map['Giver_FormID'],
      rec1Status: map['Rec1_Status'],
      rec2Status: map['Rec2_status'],
      rec1DonStatus: map['Rec1_Donation_Status'],
       rec2DonStatus: map['Rec2_Donation_Status'],
    );
  }

}
