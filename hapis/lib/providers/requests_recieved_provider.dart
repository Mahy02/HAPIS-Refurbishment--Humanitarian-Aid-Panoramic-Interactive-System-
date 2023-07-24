import 'package:flutter/foundation.dart';

import '../models/db_models/get_requests_recieved_model.dart';
import '../services/db_services/requests_db_services.dart';

class RequestsReceivedProvider with ChangeNotifier {
  List<RequestReceivedModel> _requestsReceived = [];

  List<RequestReceivedModel> get requestsReceived => _requestsReceived;

  Future<void> loadRequestsReceived() async {
    final queryResult = await RequestsServices().getRequestsReceived();
    _requestsReceived = queryResult.map((result) => RequestReceivedModel(
      firstName: result['FirstName'],
      lastName: result['LastName'],
      item: result['Item'],
      type: result['Type'],
    )).toList();
    notifyListeners();
  }
}