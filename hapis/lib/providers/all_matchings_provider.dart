import 'package:flutter/foundation.dart';


import '../models/db_models/get_matchings_model.dart';
import '../services/db_services/matchings_db_services.dart';

class MatchingsProvider with ChangeNotifier {
  List<MatchingsModel> _matchings = [];

  List<MatchingsModel> get matchings => _matchings;
  

  Future<void> loadMatchings() async {
    final queryResult = await MatchingsServices().getMatchings();
    _matchings = queryResult.map((matchingMap) => MatchingsModel(
      type: matchingMap['Type'],
      firstName: matchingMap['FirstName'],
      lastName: matchingMap['LastName'],
      city: matchingMap['City'],
      addressLocation: matchingMap['AddressLocation'],
      phoneNum: matchingMap['PhoneNum'],
      email: matchingMap['Email'],
      item: matchingMap['Item'],
      category: matchingMap['Category'],
      datesAvailable: matchingMap['Dates_available'],
    )).toList();
     notifyListeners();
  }
 
  
}
