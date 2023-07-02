import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../utils/extract_geocoordinates.dart';

/// Entity that represents the `Globe`, with all of its properties and methods.
class GlobeModel {
  /// Property that defines the Globe `uuid`.
  String id;

  /// Property that defines the Globe `image`.
  String? image;

  ///property that defines the globe `total number of seekers`
  int numberOfSeekers;

  ///property that defines the globe `total number of givers`
  int numberOfGivers;

  ///property that defines the globe `total number of donations in progress`
  int inProgressDonations;

  ///property that defines the globe `total number of successful donations`
  int successfulDonations;

  ///property that defines a list of the globe `3 most donated categories`
  List<String> topThreeCategories;

  ///property that defines a list of the globe `3 most donated categories`
  List<String> topThreeCities;

  GlobeModel({
    required this.id,
    this.image,
    required this.numberOfSeekers,
    required this.numberOfGivers,
    required this.inProgressDonations,
    required this.successfulDonations,
    required this.topThreeCategories,
    required this.topThreeCities,
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
      <b><font size="+2">Global Statistics <font color="#5D5D5D"></font></font></b>
      <br/><br/>
      <b>Total Number of Seekers:</b> $numberOfSeekers
      <br/>
      <b>Total Number of Givers:</b> $numberOfGivers
      <br/>
      <b>Total Donations In Progress:</b> $inProgressDonations
      <br/>
      <b>Total Successful Donations:</b> $successfulDonations
      <br/>
      <b>Top Three Donated Categories:</b> ${topThreeCategories.join(', ')}
      <br/>
       <b>Top Three Cities with most Donations:</b> ${topThreeCategories.join(', ')}
       <br/>
    ''';

  List<Map<String, double>> getGlobeOrbitCoordinates({
    double step = 3,
    double altitude = 38052591.07, // Specify the desired altitude for the orbit
  }) {
    // if (globeCoordinates == null) {
    //   return [];
    // }

    List<Map<String, double>> coords = [];
    double displacement = 0;
    double spot = 0;

    while (spot < 361) {
      displacement += step / 361;

      double angle = displacement * (pi / 180.0);
      double latitude = 40.085941;
      double longitude = 10.52668;
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

  /// Converts the current [GlobeModel] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'numberOfSeekers': numberOfSeekers,
      'numberOfGivers': numberOfGivers,
      'inProgressDonations': inProgressDonations,
      'successfulDonations': successfulDonations,
      'topThreeCategories': topThreeCategories,
      'topThreeCities': topThreeCities,
    };
  }

  /// Gets a [GlobeModel] from the given [map].
  factory GlobeModel.fromMap(Map map) {
    return GlobeModel(
        id: map['id'],
        image: map['image'],
        numberOfSeekers: map['numberOfSeekers'],
        numberOfGivers: map['numberOfGivers'],
        inProgressDonations: map['inProgressDonations'],
        successfulDonations: map['successfulDonations'],
        topThreeCategories: map['topThreeCategories'],
        topThreeCities: map['topThreeCities']);
  }
}
