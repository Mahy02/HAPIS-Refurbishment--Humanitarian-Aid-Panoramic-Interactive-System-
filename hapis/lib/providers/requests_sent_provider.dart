import 'package:flutter/foundation.dart';

import '../models/db_models/get_requests_sent_model.dart';
import '../services/db_services/requests_db_services.dart';

class RequestsSentProvider with ChangeNotifier {
  List<RequestSentModel> _requestsSent = [];

  List<RequestSentModel> get requestsSent => _requestsSent;

  Future<void> loadRequestsSent() async {
    final queryResult = await RequestsServices().getRequestsSent();
    _requestsSent = queryResult.map((result) => RequestSentModel(
      firstName: result['FirstName'],
      lastName: result['LastName'],
      recipientStatus: result['Rec_Status'],
    )).toList();
    notifyListeners();
  }
}