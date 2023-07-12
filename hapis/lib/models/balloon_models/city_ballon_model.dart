import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../utils/extract_geocoordinates.dart';

/// Entity that represents the `City`, with all of its properties and methods.
class CityModel {
  /// Property that defines the city `uuid`.
  String id;

  /// Property that defines the city `main name`.
  String name;

  /// Property that defines the city `image`.
  String? image;

  /// Property that defines the city list of `seekers`
  List<String>? seekers;

  ///property that defines the city list of `givers`
  List<String>? givers;

  ///property that defines the city `total number of seekers`
  int numberOfSeekers;

  ///property that defines the city `total number of givers`
  int numberOfGivers;

  ///property that defines the city `total number of donations in progress`
  int inProgressDonations;

  ///property that defines the city `total number of successful donations`
  int successfulDonations;

  ///property that defines a list of the city `3 most donated categories`
  List<String> topThreeCategories;

  ///property that defines city `cityCoordinates`
  LatLng cityCoordinates;

  CityModel({
    required this.id,
    required this.name,
    this.image,
    this.seekers,
    this.givers,
    required this.numberOfSeekers,
    required this.numberOfGivers,
    required this.inProgressDonations,
    required this.successfulDonations,
    required this.topThreeCategories,
    required this.cityCoordinates,
  });

  ///property to get image asset as string for the image src
  Future<String> getImageAssetString(String imageAssetPath) async {
    final imageBytes = await rootBundle.load(imageAssetPath);
    final base64Image = base64Encode(imageBytes.buffer.asUint8List());
    final imageSrc = 'data:image/png;base64,$base64Image';
    return imageSrc;
  }

  /// Gets the balloon content from the current city.
  // ${image!.isNotEmpty ? '<img height="200" src="${getImageAssetString('assets/images/cityballoon.png')}" alt="City Image"><br/><br/>' : ''}
  String balloonContent() => '''
      <b><font size="+2">$name <font color="#5D5D5D"></font></font></b>
      <br/><br/>
      <div style="text-align:center;">
      <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week4/hapis/assets/images/cityballoon.png?raw=true" style="display: block; margin: auto; width: 200px; height: 200px;"/><br/><br/>
     </div>
      <b>Total Number of Seekers:</b> $numberOfSeekers
      <br/>
      <b>Total Number of Givers:</b> $numberOfGivers
      <br/>
      <b>Total In Progress Donations:</b> $inProgressDonations
      <br/>
      <b>Total Successful Donations:</b> $successfulDonations
      <br/>
      <b>Top Three Donated Categories:</b> ${topThreeCategories.join(', ')}
      <br/>
    ''';

  /// Gets the orbit coordinates for a city based on its name.
  ///
  /// Returns a [List] of coordinates with [lat], [lng], and [altitude].
  ///
  List<Map<String, double>> getCityOrbitCoordinates(
    String cityName, {
    double step = 3,
    double altitude = 10000, // Specify the desired altitude for the orbit
  }) {
    if (cityCoordinates == null) {
      return [];
    }

    List<Map<String, double>> coords = [];
    double displacement = 0;
    double spot = 0;

    while (spot < 361) {
      displacement += step / 361;

      double angle = displacement * (pi / 180.0);
      double latitude = cityCoordinates.latitude;
      double longitude = cityCoordinates.longitude;
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

  /// Converts the current [CityModel] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'seekers': seekers,
      'givers': givers,
      'numberOfSeekers': numberOfSeekers,
      'numberOfGivers': numberOfGivers,
      'inProgressDonations': inProgressDonations,
      'successfulDonations': successfulDonations,
      'topThreeCategories': topThreeCategories,
      'cityCoordinates': cityCoordinates,
    };
  }

  /// Gets a [CityModel] from the given [map].
  factory CityModel.fromMap(Map map) {
    return CityModel(
        id: map['id'],
        name: map['name'],
        image: map['image'],
        seekers: map['seekers'],
        givers: map['givers'],
        numberOfSeekers: map['numberOfSeekers'],
        numberOfGivers: map['numberOfGivers'],
        inProgressDonations: map['inProgressDonations'],
        successfulDonations: map['successfulDonations'],
        topThreeCategories: map['topThreeCategories'],
        cityCoordinates: map['cityCoordinates']);
  }
}
