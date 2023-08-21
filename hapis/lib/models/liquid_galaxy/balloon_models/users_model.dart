import 'dart:math';

import '../../../constants.dart';
import '../../../utils/extract_geocoordinates.dart';

/// Model that represents the `UsersModel`, with all of its properties and methods.

class UsersModel {
  /// Property that defines the user userID
  String? userID;

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

  ///property that defines the user's image
  String? imagePath;

  /// property that defines the user's total number of donations
  int? givings;

  ///property that defines user's total number of seeking for self
  int? seekingsForSelf;

  ///property that defines user's total number of seeking for others
  int? seekingForOthers;

  ///property that defines user `Coordinates`
  LatLng? userCoordinates;

  UsersModel(
      {
      this.userID,
      this.userName,
      this.firstName,
      this.lastName,
      this.country,
      this.city,
      this.addressLocation,
      this.phoneNum,
      this.email,
      this.imagePath,
      this.givings,
      this.seekingForOthers,
      this.seekingsForSelf,
      this.userCoordinates});

  /// Gets the balloon content from the current giver.
  String giverBalloonContent() {
    if (imagePath == null || imagePath == '') {
      return '''
      <div style="text-align:center;">
      <b><font size="+3">Personal Information & statistics<font color="#5D5D5D"></font></font></b>
      </div>
      <br/><br/>
      <div style="text-align:center;">
      <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week4/hapis/assets/images/defaultuserballoon.png?raw=true" style="display: block; margin: auto; width: 150px; height: 150px;"/><br/><br/>
      </div>
      <b>Name:</b> ${'$firstName $lastName'}
      <br/>
      <b>Phone Number:</b> $phoneNum
      <br/>
      <b>Email:</b> $email
      <br/>
      <b>Total Number of donations made:</b> $givings
      <br/>
    ''';
    } else {
      return '''
      <div style="text-align:center;">
      <b><font size="+3">Personal Information & statistics<font color="#5D5D5D"></font></font></b>
      </div>
      <br/><br/>
      <div style="text-align:center;">
      
      <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week8/hapis/$imagePath?raw=true" style="width: 150px; height: 150px;"/><br/><br/>
      </div>
      <b>Name:</b> ${'$firstName $lastName'}
      <br/>
      <b>Phone Number:</b> $phoneNum
      <br/>
      <b>Email:</b> $email
      <br/>
      <b>Total Number of donations made:</b> $givings
      <br/>
    ''';
    }
  }

  /// Gets the balloon content from the current seeker.
  String seekerBalloonContent() {
    if (imagePath == null || imagePath == '') {
      return '''
      <b><font size="+2">Personal Information & statistics<font color="#5D5D5D"></font></font></b>
      <br/><br/>
      <div style="text-align:center;">
      <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week4/hapis/assets/images/defaultuserballoon.png?raw=true" style="display: block; margin: auto; width: 200px; height: 200px;"/><br/><br/>
      </div>
      <b>Name:</b> ${'$firstName $lastName'}
      <br/>
      <b>Phone Number:</b> $phoneNum
      <br/>
      <b>Email:</b> $email
      <br/>
      <b>Total Number seekings made for self:</b> $seekingsForSelf
      <br/>
      <b>Total Number seekings made for others:</b> $seekingForOthers
      <br/>
    ''';
    } else {
      return '''
      <b><font size="+2">Personal Information & statistics<font color="#5D5D5D"></font></font></b>
      <br/><br/>
      <div style="text-align:center;">
     <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week8/hapis/$imagePath?raw=true" style="width: 150px; height: 150px;"/><br/><br/>
      </div>
      <b>Name:</b> ${'$firstName $lastName'}
      <br/>
      <b>Phone Number:</b> $phoneNum
      <br/>
      <b>Email:</b> $email
      <br/>
      <b>Total Number seekings made for self:</b> $seekingsForSelf
      <br/>
      <b>Total Number seekings made for others:</b> $seekingForOthers
      <br/>
    ''';
    }
  }

  /// Gets the balloon content from the current seeker.
  String tourUserBalloonContent() => '''
      <b><font size="+2">Personal Information & statistics<font color="#5D5D5D"></font></font></b>
      <br/><br/>
      <div style="text-align:center;">
      <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week4/hapis/assets/images/defaultuserballoon.png?raw=true" style="display: block; margin: auto; width: 200px; height: 200px;"/><br/><br/>
      </div>
      <b>Name:</b> ${'$firstName $lastName'}
      <br/>
      <b>Phone Number:</b> $phoneNum
      <br/>
      <b>Email:</b> $email
      <br/>
    ''';

  List<Map<String, double>> getUserOrbitCoordinates(
    String address, {
    double step = 3,
    double altitude = 10000, // Specify the desired altitude for the orbit
  }) {
    List<Map<String, double>> coords = [];
    double displacement = 0;
    double spot = 0;

    while (spot < 361) {
      displacement += step / 361;

      double angle = displacement * (pi / 180.0);
      double latitude = userCoordinates!.latitude;
      double longitude = userCoordinates!.longitude;
      double distance = altitude;

      // Calculate the new coordinates based on the orbit parameters
      double newLatitude = latitude + distance * cos(angle) / earthRadius;
      double newLongitude = longitude +
          distance * sin(angle) / (earthRadius * cos(latitude * (pi / 180.0)));

      coords.add({
        'lat': newLatitude,
        'lng': newLongitude,
        'alt': altitude,
      });

      spot++;
    }

    return coords;
  }

  /// Turns a `Map` into a `UsersModel`.  "Map From the database"
  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      userID: map['UserID'],
      userName: map['UserName'],
      firstName: map['FirstName'],
      lastName: map['LastName'],
      country: map['Country'],
      city: map['City'],
      addressLocation: map['AddressLocation'],
      phoneNum: map['PhoneNum'],
      email: map['Email'],
    );
  }
}
