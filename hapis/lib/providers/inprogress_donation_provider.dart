import 'package:flutter/foundation.dart';

import '../models/db_models/get_inprogress_donations_model.dart';
import '../services/db_services/donations_db_services.dart';

class InProgressDonationsProvider with ChangeNotifier {
  List<InProgressDonationModel> _inProgressDonations = [];

  List<InProgressDonationModel> get inProgressDonations => _inProgressDonations;

  Future<void> fetchInProgressDonations() async {
    final queryResult = await DonationsServices().getDonationsInProgress();
    _inProgressDonations = queryResult
        .map((result) => InProgressDonationModel(
            firstName: result['FirstName'], lastName: result['LastName']))
        .toList();

    notifyListeners();
  }
}
